import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_mappers.dart';
import '../../../core/database/database_provider.dart';
import '../../encounter/domain/clinical_models.dart';
import '../../encounter/domain/patient_queue_item.dart';

class ReceptionFormState {
  final int nextTokenNumber;
  final String? patientId;
  final String patientName;
  final int? age;
  final String gender;
  final String? phone;
  final PatientVitals vitals;
  final List<String> selectedComorbIds;
  final List<String> selectedAllergies;
  final String? lmp;
  final bool isPregnant;
  final bool isSubmitting;
  final String? errorMessage;
  final String? lastGeneratedTokenMessage;

  const ReceptionFormState({
    this.nextTokenNumber = 1,
    this.patientId,
    this.patientName = '',
    this.age,
    this.gender = 'M',
    this.phone,
    this.vitals = const PatientVitals(),
    this.selectedComorbIds = const [],
    this.selectedAllergies = const [],
    this.lmp,
    this.isPregnant = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.lastGeneratedTokenMessage,
  });

  bool get isValid => patientName.trim().isNotEmpty && age != null && age! > 0;

  ReceptionFormState copyWith({
    int? nextTokenNumber,
    String? patientId,
    String? patientName,
    int? age,
    String? gender,
    String? phone,
    PatientVitals? vitals,
    List<String>? selectedComorbIds,
    List<String>? selectedAllergies,
    String? lmp,
    bool? isPregnant,
    bool? isSubmitting,
    String? errorMessage,
    String? lastGeneratedTokenMessage,
    bool clearError = false,
    bool clearLastGenerated = false,
    bool clearPatientId = false,
    bool clearPhone = false,
    bool clearLmp = false,
  }) {
    return ReceptionFormState(
      nextTokenNumber: nextTokenNumber ?? this.nextTokenNumber,
      patientId: clearPatientId ? null : (patientId ?? this.patientId),
      patientName: patientName ?? this.patientName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: clearPhone ? null : (phone ?? this.phone),
      vitals: vitals ?? this.vitals,
      selectedComorbIds: selectedComorbIds ?? this.selectedComorbIds,
      selectedAllergies: selectedAllergies ?? this.selectedAllergies,
      lmp: clearLmp ? null : (lmp ?? this.lmp),
      isPregnant: isPregnant ?? this.isPregnant,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastGeneratedTokenMessage: clearLastGenerated
          ? null
          : (lastGeneratedTokenMessage ?? this.lastGeneratedTokenMessage),
    );
  }
}

class ReceptionNotifier extends Notifier<ReceptionFormState> {
  static const _uuid = Uuid();

  AppDatabase get _db => ref.read(appDatabaseProvider);

  @override
  ReceptionFormState build() {
    Future.microtask(() => refreshNextToken());
    return const ReceptionFormState();
  }

  Future<void> refreshNextToken() async {
    final nextToken = await _db.getNextTokenNumberForToday();
    state = state.copyWith(nextTokenNumber: nextToken);
  }

  void setPatientName(String name) {
    state = state.copyWith(patientName: name, clearError: true);
  }

