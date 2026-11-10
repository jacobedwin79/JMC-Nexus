import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:jmc_nexus/core/config/clinic_settings.dart';
import 'package:jmc_nexus/core/database/app_database.dart';
import 'package:jmc_nexus/core/database/database_provider.dart';
import 'package:jmc_nexus/core/printing/a4_laser_print_service.dart';
import 'package:jmc_nexus/features/admin/application/admin_notifier.dart';
import 'package:jmc_nexus/features/admin/presentation/admin_panel_screen.dart';
import 'package:jmc_nexus/features/encounter/domain/encounter_state.dart';
import 'package:jmc_nexus/features/encounter/domain/patient_queue_item.dart';
import 'package:jmc_nexus/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Clinic Settings Persistence & Integration', () {
    test('ClinicSettingsNotifier updates and retains all custom properties', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      const customSettings = ClinicSettings(
        clinicName: 'Metro Community Health Clinic',
        clinicSubtitle: 'Primary Care & Family Medicine',
        clinicContact: 'Phone: +91 99887 76655 | care@metroclinic.in',
        doctorName: 'Dr. Sarah Mathews, MD',
        doctorQualifications: 'MBBS, MD (Internal Medicine)',
        registrationNumber: 'Reg. No: MMC-89211',
        letterheadTopMarginMm: 50.0,
        consultationFee: 350.0,
        revisitFee: 200.0,
      );

      await container
          .read(clinicSettingsProvider.notifier)
          .updateSettings(customSettings);

      final state = container.read(clinicSettingsProvider);
      expect(state.clinicName, 'Metro Community Health Clinic');
      expect(state.clinicSubtitle, 'Primary Care & Family Medicine');
      expect(state.clinicContact, 'Phone: +91 99887 76655 | care@metroclinic.in');
      expect(state.doctorName, 'Dr. Sarah Mathews, MD');
      expect(state.doctorQualifications, 'MBBS, MD (Internal Medicine)');
      expect(state.registrationNumber, 'Reg. No: MMC-89211');
      expect(state.letterheadTopMarginMm, 50.0);
      expect(state.consultationFee, 350.0);
      expect(state.revisitFee, 200.0);
    });

    test('A4LaserPrintService uses custom clinic settings', () async {
      const customSettings = ClinicSettings(
        clinicName: 'Apex Heart & Medical Center',
        clinicSubtitle: 'Cardiology & Internal Medicine',
        doctorName: 'Dr. Anand Kumar',
      );

      final patient = PatientQueueItem(
        id: 'p-1',
        tokenNumber: 5,
        patientName: 'John Doe',
        age: 38,
        gender: 'M',
        entryTime: DateTime.now(),
      );

      final encounter = EncounterState(activePatient: patient);
      final pdfBytes = await A4LaserPrintService.buildA4Prescription(
        encounter,
        customSettings,
      );

      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(1000));
    });
  });

  group('Admin Metrics & Income Analytics', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('AdminNotifier accurately calculates total patients, revisits, and daily income', () async {
      final now = DateTime.now();

      // Seed 1 New Patient today with fee 250
      await db.insertPatientQueue(
        PatientQueueTableCompanion.insert(
          id: 'patient-today-1',
          patientId: const drift.Value('PID-001'),
          tokenNumber: 1,
          patientName: 'Ramesh Nair',
          age: 45,
          gender: 'M',
          status: 'COMPLETED',
          entryTime: now,
          consultationFee: const drift.Value(250.0),
          isRevisit: const drift.Value(false),
        ),
      );

      // Seed 1 Revisit Patient today with fee 150
      await db.insertPatientQueue(
        PatientQueueTableCompanion.insert(
          id: 'patient-today-2',
          patientId: const drift.Value('PID-001'), // same patient returning
          tokenNumber: 2,
          patientName: 'Ramesh Nair',
          age: 45,
          gender: 'M',
          status: 'COMPLETED',
          entryTime: now.subtract(const Duration(minutes: 20)),
          consultationFee: const drift.Value(150.0),
          isRevisit: const drift.Value(true),
        ),
      );

      // Seed 1 Waiting Patient today with fee 250
      await db.insertPatientQueue(
        PatientQueueTableCompanion.insert(
          id: 'patient-today-3',
          patientId: const drift.Value('PID-002'),
          tokenNumber: 3,
          patientName: 'Ananya Pillai',
          age: 8, // Paediatric
          gender: 'F',
          status: 'WAITING',
          entryTime: now.subtract(const Duration(minutes: 10)),
          consultationFee: const drift.Value(250.0),
          isRevisit: const drift.Value(false),
        ),
      );

      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
      );
      addTearDown(container.dispose);

      // Refresh to load seeded records
      await container.read(adminPanelProvider.notifier).refresh();

      final adminState = container.read(adminPanelProvider);

      expect(adminState.summary.totalPatients, 3);
      expect(adminState.summary.newPatients, 2);
      expect(adminState.summary.revisitPatients, 1);
      expect(adminState.summary.revisitPercentage, closeTo(33.33, 0.5));
      expect(adminState.summary.completedConsultations, 2);
      expect(adminState.summary.waitingPatients, 1);

      // Total income = 250 + 150 + 250 = 650.0
      expect(adminState.summary.totalIncome, 650.0);
      expect(adminState.summary.newPatientIncome, 500.0);
      expect(adminState.summary.revisitPatientIncome, 150.0);

      // Daily Income breakdown
      expect(adminState.dailyIncomeList, isNotEmpty);
      final todayIncomeMetric = adminState.dailyIncomeList.first;
      expect(todayIncomeMetric.totalPatients, 3);
      expect(todayIncomeMetric.newPatients, 2);
      expect(todayIncomeMetric.revisitPatients, 1);
      expect(todayIncomeMetric.totalIncome, 650.0);

      // Demographics
      expect(adminState.demographics.pediatric, 1);
      expect(adminState.demographics.adult, 2);
    });

    testWidgets('AdminPanelScreen renders correctly with KPI cards and patient ledger', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();
      await db.insertPatientQueue(
        PatientQueueTableCompanion.insert(
          id: 'admin-test-1',
          patientId: const drift.Value('PID-100'),
          tokenNumber: 1,
          patientName: 'Devika Menon',
          age: 32,
          gender: 'F',
          status: 'COMPLETED',
          entryTime: now,
          consultationFee: const drift.Value(200.0),
          isRevisit: const drift.Value(false),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: AdminPanelScreen(
              onSwitchToReception: () {},
              onSwitchToDoctor: () {},
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Header checks
      expect(find.text('ADMIN PANEL'), findsOneWidget);
      expect(find.text('Reception Desk'), findsOneWidget);
      expect(find.text('Doctor Terminal'), findsOneWidget);
      expect(find.text('Clinic Settings & Rates'), findsOneWidget);

      // KPI Cards
      expect(find.text('TOTAL PATIENTS'), findsOneWidget);
      expect(find.text('PATIENT REVISITS'), findsOneWidget);
      expect(find.text('TOTAL REVENUE'), findsOneWidget);
      expect(find.text('EFFICIENCY & WAIT TIME'), findsOneWidget);

      // Daily Income Table
      expect(
        find.text('Daily Income & Patient Volume Breakdown'),
        findsOneWidget,
      );

      // Patient ledger
      expect(find.text('Patient Visit Ledger & Audit Log'), findsOneWidget);
      expect(find.text('Devika Menon'), findsOneWidget);
      expect(find.text('NEW PATIENT'), findsOneWidget);
      expect(find.text('COMPLETED'), findsOneWidget);
    });
  });

  testWidgets('AppRole switcher switches between Reception, Doctor, and Admin', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const JmcNexusApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Initially Reception
    expect(find.text('JMC Nexus • Reception Terminal'), findsOneWidget);
    expect(find.text('Admin Panel'), findsOneWidget);

    // Tap Admin Panel button in Reception screen
    await tester.tap(find.text('Admin Panel'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Now in Admin Panel
    expect(find.text('ADMIN PANEL'), findsOneWidget);
    expect(find.text('TOTAL PATIENTS'), findsOneWidget);

    // Tap Doctor Terminal from Admin Panel
    await tester.tap(find.text('Doctor Terminal'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Now in Doctor Terminal
    expect(find.text('Zero-Keyboard Clinical Decision Canvas'), findsOneWidget);
  });
}
