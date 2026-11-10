import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_mappers.dart';
import '../../../core/database/database_provider.dart';
import '../domain/clinical_models.dart';
import '../domain/encounter_state.dart';
import '../domain/gemini_scribe_models.dart';
import '../domain/patient_queue_item.dart';
import 'safety_engine.dart';

class EncounterNotifier extends Notifier<EncounterState> {
  static const _uuid = Uuid();
  static const String appVersion = '1.0.0';

  AppDatabase get _db => ref.read(appDatabaseProvider);

  List<ComorbidityModel> _comorbiditiesCatalog = [];
  Map<String, DrugModel> _drugsCatalog = {};
  List<ExamSystemModel> _examSystemsCatalog = [];
  Map<String, DiagnosisModel> _diagnosesCatalog = {};

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

    final diagnoses = await _db.getAllDiagnoses();
    _diagnosesCatalog = {for (final d in diagnoses) d.id: d.toDomain()};
  }

  /// 1. Loads a patient from Queue into the active clinical workspace
  Future<void> loadPatient(PatientQueueItem patient) async {
    state = state.copyWith(isLoading: true);

    // Always refresh catalogs so recent edits in Catalog Manager take immediate effect
    await _loadCatalogs();

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

    // Pre-populate patient comorbidity IDs, allergies, LMP & Pregnancy
    final initialComorbs = List<String>.from(patient.initialComorbIds);
    final initialAllergies = List<String>.from(patient.allergies);
    final isPregnant =
        patient.isPregnant || initialComorbs.contains('comorb_pregnant');

    // Attempt to restore autosaved draft if present
    Map<String, SelectedComplaintState> restoredComplaints = {};
    Map<String, ExamSystemState> restoredExams = defaultExamStates;
    List<String> restoredDiagnoses = [];
    List<PrescriptionItemModel> restoredRx = [];
    List<String> restoredInvestigations = [];
    String restoredAdvice = '';
    int? restoredFollowUp; // Explicitly null by default (no hardcoded default)
    String? restoredOverrideReason;
    bool restoredPrintDiagnosis = true;

    if (patient.compiledPrescriptionJson != null &&
        patient.compiledPrescriptionJson!.isNotEmpty) {
      try {
        final decoded =
            jsonDecode(patient.compiledPrescriptionJson!)
                as Map<String, dynamic>;
        if (decoded['isDraft'] == true) {
          if (decoded['diagnoses'] is List) {
            restoredDiagnoses = (decoded['diagnoses'] as List).cast<String>();
          }
          if (decoded['prescription'] is List) {
            restoredRx = (decoded['prescription'] as List)
                .map(
                  (item) => PrescriptionItemModel.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList();
          }
          if (decoded['investigations'] is List) {
            restoredInvestigations = (decoded['investigations'] as List)
                .cast<String>();
          }
          if (decoded['advice'] is String) {
            restoredAdvice = decoded['advice'] as String;
          }
          if (decoded['followUpDays'] is int) {
            restoredFollowUp = decoded['followUpDays'] as int;
          }
          if (decoded['overrideReason'] is String) {
            restoredOverrideReason = decoded['overrideReason'] as String;
          }
          if (decoded['printDiagnosis'] is bool) {
            restoredPrintDiagnosis = decoded['printDiagnosis'] as bool;
          }
        }
      } catch (_) {}
    }

    state = EncounterState(
      activePatient: patient.copyWith(
        status: QueueStatus.inConsultation.dbValue,
        consultationStartTime: now,
      ),
      selectedComorbidityIds: initialComorbs,
      allergies: initialAllergies,
      lmp: patient.lmp,
      isPregnant: isPregnant,
      selectedComplaints: restoredComplaints,
      examStates: restoredExams,
      selectedDiagnosisIds: restoredDiagnoses,
      activePrescription: restoredRx,
      investigations: restoredInvestigations,
      generalAdvice: restoredAdvice,
      followUpDays: restoredFollowUp,
      overrideReason: restoredOverrideReason,
      printDiagnosis: restoredPrintDiagnosis,
      safetyAlerts: const [],
      isLetterheadMode: false,
      isLoading: false,
    );

    _runSafetyCheck();
  }

  void toggleAllergy(String allergy) {
    final current = List<String>.from(state.allergies);
    final trimmed = allergy.trim();
    if (trimmed.isEmpty) return;

    if (current.contains(trimmed)) {
      current.remove(trimmed);
    } else {
      current.add(trimmed);
    }

    state = state.copyWith(allergies: current);
    _runSafetyCheck();
    autosaveDraft();
  }

  void setLmp(String? lmp) {
    final trimmed = lmp?.trim();
    final hasLmp = trimmed != null && trimmed.isNotEmpty;
    state = state.copyWith(
      lmp: trimmed,
      isPregnant: hasLmp ? true : state.isPregnant,
    );
    _runSafetyCheck();
    autosaveDraft();
  }

  void setIsPregnant(bool val) {
    state = state.copyWith(isPregnant: val);
    _runSafetyCheck();
    autosaveDraft();
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

  /// Adds a user-defined comorbidity to the local catalog and selects it.
  Future<ComorbidityModel?> addCustomComorbidity(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;

    final existing = _comorbiditiesCatalog
        .where((c) => c.name.toLowerCase() == trimmed.toLowerCase())
        .firstOrNull;
    if (existing != null) {
      if (!state.selectedComorbidityIds.contains(existing.id)) {
        toggleComorbidity(existing.id);
      }
      return existing;
    }

    final id = 'comorb_custom_${_uuid.v4()}';
    final model = ComorbidityModel(
      id: id,
      name: trimmed,
      contraindicatedDrugClasses: const [],
    );

    await _db.insertComorbidity(
      ComorbiditiesTableCompanion.insert(
        id: id,
        name: trimmed,
        contraindicatedDrugClasses: jsonEncode(const <String>[]),
      ),
    );

    _comorbiditiesCatalog = [..._comorbiditiesCatalog, model];
    toggleComorbidity(id);
    return model;
  }

  /// Reloads the clinical catalogs
  Future<void> reloadCatalogs() async {
    await _loadCatalogs();
    _runSafetyCheck();
  }

  /// 3. Toggle Presenting Complaint
  void toggleComplaint(PresentingComplaintModel complaint) {
    final currentMap = Map<String, SelectedComplaintState>.from(
      state.selectedComplaints,
    );

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

  /// Free-Text Fallback: Adds custom complaint and automatically logs unmapped term
  Future<void> addCustomComplaint(String customName) async {
    final trimmed = customName.trim();
    if (trimmed.isEmpty) return;

    final id = 'complaint_custom_${_uuid.v4().substring(0, 8)}';
    final currentMap = Map<String, SelectedComplaintState>.from(
      state.selectedComplaints,
    );

    currentMap[id] = SelectedComplaintState(
      complaintId: id,
      complaintName: trimmed,
      selectedOptions: const {},
      compiledProse: trimmed,
    );

    state = state.copyWith(selectedComplaints: currentMap);

    // Automatically log unmapped text so catalog grows organically
    await _db.logUnmappedTerm(
      id: _uuid.v4(),
      category: 'complaint',
      term: trimmed,
      encounterId: state.activePatient?.id,
    );
  }

  void removeComplaint(String complaintId) {
    final currentMap = Map<String, SelectedComplaintState>.from(
      state.selectedComplaints,
    )..remove(complaintId);
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
    final currentComplaints = Map<String, SelectedComplaintState>.from(
      state.selectedComplaints,
    );
    final complaintState = currentComplaints[complaintId];
    if (complaintState == null) return;

    final currentOptionsMap = Map<String, List<String>>.from(
      complaintState.selectedOptions,
    );
    List<String> currentSelected = List<String>.from(
      currentOptionsMap[subQuestionId] ?? [],
    );

    if (isMultiSelect) {
      if (currentSelected.contains(option)) {
        currentSelected.remove(option);
      } else {
        currentSelected.add(option);
      }
    } else {
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

    final prose = _compileComplaintProse(
      complaintState.complaintName,
      currentOptionsMap,
    );

    currentComplaints[complaintId] = complaintState.copyWith(
      selectedOptions: currentOptionsMap,
      compiledProse: prose,
    );

    state = state.copyWith(selectedComplaints: currentComplaints);
  }

  String _compileComplaintProse(
    String complaintName,
    Map<String, List<String>> optionsMap,
  ) {
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

    final defaultText =
        _examSystemsCatalog
            .where((s) => s.id == systemId)
            .map((s) => s.defaultNormalText)
            .firstOrNull ??
        'Normal';

    final willBeNormal = !current.isNormal;

    currentMap[systemId] = current.copyWith(
      isNormal: willBeNormal,
      selectedAbnormals: willBeNormal ? const [] : current.selectedAbnormals,
      compiledText: willBeNormal
          ? defaultText
          : (current.selectedAbnormals.join(', ')),
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
    final defaultText =
        _examSystemsCatalog
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

  /// Free-Text Fallback: Adds custom abnormal exam finding and logs unmapped term
  Future<void> addCustomExamFinding(String systemId, String finding) async {
    final trimmed = finding.trim();
    if (trimmed.isEmpty) return;

    toggleExamAbnormalFinding(systemId, trimmed);

    await _db.logUnmappedTerm(
      id: _uuid.v4(),
      category: 'examination',
      term: trimmed,
      encounterId: state.activePatient?.id,
    );
  }

  /// 6. Diagnosis Selection & Automatic Protocol Regimen Loading
  Future<void> selectDiagnosis(String diagnosisId) async {
    final currentDiagnoses = List<String>.from(state.selectedDiagnosisIds);
    if (!currentDiagnoses.contains(diagnosisId)) {
      currentDiagnoses.add(diagnosisId);
    }

    final protocolEntry = await _db.getProtocolForDiagnosis(diagnosisId);
    final currentRx = List<PrescriptionItemModel>.from(
      state.activePrescription,
    );
    String generalAdvice = state.generalAdvice;

    if (protocolEntry != null) {
      final domainProtocol = protocolEntry.toDomain();

      for (final item in domainProtocol.protocolItems) {
        final drug = _drugsCatalog[item.drugId];
        if (drug != null) {
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
                instructions:
                    item.instructionsOverride ?? drug.defaultInstructions,
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

  /// Free-Text Fallback: Adds custom diagnosis and logs unmapped term
  Future<void> addCustomDiagnosis(String customName) async {
    final trimmed = customName.trim();
    if (trimmed.isEmpty) return;

    final id = 'diag_custom_${_uuid.v4().substring(0, 8)}';
    final model = DiagnosisModel(
      id: id,
      name: trimmed,
      linkedComplaintIds: const [],
    );

    _diagnosesCatalog[id] = model;

    final currentDiagnoses = List<String>.from(state.selectedDiagnosisIds);
    if (!currentDiagnoses.contains(id)) {
      currentDiagnoses.add(id);
    }

    state = state.copyWith(selectedDiagnosisIds: currentDiagnoses);

    await _db.logUnmappedTerm(
      id: _uuid.v4(),
      category: 'diagnosis',
      term: trimmed,
      encounterId: state.activePatient?.id,
    );
  }

  void removeDiagnosis(String diagnosisId) {
    final current = List<String>.from(state.selectedDiagnosisIds)
      ..remove(diagnosisId);
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

  /// "Repeat Last Rx" for returning patients:
  /// Loads medication regimen from patient's previous completed visit.
  Future<bool> repeatLastPrescription() async {
    final patientId = state.activePatient?.patientId;
    if (patientId == null || patientId.trim().isEmpty) return false;

    final visits = await _db.getVisitHistoryForPatient(patientId);
    if (visits.isEmpty) return false;

    // Latest completed visit
    final latestVisit = visits.first;
    final jsonStr =
        latestVisit.encounterSnapshotJson ??
        latestVisit.compiledPrescriptionJson;
    if (jsonStr == null || jsonStr.isEmpty) return false;

    try {
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      final rxList = decoded['prescription'];
      if (rxList is List && rxList.isNotEmpty) {
        final repeatedItems = rxList
            .map(
              (item) =>
                  PrescriptionItemModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();

        state = state.copyWith(activePrescription: repeatedItems);
        _runSafetyCheck();
        return true;
      }
    } catch (_) {}

    return false;
  }

  /// 8. Dedicated Investigations Module
  void toggleInvestigation(String investigation) {
    final current = List<String>.from(state.investigations);
    final trimmed = investigation.trim();
    if (trimmed.isEmpty) return;

    if (current.contains(trimmed)) {
      current.remove(trimmed);
    } else {
      current.add(trimmed);
    }
    state = state.copyWith(investigations: current);
  }

  void addCustomInvestigation(String investigation) {
    final trimmed = investigation.trim();
    if (trimmed.isEmpty) return;

    final current = List<String>.from(state.investigations);
    if (!current.contains(trimmed)) {
      current.add(trimmed);
      state = state.copyWith(investigations: current);
    }
  }

  void removeInvestigation(String investigation) {
    final current = List<String>.from(state.investigations)
      ..remove(investigation);
    state = state.copyWith(investigations: current);
  }

  void setGeneralAdvice(String advice) {
    state = state.copyWith(generalAdvice: advice);
  }

  void setFollowUpDays(int? days) {
    state = state.copyWith(followUpDays: days);
  }

  void setOverrideReason(String reason) {
    state = state.copyWith(overrideReason: reason.trim());
  }

  void setPrintDiagnosis(bool printDiagnosis) {
    state = state.copyWith(printDiagnosis: printDiagnosis);
  }

  void toggleLetterheadMode() {
    state = state.copyWith(isLetterheadMode: !state.isLetterheadMode);
  }

  /// Merges incremental updates from Gemini AI Voice Scribe into the current encounter.
  Future<void> applyAiScribeUpdate(GeminiScribeResult result) async {
    // 1. Merge complaints
    final updatedComplaints =
        Map<String, SelectedComplaintState>.from(state.selectedComplaints);
    for (final c in result.complaints) {
      if (c.complaintId.isNotEmpty) {
        final existing = updatedComplaints[c.complaintId];
        updatedComplaints[c.complaintId] = SelectedComplaintState(
          complaintId: c.complaintId,
          complaintName: c.complaintName.isNotEmpty
              ? c.complaintName
              : (existing?.complaintName ?? c.complaintId),
          selectedOptions: existing?.selectedOptions ?? const {},
          compiledProse: c.compiledProse.isNotEmpty
              ? c.compiledProse
              : (existing?.compiledProse ?? ''),
        );
      }
    }

    // 2. Merge exam states
    final updatedExams = Map<String, ExamSystemState>.from(state.examStates);
    for (final e in result.exams) {
      if (e.systemId.isNotEmpty) {
        final existing = updatedExams[e.systemId];
        updatedExams[e.systemId] = ExamSystemState(
          systemId: e.systemId,
          systemName: existing?.systemName ??
              e.systemId.replaceAll('sys_', '').toUpperCase(),
          isNormal: e.isNormal,
          selectedAbnormals: e.abnormalFindings.isNotEmpty
              ? e.abnormalFindings
              : (existing?.selectedAbnormals ?? const []),
          compiledText: e.compiledText.isNotEmpty
              ? e.compiledText
              : (existing?.compiledText ?? ''),
        );
      }
    }

    // 3. Merge diagnoses
    final updatedDiagnoses = List<String>.from(state.selectedDiagnosisIds);
    for (final d in result.diagnoses) {
      if (d.diagnosisId.isNotEmpty && !updatedDiagnoses.contains(d.diagnosisId)) {
        updatedDiagnoses.add(d.diagnosisId);
        if (!_diagnosesCatalog.containsKey(d.diagnosisId)) {
          _diagnosesCatalog[d.diagnosisId] = DiagnosisModel(
            id: d.diagnosisId,
            name: d.diagnosisName.isNotEmpty ? d.diagnosisName : d.diagnosisId,
            icd10Code: d.icd10Code,
            linkedComplaintIds: const [],
          );
        }
      }
    }

    // 4. Merge prescriptions
    final updatedRx =
        List<PrescriptionItemModel>.from(state.activePrescription);
    for (final rx in result.prescriptions) {
      final existingIdx = updatedRx.indexWhere(
        (p) =>
            p.drugId == rx.drugId ||
            (rx.brandName.isNotEmpty &&
                p.brandName.toLowerCase() == rx.brandName.toLowerCase()),
      );
      if (existingIdx != -1) {
        updatedRx[existingIdx] = rx;
      } else {
        updatedRx.add(rx);
      }
    }

    // 5. Merge investigations
    final updatedInvs = List<String>.from(state.investigations);
    for (final inv in result.investigations) {
      final trimmed = inv.trim();
      if (trimmed.isNotEmpty && !updatedInvs.contains(trimmed)) {
        updatedInvs.add(trimmed);
      }
    }

    // 6. Advice & follow-up
    String updatedAdvice = state.generalAdvice;
    if (result.generalAdvice != null &&
        result.generalAdvice!.trim().isNotEmpty) {
      final newAdvice = result.generalAdvice!.trim();
      if (updatedAdvice.isEmpty) {
        updatedAdvice = newAdvice;
      } else if (!updatedAdvice.contains(newAdvice)) {
        updatedAdvice = '$updatedAdvice\n$newAdvice';
      }
    }

    int? updatedFollowUp = result.followUpDays ?? state.followUpDays;

    state = state.copyWith(
      selectedComplaints: updatedComplaints,
      examStates: updatedExams,
      selectedDiagnosisIds: updatedDiagnoses,
      activePrescription: updatedRx,
      investigations: updatedInvs,
      generalAdvice: updatedAdvice,
      followUpDays: updatedFollowUp,
    );

    _runSafetyCheck();
    await autosaveDraft();
  }

  Future<void> autosaveDraft() async {
    final patient = state.activePatient;
    if (patient == null) return;

    try {
      final draftSnapshot = jsonEncode({
        'isDraft': true,
        'diagnoses': state.selectedDiagnosisIds,
        'prescription': state.activePrescription
            .map((p) => p.toJson())
            .toList(),
        'investigations': state.investigations,
        'advice': state.generalAdvice,
        'followUpDays': state.followUpDays,
        'overrideReason': state.overrideReason,
        'printDiagnosis': state.printDiagnosis,
        'savedAt': DateTime.now().toIso8601String(),
      });

      await _db.saveEncounterDraft(id: patient.id, draftJson: draftSnapshot);
      state = state.copyWith(lastDraftSavedAt: DateTime.now());
    } catch (_) {}
  }

  Future<void> clearEncounter({bool releaseToQueue = true}) async {
    final patient = state.activePatient;
    if (releaseToQueue &&
        patient != null &&
        patient.status == QueueStatus.inConsultation.dbValue) {
      await _db.releaseConsultation(patient.id);
    }
    state = const EncounterState();
  }

  /// Completes consultation with safety validations and stores denormalized snapshot
  Future<void> completeEncounter({String? explicitOverrideReason}) async {
    final patient = state.activePatient;
    if (patient == null) return;

    final effectiveOverrideReason =
        (explicitOverrideReason?.trim().isNotEmpty == true)
        ? explicitOverrideReason!.trim()
        : state.overrideReason?.trim();

    // 1. Mandatory Hard-Block for Critical Safety Alerts
    if (state.hasCriticalSafetyAlert &&
        (effectiveOverrideReason == null || effectiveOverrideReason.isEmpty)) {
      throw StateError(
        'Cannot complete encounter: Critical safety alerts require a clinical override justification.',
      );
    }

    // 2. Mandatory Follow-up Selection
    if (state.followUpDays == null) {
      throw StateError(
        'Cannot complete encounter: Follow-up duration selection is mandatory.',
      );
    }

    final now = DateTime.now();

    // 3. Denormalized Encounter Snapshotting
    // Captures diagnosis names, drug versions, triggered safety alerts, override reasons,
    // investigations, and app version to guarantee immutability against future catalog edits.
    final denormalizedDiagnoses = state.selectedDiagnosisIds.map((id) {
      final model = _diagnosesCatalog[id];
      return {
        'id': id,
        'name': model?.name ?? id.replaceAll('diag_', '').toUpperCase(),
        'icd10Code': model?.icd10Code,
      };
    }).toList();

    final denormalizedPrescription = state.activePrescription
        .map((p) => p.toJson())
        .toList();

    final denormalizedSnapshot = jsonEncode({
      'appVersion': appVersion,
      'completedAt': now.toIso8601String(),
      'consultationStartTime': patient.consultationStartTime?.toIso8601String(),
      'patientId': patient.patientId,
      'tokenNumber': patient.tokenNumber,
      'patientName': patient.patientName,
      'ageDisplay': patient.dynamicAgeDisplay,
      'gender': patient.gender,
      'complaints': state.selectedComplaints.values
          .map(
            (c) => {
              'complaintId': c.complaintId,
              'complaintName': c.complaintName,
              'compiledProse': c.compiledProse,
            },
          )
          .toList(),
      'examination': state.examStates.values
          .map(
            (e) => {
              'systemId': e.systemId,
              'systemName': e.systemName,
              'isNormal': e.isNormal,
              'findings': e.compiledText,
            },
          )
          .toList(),
      'diagnoses': denormalizedDiagnoses,
      'prescription': denormalizedPrescription,
      'investigations': state.investigations,
      'advice': state.generalAdvice,
      'followUpDays': state.followUpDays,
      'safetyAlerts': state.safetyAlerts.map((a) => a.toJson()).toList(),
      'overrideReason': effectiveOverrideReason,
      'printDiagnosis': state.printDiagnosis,
    });

    // Update DB with completion status and denormalized snapshots
    await _db.updatePatientQueueStatus(
      id: patient.id,
      status: QueueStatus.completed.dbValue,
      completionTime: now,
      compiledPrescriptionJson: denormalizedSnapshot,
      encounterSnapshotJson: denormalizedSnapshot,
      overrideReason: effectiveOverrideReason,
    );

    // Record drug usage frequencies so top 20 medications stay up to date
    for (final item in state.activePrescription) {
      await _db.recordDrugUsage(item.drugId);
    }

    await clearEncounter(releaseToQueue: false);
  }

  void _runSafetyCheck() {
    final vitals = PatientVitals.fromJson(state.activePatient?.vitals ?? {});
    final alerts = SafetyEngine.evaluate(
      selectedComorbidityIds: state.selectedComorbidityIds,
      activePrescription: state.activePrescription,
      comorbiditiesCatalog: _comorbiditiesCatalog,
      allergies: state.allergies,
      patientAge:
          state.activePatient?.calculatedAge ?? state.activePatient?.age,
      patientWeight: vitals.weight,
      isPregnant: state.isPregnant,
    );
    state = state.copyWith(safetyAlerts: alerts);
  }
}

final encounterProvider = NotifierProvider<EncounterNotifier, EncounterState>(
  EncounterNotifier.new,
);
