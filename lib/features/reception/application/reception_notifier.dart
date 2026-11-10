import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../encounter/domain/clinical_models.dart';

class ReceptionFormState {
  final int nextTokenNumber;
  final String patientName;
  final int? age;
  final String gender;
  final String? phone;
  final PatientVitals vitals;
  final List<String> selectedComorbIds;
  final bool isSubmitting;
  final String? errorMessage;
  final String? lastGeneratedTokenMessage;

  const ReceptionFormState({
    this.nextTokenNumber = 1,
    this.patientName = '',
    this.age,
    this.gender = 'M',
    this.phone,
    this.vitals = const PatientVitals(),
    this.selectedComorbIds = const [],
    this.isSubmitting = false,
    this.errorMessage,
    this.lastGeneratedTokenMessage,
  });

  bool get isValid => patientName.trim().isNotEmpty && age != null && age! > 0;

  ReceptionFormState copyWith({
    int? nextTokenNumber,
    String? patientName,
    int? age,
    String? gender,
    String? phone,
    PatientVitals? vitals,
    List<String>? selectedComorbIds,
    bool? isSubmitting,
    String? errorMessage,
    String? lastGeneratedTokenMessage,
    bool clearError = false,
    bool clearLastGenerated = false,
  }) {
    return ReceptionFormState(
      nextTokenNumber: nextTokenNumber ?? this.nextTokenNumber,
      patientName: patientName ?? this.patientName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      vitals: vitals ?? this.vitals,
      selectedComorbIds: selectedComorbIds ?? this.selectedComorbIds,
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

  void setAge(int? age) {
    state = state.copyWith(age: age, clearError: true);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setPhone(String? phone) {
    state = state.copyWith(phone: phone);
  }

  void updateVitals({
    int? bpSys,
    int? bpDia,
    int? pulse,
    int? spo2,
    double? temp,
    double? weight,
  }) {
    final current = state.vitals;
    state = state.copyWith(
      vitals: current.copyWith(
        bpSys: bpSys ?? current.bpSys,
        bpDia: bpDia ?? current.bpDia,
        pulse: pulse ?? current.pulse,
        spo2: spo2 ?? current.spo2,
        temp: temp ?? current.temp,
        weight: weight ?? current.weight,
      ),
    );
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

      await _db.insertPatientQueue(
        PatientQueueTableCompanion.insert(
          id: id,
          tokenNumber: token,
          patientName: state.patientName.trim(),
          age: state.age!,
          gender: state.gender,
          phone: drift.Value(state.phone?.trim()),
          vitalsJson: drift.Value(vitalsJson),
          initialComorbIds: drift.Value(comorbsJson),
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
