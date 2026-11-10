import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:jmc_nexus/core/database/app_database.dart';
import 'package:jmc_nexus/core/database/database_provider.dart';
import 'package:jmc_nexus/features/encounter/application/encounter_notifier.dart';
import 'package:jmc_nexus/features/encounter/application/safety_engine.dart';
import 'package:jmc_nexus/features/encounter/domain/clinical_models.dart';
import 'package:jmc_nexus/features/encounter/domain/patient_queue_item.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureSeeded();
  });

  tearDown(() async {
    await db.close();
  });

  test('SafetyEngine flags CKD + NSAID as critical contraindication', () {
    const ckd = ComorbidityModel(
      id: 'comorb_ckd',
      name: 'Chronic Kidney Disease (CKD)',
      contraindicatedDrugClasses: ['NSAID', 'Metformin'],
    );

    const nsaid = PrescriptionItemModel(
      drugId: 'drug_dicyclomine_pcm',
      genericName: 'Dicyclomine + Paracetamol',
      brandName: 'Tab. Meftal-Spas',
      drugClass: 'NSAID',
      dose: '1 tab',
      route: 'PO',
      frequency: 'SOS',
      duration: '3 days',
      instructions: 'After meals',
    );

    final alerts = SafetyEngine.evaluate(
      selectedComorbidityIds: ['comorb_ckd'],
      activePrescription: [nsaid],
      comorbiditiesCatalog: [ckd],
    );

    expect(alerts.length, equals(1));
    expect(alerts.first.severity, equals(AlertSeverity.critical));
    expect(alerts.first.drugClass, equals('NSAID'));
    expect(alerts.first.comorbidityName, contains('Chronic Kidney Disease'));
  });

  test('EncounterNotifier workflow: load patient, auto-load protocol Rx, and trigger CKD+NSAID alert', () async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(encounterProvider.notifier);

    // 1. Prepare patient with CKD comorbidity
    final testPatient = PatientQueueItem(
      id: 'patient-ckd-1',
      tokenNumber: 5,
      patientName: 'Ramesh Patel',
      age: 58,
      gender: 'M',
      entryTime: DateTime.now().subtract(const Duration(minutes: 15)),
      initialComorbIds: ['comorb_ckd'],
      vitals: {'bp_sys': 130, 'bp_dia': 85, 'pulse': 78},
    );

    // Insert into DB first
    await db.insertPatientQueue(
      PatientQueueTableCompanion.insert(
        id: testPatient.id,
        tokenNumber: testPatient.tokenNumber,
        patientName: testPatient.patientName,
        age: testPatient.age,
        gender: testPatient.gender,
        status: 'WAITING',
        entryTime: testPatient.entryTime,
      ),
    );

    // Load patient into consultation workspace
    await notifier.loadPatient(testPatient);

    final stateAfterLoad = container.read(encounterProvider);
    expect(stateAfterLoad.hasActivePatient, isTrue);
    expect(stateAfterLoad.activePatient!.patientName, equals('Ramesh Patel'));
    expect(stateAfterLoad.activePatient!.status, equals('IN_CONSULTATION'));
    expect(stateAfterLoad.selectedComorbidityIds, contains('comorb_ckd'));

    // Verify all 4 physical exam systems loaded with default normal
    expect(stateAfterLoad.examStates.length, equals(4));
    expect(stateAfterLoad.examStates['sys_cvs']!.isNormal, isTrue);
    expect(stateAfterLoad.examStates['sys_rs']!.isNormal, isTrue);

    // Verify DB was updated to IN_CONSULTATION
    final dbEntry = await db.getPatientQueueById('patient-ckd-1');
    expect(dbEntry!.status, equals('IN_CONSULTATION'));
    expect(dbEntry.consultationStartTime, isNotNull);

    // 2. Select Acute Gastroenteritis diagnosis (diag_age)
    await notifier.selectDiagnosis('diag_age');

    final stateAfterDiag = container.read(encounterProvider);
    expect(stateAfterDiag.selectedDiagnosisIds, contains('diag_age'));

    // Verify protocol pre-populated medications
    expect(stateAfterDiag.activePrescription.length, greaterThanOrEqualTo(4));
    expect(stateAfterDiag.generalAdvice, contains('Hydrate well with ORS'));

    // 3. Verify that because patient has CKD and AGE protocol contains Meftal-Spas (NSAID),
    // a critical safety alert is automatically active!
    expect(stateAfterDiag.safetyAlerts.isNotEmpty, isTrue);
    expect(stateAfterDiag.hasCriticalSafetyAlert, isTrue);

    final nsaidAlert = stateAfterDiag.safetyAlerts.firstWhere(
      (a) => a.drugClass == 'NSAID',
    );
    expect(nsaidAlert.severity, equals(AlertSeverity.critical));

    // 4. Doctor overrides physical exam: RS wheeze
    notifier.toggleExamAbnormalFinding('sys_rs', 'Bilateral diffuse polyphonic wheeze');
    final stateAfterExam = container.read(encounterProvider);
    expect(stateAfterExam.examStates['sys_rs']!.isNormal, isFalse);
    expect(stateAfterExam.examStates['sys_rs']!.selectedAbnormals, contains('Bilateral diffuse polyphonic wheeze'));

    // 5. Complete encounter
    await notifier.completeEncounter();

    // Verify workspace cleared
    expect(container.read(encounterProvider).hasActivePatient, isFalse);

    // Verify DB marked patient as COMPLETED
    final completedEntry = await db.getPatientQueueById('patient-ckd-1');
    expect(completedEntry!.status, equals('COMPLETED'));
    expect(completedEntry.completionTime, isNotNull);
    expect(completedEntry.compiledPrescriptionJson, isNotNull);
    expect(completedEntry.compiledPrescriptionJson, contains('diag_age'));
  });
}

