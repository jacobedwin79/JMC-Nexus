import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_mappers.dart';
import '../../../core/database/database_provider.dart';
import '../domain/clinical_models.dart';
import '../domain/encounter_state.dart';
import '../domain/patient_queue_item.dart';
import 'safety_engine.dart';

class EncounterNotifier extends Notifier<EncounterState> {
  AppDatabase get _db => ref.read(appDatabaseProvider);

  List<ComorbidityModel> _comorbiditiesCatalog = [];
  Map<String, DrugModel> _drugsCatalog = {};
  List<ExamSystemModel> _examSystemsCatalog = [];

  @override
  EncounterState build() {
    _loadCatalogs();
    return const EncounterState();
  }

  Future<void> _loadCatalogs() async {
    final comorbs = await _db.getAllComorbidities();
    _comorbiditiesCatalog = comorbs.map((e) => e.toDomain()).toList();

    final drugs = await _db.getAllDrugs();
    _drugsCatalog = {for (final d in drugs) d.id: d.toDomain()};

    final examSystems = await _db.getAllExaminationSystems();
    _examSystemsCatalog = examSystems.map((e) => e.toDomain()).toList();
  }

  /// 1. Loads a patient from Queue into the active clinical workspace
  Future<void> loadPatient(PatientQueueItem patient) async {
    state = state.copyWith(isLoading: true);

    if (_comorbiditiesCatalog.isEmpty || _drugsCatalog.isEmpty) {
      await _loadCatalogs();
    }

    // Update status in DB to IN_CONSULTATION with consultationStartTime
    final now = DateTime.now();
    await _db.updatePatientQueueStatus(
      id: patient.id,
      status: QueueStatus.inConsultation.dbValue,
      consultationStartTime: now,
    );

    // Initial default-normal systemic examination
    final defaultExamStates = <String, ExamSystemState>{};
    for (final sys in _examSystemsCatalog) {
      defaultExamStates[sys.id] = ExamSystemState(
        systemId: sys.id,
        systemName: sys.systemName,
        isNormal: true,
        selectedAbnormals: const [],
        compiledText: sys.defaultNormalText,
      );
    }

    // Pre-populate patient comorbidity IDs
    final initialComorbs = List<String>.from(patient.initialComorbIds);

    state = EncounterState(
      activePatient: patient.copyWith(
        status: QueueStatus.inConsultation.dbValue,
        consultationStartTime: now,
      ),
      selectedComorbidityIds: initialComorbs,
      selectedComplaints: const {},
      examStates: defaultExamStates,
      selectedDiagnosisIds: const [],
      activePrescription: const [],
      generalAdvice: '',
      followUpDays: 3,
      safetyAlerts: const [],
      isLetterheadMode: false,
      isLoading: false,
    );

    _runSafetyCheck();
  }

  /// 2. Toggle patient comorbidity & run safety checks
  void toggleComorbidity(String comorbidityId) {
    final current = List<String>.from(state.selectedComorbidityIds);
    if (current.contains(comorbidityId)) {
      current.remove(comorbidityId);
    } else {
      current.add(comorbidityId);
    }

    state = state.copyWith(selectedComorbidityIds: current);
    _runSafetyCheck();
  }

  /// 3. Toggle Presenting Complaint
  void toggleComplaint(PresentingComplaintModel complaint) {
    final currentMap = Map<String, SelectedComplaintState>.from(state.selectedComplaints);

    if (currentMap.containsKey(complaint.id)) {
      currentMap.remove(complaint.id);
    } else {
      currentMap[complaint.id] = SelectedComplaintState(
        complaintId: complaint.id,
        complaintName: complaint.name,
        selectedOptions: const {},
        compiledProse: complaint.name,
      );
    }

    state = state.copyWith(selectedComplaints: currentMap);
  }