  void setPatientId(String? patientId) {
    final trimmed = patientId?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      state = state.copyWith(clearPatientId: true);
    } else {
      state = state.copyWith(patientId: trimmed);
    }
  }

  void setAge(int? age) {
    state = state.copyWith(age: age, clearError: true);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setPhone(String? phone) {
    state = state.copyWith(phone: phone);
  }

  void setBpSys(int? val) {
    state = state.copyWith(vitals: state.vitals.copyWith(bpSys: val));
  }

  void setBpDia(int? val) {
    state = state.copyWith(vitals: state.vitals.copyWith(bpDia: val));
  }

  void setPulse(int? val) {
    state = state.copyWith(vitals: state.vitals.copyWith(pulse: val));
  }

  void setSpo2(int? val) {
    state = state.copyWith(vitals: state.vitals.copyWith(spo2: val));
  }

  void setTemp(double? val) {
    state = state.copyWith(vitals: state.vitals.copyWith(temp: val));
  }

  void setTempIsCelsius(bool val) {
    state = state.copyWith(vitals: state.vitals.copyWith(tempIsCelsius: val));
  }

  void setWeight(double? val) {
    state = state.copyWith(vitals: state.vitals.copyWith(weight: val));
  }

  void setRbs(int? val) {
    state = state.copyWith(vitals: state.vitals.copyWith(rbs: val));
  }

  void updateVitals({
    int? bpSys,
    int? bpDia,
    int? pulse,
    int? spo2,
    double? temp,
    double? weight,
    int? rbs,
    bool? tempIsCelsius,
  }) {
    state = state.copyWith(
      vitals: PatientVitals(
        bpSys: bpSys,
        bpDia: bpDia,
        pulse: pulse,
        spo2: spo2,
        temp: temp,
        weight: weight,
        rbs: rbs,
        tempIsCelsius: tempIsCelsius ?? state.vitals.tempIsCelsius,
      ),
    );
  }

  void toggleAllergy(String allergy) {
    final current = List<String>.from(state.selectedAllergies);
    final trimmed = allergy.trim();
    if (trimmed.isEmpty) return;

    if (current.contains(trimmed)) {
      current.remove(trimmed);
    } else {
      current.add(trimmed);
    }
    state = state.copyWith(selectedAllergies: current);
  }

  void setAllergies(List<String> allergies) {
    state = state.copyWith(selectedAllergies: allergies);
  }

  void setLmp(String? lmp) {
    final trimmed = lmp?.trim();
    final hasLmp = trimmed != null && trimmed.isNotEmpty;
    state = state.copyWith(
      lmp: trimmed,
      clearLmp: !hasLmp,
      isPregnant: hasLmp ? true : state.isPregnant,
    );
  }

  void setIsPregnant(bool val) {
    state = state.copyWith(isPregnant: val);
  }

  void toggleComorbidity(String comorbId) {
    final current = List<String>.from(state.selectedComorbIds);
    if (current.contains(comorbId)) {
      current.remove(comorbId);
    } else {
      current.add(comorbId);
    }
    state = state.copyWith(selectedComorbIds: current);
  }

  /// Searches prior visits so a returning patient can be reloaded quickly.
  Future<List<PatientQueueItem>> searchPreviousPatients(String query) async {
    final entries = await _db.searchPreviousPatients(query);
    // De-duplicate to the most recent visit per persistent patient identity.
    final seen = <String>{};
    final results = <PatientQueueItem>[];
    for (final entry in entries) {
      final key = entry.patientId?.trim().isNotEmpty == true
          ? 'pid:${entry.patientId!.trim().toLowerCase()}'
          : (entry.phone?.trim().isNotEmpty == true
              ? 'ph:${entry.phone!.trim()}'
              : 'name:${entry.patientName.trim().toLowerCase()}|${entry.age}|${entry.gender}');
      if (seen.add(key)) {
        results.add(entry.toDomain());
      }
    }
    return results;
  }

  /// Pre-fills the registration form from a previous visit record.
  void prefillFromPreviousPatient(PatientQueueItem patient) {
    state = ReceptionFormState(
      nextTokenNumber: state.nextTokenNumber,
      patientId: patient.patientId,
      patientName: patient.patientName,
      age: patient.age,
      gender: patient.gender,
      phone: patient.phone,
      vitals: PatientVitals.fromJson(patient.vitals),
      selectedComorbIds: List<String>.from(patient.initialComorbIds),
      selectedAllergies: List<String>.from(patient.allergies),
      lmp: patient.lmp,
      isPregnant: patient.isPregnant,
    );
  }

  /// Adds a user-defined comorbidity to the local catalog and selects it.
  Future<ComorbidityModel?> addCustomComorbidity(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;

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

    toggleComorbidity(id);
    return model;
  }

  Future<int?> registerAndGenerateToken() async {
    if (!state.isValid) {
      state = state.copyWith(
        errorMessage: 'Please enter patient name and a valid age.',
      );
      return null;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final token = await _db.getNextTokenNumberForToday();
      final id = _uuid.v4();
      final now = DateTime.now();

      final vitalsJson = state.vitals.hasAnyVitals
          ? jsonEncode(state.vitals.toJson())
          : null;

      final comorbsJson = state.selectedComorbIds.isNotEmpty
          ? jsonEncode(state.selectedComorbIds)
          : null;

      final allergiesJson = state.selectedAllergies.isNotEmpty
          ? jsonEncode(state.selectedAllergies)
          : null;

      final assignedPatientId =
          (state.patientId != null && state.patientId!.trim().isNotEmpty)
              ? state.patientId!.trim()
              : 'JMC-P-${_uuid.v4().substring(0, 8).toUpperCase()}';

      await _db.insertPatientQueue(
        PatientQueueTableCompanion.insert(
          id: id,
          patientId: drift.Value(assignedPatientId),
          tokenNumber: token,
          patientName: state.patientName.trim(),
          age: state.age!,
          gender: state.gender,
          phone: drift.Value(state.phone?.trim()),
          vitalsJson: drift.Value(vitalsJson),
          initialComorbIds: drift.Value(comorbsJson),
          allergies: drift.Value(allergiesJson),
          lmp: drift.Value(state.lmp),
          isPregnant: drift.Value(state.isPregnant),
          status: 'WAITING',
          entryTime: now,
        ),
      );

      final nextToken = await _db.getNextTokenNumberForToday();

      // Reset form
      state = ReceptionFormState(
        nextTokenNumber: nextToken,
        lastGeneratedTokenMessage: 'Token #$token successfully generated for ${state.patientName.trim()}!',
      );

      return token;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to issue token: $e',
      );
      return null;
    }
  }

  /// Helper for testing & SLA demonstration: seeds a patient with a specific elapsed wait time
  Future<int> registerMockPatientWithElapsedWait({
    required String name,
    required int age,
    required String gender,
    required Duration elapsedWait,
    String? patientId,
    List<String> comorbs = const [],
    PatientVitals vitals = const PatientVitals(),
  }) async {
    final token = await _db.getNextTokenNumberForToday();
    final id = _uuid.v4();
    final entryTime = DateTime.now().subtract(elapsedWait);

    final vitalsJson = vitals.hasAnyVitals ? jsonEncode(vitals.toJson()) : null;
    final comorbsJson = comorbs.isNotEmpty ? jsonEncode(comorbs) : null;

    await _db.insertPatientQueue(
      PatientQueueTableCompanion.insert(
        id: id,
        patientId: drift.Value(patientId),
        tokenNumber: token,
        patientName: name,
        age: age,
        gender: gender,
        phone: const drift.Value('9876543210'),
        vitalsJson: drift.Value(vitalsJson),
        initialComorbIds: drift.Value(comorbsJson),
        status: 'WAITING',
        entryTime: entryTime,
      ),
    );

    await refreshNextToken();
    return token;
  }
}

final receptionProvider =
    NotifierProvider<ReceptionNotifier, ReceptionFormState>(ReceptionNotifier.new);
