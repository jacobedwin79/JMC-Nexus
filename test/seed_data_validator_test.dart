import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:jmc_nexus/core/database/app_database.dart';
import 'package:jmc_nexus/features/encounter/application/safety_engine.dart';
import 'package:jmc_nexus/features/encounter/domain/clinical_models.dart';
import 'package:jmc_nexus/features/reception/application/reception_notifier.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureSeeded();
  });

  tearDown(() async {
    await db.close();
  });

  group('Seed Data Integrity Validator', () {
    test('every protocol drugId exists in the master Drugs formulary', () async {
      final allDrugs = await db.getAllDrugs();
      final drugIdSet = allDrugs.map((d) => d.id).toSet();

      final allDiagnoses = await db.getAllDiagnoses();
      for (final diag in allDiagnoses) {
        final protocol = await db.getProtocolForDiagnosis(diag.id);
        if (protocol == null) continue;

        final items = (jsonDecode(protocol.protocolItemsJson) as List);
        for (final item in items) {
          final drugId = item['drugId'] as String;
          expect(
            drugIdSet.contains(drugId),
            isTrue,
            reason:
                'Protocol for "${diag.name}" references non-existent drugId: "$drugId"',
          );
        }
      }
    });

    test(
      'PUD and DM steroid contraindication matches master formulary Prednisolone',
      () async {
        final allComorbs = await db.getAllComorbidities();
        final pud = allComorbs.firstWhere((c) => c.id == 'comorb_pud');
        final dm = allComorbs.firstWhere((c) => c.id == 'comorb_dm');

        final pudContras = (jsonDecode(pud.contraindicatedDrugClasses) as List)
            .cast<String>();
        final dmContras = (jsonDecode(dm.contraindicatedDrugClasses) as List)
            .cast<String>();

        // Both should contain Systemic Steroids or Corticosteroids
        expect(
          pudContras.any((c) => c.toLowerCase().contains('steroid')),
          isTrue,
          reason: 'PUD must contain Steroid contraindication',
        );
        expect(
          dmContras.any((c) => c.toLowerCase().contains('steroid')),
          isTrue,
          reason: 'DM must contain Steroid contraindication',
        );

        // Verify that Prednisolone (Systemic Steroids) triggers safety alert for PUD
        const prednisolone = PrescriptionItemModel(
          drugId: 'drug_prednisolone_20',
          genericName: 'Prednisolone',
          brandName: 'Tab. Wysolone 20mg',
          drugClass: 'Systemic Steroids',
          dose: '20 mg',
          route: 'PO',
          frequency: 'OD',
          duration: '5 days',
          instructions: 'After breakfast',
        );

        final comorbModels = allComorbs
            .map(
              (c) => ComorbidityModel(
                id: c.id,
                name: c.name,
                contraindicatedDrugClasses:
                    (jsonDecode(c.contraindicatedDrugClasses) as List)
                        .cast<String>(),
              ),
            )
            .toList();

        final pudAlerts = SafetyEngine.evaluate(
          selectedComorbidityIds: ['comorb_pud'],
          activePrescription: [prednisolone],
          comorbiditiesCatalog: comorbModels,
        );

        expect(
          pudAlerts,
          isNotEmpty,
          reason: 'Prednisolone must trigger contraindication alert for PUD',
        );
      },
    );

    test(
      'every diagnosis linked complaint exists in PresentingComplaints table',
      () async {
        final allComplaints = await db.getAllComplaints();
        final complaintIdSet = allComplaints.map((c) => c.id).toSet();

        final allDiagnoses = await db.getAllDiagnoses();
        for (final diag in allDiagnoses) {
          final linked = (jsonDecode(diag.linkedComplaintIds) as List)
              .cast<String>();
          for (final cid in linked) {
            expect(
              complaintIdSet.contains(cid),
              isTrue,
              reason:
                  'Diagnosis "${diag.name}" links to non-existent complaint: "$cid"',
            );
          }
        }
      },
    );
  });

  group('Allergy Detection Engine', () {
    const amoxicillin = PrescriptionItemModel(
      drugId: 'drug_amox',
      genericName: 'Amoxicillin + Clavulanate',
      brandName: 'Tab. Augmentin 625',
      drugClass: 'Antibiotic / Penicillin',
      dose: '625 mg',
      route: 'PO',
      frequency: 'BD',
      duration: '5 days',
      instructions: 'After meals',
    );

    const dolo = PrescriptionItemModel(
      drugId: 'drug_pcm_650',
      genericName: 'Paracetamol',
      brandName: 'Tab. Dolo 650',
      drugClass: 'Analgesic',
      dose: '650 mg',
      route: 'PO',
      frequency: 'SOS',
      duration: '3 days',
      instructions: 'After food',
    );

    test('Penicillin allergy blocks Augmentin / Amoxicillin', () {
      final alerts = SafetyEngine.evaluate(
        selectedComorbidityIds: const [],
        activePrescription: [amoxicillin],
        comorbiditiesCatalog: const [],
        allergies: ['Penicillin'],
      );

      expect(alerts.length, equals(1));
      expect(alerts.first.severity, equals(AlertSeverity.critical));
      expect(alerts.first.message, contains('CRITICAL ALLERGY CONFLICT'));
      expect(alerts.first.message, contains('Penicillin'));
    });

    test('Paracetamol allergy blocks Dolo 650', () {
      final alerts = SafetyEngine.evaluate(
        selectedComorbidityIds: const [],
        activePrescription: [dolo],
        comorbiditiesCatalog: const [],
        allergies: ['Paracetamol'],
      );

      expect(alerts.length, equals(1));
      expect(alerts.first.severity, equals(AlertSeverity.critical));
      expect(alerts.first.message, contains('Paracetamol'));
    });
  });

  group('Paediatric & Geriatric Clinical Engine', () {
    const aspirin = PrescriptionItemModel(
      drugId: 'drug_aspirin',
      genericName: 'Aspirin',
      brandName: 'Tab. Ecosprin 75',
      drugClass: 'NSAID / Antiplatelet',
      dose: '75 mg',
      route: 'PO',
      frequency: 'OD',
      duration: '30 days',
      instructions: 'After food',
    );

    test(
      'Aspirin in paediatric patient (<12) triggers Reye\'s syndrome alert',
      () {
        final alerts = SafetyEngine.evaluate(
          selectedComorbidityIds: const [],
          activePrescription: [aspirin],
          comorbiditiesCatalog: const [],
          patientAge: 8,
          patientWeight: 24,
        );

        expect(
          alerts.any((a) => a.message.contains("Reye's Syndrome")),
          isTrue,
          reason: 'Aspirin must be strictly flagged in children',
        );
      },
    );

    test(
      'Child without recorded weight triggers paediatric dosing warning',
      () {
        final alerts = SafetyEngine.evaluate(
          selectedComorbidityIds: const [],
          activePrescription: [aspirin],
          comorbiditiesCatalog: const [],
          patientAge: 5,
          patientWeight: null, // missing weight
        );

        expect(
          alerts.any((a) => a.message.contains('PAEDIATRIC DOSING WARNING')),
          isTrue,
        );
      },
    );
  });

  group('Age-Stratified Vitals Evaluation', () {
    test('Pulse 150 is normal for infant (<1) but tachycardic for adult', () {
      const vitals = PatientVitals(pulse: 150);

      // Infant (<1 year)
      expect(vitals.isTachycardicForAge(0), isFalse);

      // Adult (35 years)
      expect(vitals.isTachycardicForAge(35), isTrue);
    });

    test('BP 70/45 is normal for infant (<1) but hypotensive for adult', () {
      const vitals = PatientVitals(bpSys: 70, bpDia: 45);

      // Infant (<1 year)
      expect(vitals.isHypotensiveForAge(0), isFalse);

      // Adult (40 years)
      expect(vitals.isHypotensiveForAge(40), isTrue);
    });

    test('Fever evaluated correctly in Celsius and Fahrenheit', () {
      // 38.0°C is febrile (>= 37.5°C or >= 99.5°F)
      const febrileCelsius = PatientVitals(temp: 38.0, tempIsCelsius: true);
      expect(febrileCelsius.isFebrile, isTrue);

      // 36.6°C is afebrile
      const afebrileCelsius = PatientVitals(temp: 36.6, tempIsCelsius: true);
      expect(afebrileCelsius.isFebrile, isFalse);

      // 101.2°F is febrile
      const febrileFahr = PatientVitals(temp: 101.2, tempIsCelsius: false);
      expect(febrileFahr.isFebrile, isTrue);
    });
  });

  group('Vitals Clearing Logic', () {
    test(
      'Setting vital to null clears the value rather than persisting old value',
      () {
        // Start with vitals populated
        var state = const ReceptionFormState(
          vitals: PatientVitals(bpSys: 120, bpDia: 80, pulse: 72),
        );
        expect(state.vitals.bpSys, equals(120));

        // Clear bpSys
        state = state.copyWith(vitals: state.vitals.copyWith(bpSys: null));
        expect(state.vitals.bpSys, isNull);
        expect(state.vitals.bpDia, equals(80)); // others preserved
      },
    );
  });
}