  /// 4. Sub-Question Option Selection with auto-advancing prose compilation
  void selectSubQuestionOption({
    required String complaintId,
    required String subQuestionId,
    required String option,
    required String sentenceTemplate,
    required bool isMultiSelect,
  }) {
    final currentComplaints = Map<String, SelectedComplaintState>.from(state.selectedComplaints);
    final complaintState = currentComplaints[complaintId];
    if (complaintState == null) return;

    final currentOptionsMap = Map<String, List<String>>.from(complaintState.selectedOptions);
    List<String> currentSelected = List<String>.from(currentOptionsMap[subQuestionId] ?? []);

    if (isMultiSelect) {
      if (currentSelected.contains(option)) {
        currentSelected.remove(option);
      } else {
        currentSelected.add(option);
      }
    } else {
      // Single select: toggle or select
      if (currentSelected.contains(option)) {
        currentSelected.clear();
      } else {
        currentSelected = [option];
      }
    }

    if (currentSelected.isEmpty) {
      currentOptionsMap.remove(subQuestionId);
    } else {
      currentOptionsMap[subQuestionId] = currentSelected;
    }

    // Compile clinical prose for this complaint
    final prose = _compileComplaintProse(complaintState.complaintName, currentOptionsMap);

    currentComplaints[complaintId] = complaintState.copyWith(
      selectedOptions: currentOptionsMap,
      compiledProse: prose,
    );

    state = state.copyWith(selectedComplaints: currentComplaints);
  }

  String _compileComplaintProse(String complaintName, Map<String, List<String>> optionsMap) {
    if (optionsMap.isEmpty) return complaintName;

    final phrases = <String>[];
    for (final entry in optionsMap.entries) {
      if (entry.value.isNotEmpty) {
        phrases.add(entry.value.join(', '));
      }
    }

    if (phrases.isEmpty) return complaintName;
    return '$complaintName (${phrases.join("; ")})';
  }

  /// 5. Systemic Examination Default-Normal overrides
  void toggleExamSystemNormal(String systemId) {
    final currentMap = Map<String, ExamSystemState>.from(state.examStates);
    final current = currentMap[systemId];
    if (current == null) return;

    final defaultText = _examSystemsCatalog
            .where((s) => s.id == systemId)
            .map((s) => s.defaultNormalText)
            .firstOrNull ??
        'Normal';

    final willBeNormal = !current.isNormal;

    currentMap[systemId] = current.copyWith(
      isNormal: willBeNormal,
      selectedAbnormals: willBeNormal ? const [] : current.selectedAbnormals,
      compiledText: willBeNormal ? defaultText : (current.selectedAbnormals.join(', ')),
    );

    state = state.copyWith(examStates: currentMap);
  }

  void toggleExamAbnormalFinding(String systemId, String finding) {
    final currentMap = Map<String, ExamSystemState>.from(state.examStates);
    final current = currentMap[systemId];
    if (current == null) return;

    final abnormals = List<String>.from(current.selectedAbnormals);
    if (abnormals.contains(finding)) {
      abnormals.remove(finding);
    } else {
      abnormals.add(finding);
    }

    final isNormal = abnormals.isEmpty;
    final defaultText = _examSystemsCatalog
            .where((s) => s.id == systemId)
            .map((s) => s.defaultNormalText)
            .firstOrNull ??
        'Normal';

    currentMap[systemId] = current.copyWith(
      isNormal: isNormal,
      selectedAbnormals: abnormals,
      compiledText: isNormal ? defaultText : abnormals.join(', '),
    );

    state = state.copyWith(examStates: currentMap);
  }

