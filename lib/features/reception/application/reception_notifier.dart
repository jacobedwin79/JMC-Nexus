import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_mappers.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/utils/age_calculator.dart';
import '../../encounter/domain/clinical_models.dart';
import '../../encounter/domain/patient_queue_item.dart';

class ReceptionFormState {
  final int nextTokenNumber;
  final String? patientId;
  final String patientName;
  final int? age;
  final DateTime? dateOfBirth;
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
    this.dateOfBirth,
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

  /// Dynamic age display based on Date of Birth
  String get dynamicAgeDisplay {
    if (dateOfBirth != null) {
      return AgeCalculator.formatAge(dateOfBirth!);
    }
    if (age != null && age! > 0) {
      return '$age ${age == 1 ? "year" : "years"}';
    }
    return '';
  }

  /// Calculates numeric age in years
  int? get effectiveAgeInYears {
    if (dateOfBirth != null) {
      return AgeCalculator.calculateYears(dateOfBirth!);
    }
    return age;
  }

  /// Whether patient is paediatric (< 12 years)
  bool get isPaediatric => (effectiveAgeInYears ?? 100) < 12;

  bool get isValid {
    final hasName = patientName.trim().isNotEmpty;
    final hasAgeOrDob = dateOfBirth != null || (age != null && age! > 0);
    final hasWeightIfPediatric =
        !isPaediatric || (vitals.weight != null && vitals.weight! > 0);
    return hasName && hasAgeOrDob && hasWeightIfPediatric;
  }

  ReceptionFormState copyWith({
    int? nextTokenNumber,
    String? patientId,
    String? patientName,
    int? age,
    DateTime? dateOfBirth,
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
    bool clearDob = false,
  }) {
    return ReceptionFormState(
      nextTokenNumber: nextTokenNumber ?? this.nextTokenNumber,
      patientId: clearPatientId ? null : (patientId ?? this.patientId),
      patientName: patientName ?? this.patientName,
      age: age ?? this.age,
      dateOfBirth: clearDob ? null : (dateOfBirth ?? this.dateOfBirth),
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

  void setDateOfBirth(DateTime? dob) {
    if (dob == null) {
      state = state.copyWith(clearDob: true, clearError: true);
    } else {
      final calculatedYears = AgeCalculator.calculateYears(dob);
      state = state.copyWith(
        dateOfBirth: dob,
        age: calculatedYears,
        clearError: true,
      );
    }
  }

  void setAge(int? age) {
    if (age == null) {
      state = state.copyWith(age: null, clearDob: true, clearError: true);
    } else {
      final estimatedDob = AgeCalculator.dobFromAgeInYears(age);
      state = state.copyWith(
        age: age,
        dateOfBirth: estimatedDob,
        clearError: true,
      );
    }
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
    state = state.copyWith(
      vitals: state.vitals.copyWith(weight: val),
      clearError: true,
    );
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
      clearError: true,
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
      dateOfBirth: patient.dateOfBirth,
      gender: patient.gender,
      phone: patient.phone,
      vitals: PatientVitals.fromJson(patient.vitals),
      selectedComorbIds: List<String>.from(patient.initialComorbIds),
      selectedAllergies: List<String>.from(patient.allergies),
      lmp: patient.lmp,
      isPregnant: patient.isPregnant,
    );
  }

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
    if (state.patientName.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter patient name.');
      return null;
    }

    if (state.dateOfBirth == null && (state.age == null || state.age! <= 0)) {
      state = state.copyWith(
        errorMessage: 'Please enter a valid Date of Birth or age.',
      );
      return null;
    }

    // Pediatric validation rule: Weight is strictly mandatory if calculated age is under 12 years
    if (state.isPaediatric &&
        (state.vitals.weight == null || state.vitals.weight! <= 0)) {
      state = state.copyWith(
        errorMessage:
            'Weight is mandatory for paediatric patients under 12 years of age.',
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

      final effectiveAge = state.effectiveAgeInYears ?? 0;
      final effectiveDob =
          state.dateOfBirth ?? AgeCalculator.dobFromAgeInYears(effectiveAge);

      await _db.insertPatientQueue(
        PatientQueueTableCompanion.insert(
          id: id,
          patientId: drift.Value(assignedPatientId),
          tokenNumber: token,
          patientName: state.patientName.trim(),
          age: effectiveAge,
          dateOfBirth: drift.Value(effectiveDob),
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
        lastGeneratedTokenMessage:
            'Token #$token successfully generated for ${state.patientName.trim()}!',
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
    DateTime? dateOfBirth,
    String? patientId,
    List<String> comorbs = const [],
    PatientVitals vitals = const PatientVitals(),
  }) async {
    final token = await _db.getNextTokenNumberForToday();
    final id = _uuid.v4();
    final entryTime = DateTime.now().subtract(elapsedWait);

    final vitalsJson = vitals.hasAnyVitals ? jsonEncode(vitals.toJson()) : null;
    final comorbsJson = comorbs.isNotEmpty ? jsonEncode(comorbs) : null;
    final effectiveDob = dateOfBirth ?? AgeCalculator.dobFromAgeInYears(age);

    await _db.insertPatientQueue(
      PatientQueueTableCompanion.insert(
        id: id,
        patientId: drift.Value(patientId),
        tokenNumber: token,
        patientName: name,
        age: age,
        dateOfBirth: drift.Value(effectiveDob),
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
    NotifierProvider<ReceptionNotifier, ReceptionFormState>(
      ReceptionNotifier.new,
    );