  /// 6. Diagnosis Selection & Automatic Protocol Regimen Loading
  Future<void> selectDiagnosis(String diagnosisId) async {
    final currentDiagnoses = List<String>.from(state.selectedDiagnosisIds);
    if (!currentDiagnoses.contains(diagnosisId)) {
      currentDiagnoses.add(diagnosisId);
    }

    // Load matching protocol from SQLite
    final protocolEntry = await _db.getProtocolForDiagnosis(diagnosisId);
    final currentRx = List<PrescriptionItemModel>.from(state.activePrescription);
    String generalAdvice = state.generalAdvice;

    if (protocolEntry != null) {
      final domainProtocol = protocolEntry.toDomain();

      for (final item in domainProtocol.protocolItems) {
        final drug = _drugsCatalog[item.drugId];
        if (drug != null) {
          // Avoid duplicate drugs
          final alreadyAdded = currentRx.any((rx) => rx.drugId == drug.id);
          if (!alreadyAdded) {
            currentRx.add(
              PrescriptionItemModel(
                drugId: drug.id,
                genericName: drug.genericName,
                brandName: drug.brandName,
                drugClass: drug.drugClass,
                dose: item.doseOverride ?? drug.defaultDose,
                route: drug.defaultRoute,
                frequency: item.frequencyOverride ?? drug.defaultFrequency,
                duration: item.durationOverride ?? drug.defaultDuration,
                instructions: item.instructionsOverride ?? drug.defaultInstructions,
              ),
            );
          }
        }
      }

      if (domainProtocol.generalAdvice.isNotEmpty) {
        if (generalAdvice.isEmpty) {
          generalAdvice = domainProtocol.generalAdvice;
        } else if (!generalAdvice.contains(domainProtocol.generalAdvice)) {
          generalAdvice = '$generalAdvice\n${domainProtocol.generalAdvice}';
        }
      }
    }

    state = state.copyWith(
      selectedDiagnosisIds: currentDiagnoses,
      activePrescription: currentRx,
      generalAdvice: generalAdvice,
    );

    _runSafetyCheck();
  }

  void removeDiagnosis(String diagnosisId) {
    final current = List<String>.from(state.selectedDiagnosisIds)..remove(diagnosisId);
    state = state.copyWith(selectedDiagnosisIds: current);
  }

  /// 7. Prescription Builder Modifications
  void addPrescriptionItem(PrescriptionItemModel item) {
    final current = List<PrescriptionItemModel>.from(state.activePrescription);
    current.removeWhere((rx) => rx.drugId == item.drugId);
    current.add(item);
    state = state.copyWith(activePrescription: current);
    _runSafetyCheck();
  }

  void removePrescriptionItem(String drugId) {
    final current = List<PrescriptionItemModel>.from(state.activePrescription)
      ..removeWhere((rx) => rx.drugId == drugId);
    state = state.copyWith(activePrescription: current);
    _runSafetyCheck();
  }

  void updatePrescriptionItem(PrescriptionItemModel updated) {
    final current = List<PrescriptionItemModel>.from(state.activePrescription);
    final idx = current.indexWhere((rx) => rx.drugId == updated.drugId);
    if (idx != -1) {
      current[idx] = updated;
      state = state.copyWith(activePrescription: current);
      _runSafetyCheck();
    }
  }

  void setGeneralAdvice(String advice) {
    state = state.copyWith(generalAdvice: advice);
  }

  void setFollowUpDays(int? days) {
    state = state.copyWith(followUpDays: days);
  }

  void toggleLetterheadMode() {
    state = state.copyWith(isLetterheadMode: !state.isLetterheadMode);
  }

  void clearEncounter() {
    state = const EncounterState();
  }

  /// Completes consultation, stamps completion time, saves compiled prescription snapshot
  Future<void> completeEncounter() async {
    final patient = state.activePatient;
    if (patient == null) return;

    final now = DateTime.now();
    final compiledSnapshot = jsonEncode({
      'complaints': state.selectedComplaints.values.map((c) => c.compiledProse).toList(),
      'examination': state.examStates.values
          .map((e) => {'system': e.systemName, 'findings': e.compiledText})
          .toList(),
      'diagnoses': state.selectedDiagnosisIds,
      'prescription': state.activePrescription.map((p) => p.toJson()).toList(),
      'advice': state.generalAdvice,
      'followUpDays': state.followUpDays,
      'completedAt': now.toIso8601String(),
    });

    await _db.updatePatientQueueStatus(
      id: patient.id,
      status: QueueStatus.completed.dbValue,
      completionTime: now,
      compiledPrescriptionJson: compiledSnapshot,
    );

    clearEncounter();
  }

  void _runSafetyCheck() {
    final alerts = SafetyEngine.evaluate(
      selectedComorbidityIds: state.selectedComorbidityIds,
      activePrescription: state.activePrescription,
      comorbiditiesCatalog: _comorbiditiesCatalog,
    );
    state = state.copyWith(safetyAlerts: alerts);
  }
}

final encounterProvider =
    NotifierProvider<EncounterNotifier, EncounterState>(EncounterNotifier.new);

