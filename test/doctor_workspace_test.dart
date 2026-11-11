import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:jmc_nexus/core/database/app_database.dart';
import 'package:jmc_nexus/core/database/database_provider.dart';
import 'package:jmc_nexus/core/theme/app_theme.dart';
import 'package:jmc_nexus/features/encounter/application/encounter_notifier.dart';
import 'package:jmc_nexus/features/encounter/application/queue_monitor_notifier.dart';
import 'package:jmc_nexus/features/encounter/domain/clinical_models.dart';
import 'package:jmc_nexus/features/encounter/presentation/doctor_workspace_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureSeeded();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets(
    'DoctorWorkspace clinical flow: select patient, tap diagnosis, auto-load protocol, and complete encounter',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );

      try {
        // Seed a waiting patient in SQLite
        final now = DateTime.now();
        await db.insertPatientQueue(
          PatientQueueTableCompanion.insert(
            id: 'test-patient-1',
            tokenNumber: 1,
            patientName: 'Dev Sharma',
            age: 42,
            gender: 'M',
            status: 'WAITING',
            entryTime: now.subtract(const Duration(minutes: 20)),
            vitalsJson: Value(
              jsonEncode(
                const PatientVitals(
                  bpSys: 130,
                  bpDia: 85,
                  pulse: 76,
                  spo2: 98,
                  temp: 98.6,
                ).toJson(),
              ),
            ),
          ),
        );

        // Keep monitor active
        container.listen(queueMonitorProvider, (_, __) {});

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: DoctorWorkspaceScreen(onSwitchToReception: () {}),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // 1. Verify Waiting Queue displays the patient in the left rail
        expect(find.text('#1'), findsWidgets);
        expect(find.text('Dev Sharma'), findsOneWidget);

        // 2. Tap on patient to load into consultation workspace
        await tester.tap(find.text('Dev Sharma'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify active patient is loaded
        final encounterState = container.read(encounterProvider);
        expect(encounterState.hasActivePatient, isTrue);
        expect(encounterState.activePatient!.patientName, equals('Dev Sharma'));
        expect(find.text('130/85 mmHg'), findsOneWidget);

        // 3. Tap on Presenting Complaint: "Loose Stools / Diarrhea"
        final complaintFinder = find.text('Loose Stools / Diarrhea');
        expect(complaintFinder, findsOneWidget);
        await tester.tap(complaintFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Verify subquestions appeared and tap option "Watery"
        final wateryOption = find.text('Watery');
        expect(wateryOption, findsOneWidget);
        await tester.ensureVisible(wateryOption);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.tap(wateryOption);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // 4. Tap on suggested Diagnosis: "Acute Gastroenteritis (A09)"
        final diagFinder = find.text('Acute Gastroenteritis (A09)');
        expect(diagFinder, findsOneWidget);
        await tester.ensureVisible(diagFinder);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.tap(diagFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Scroll to view the populated prescription section
        final drugFinder = find.text('ONDAR-MD Tab. [DPCO]').last;
        await tester.ensureVisible(drugFinder);
        await tester.pump();

        // Verify prescription section populated with medications from Supabase Master Formulary
        expect(find.text('ONDAR-MD Tab. [DPCO]'), findsWidgets);
        expect(find.text('ROMBIFLOX-200 Tab.'), findsWidgets);
        expect(find.text('ACHO Tab.'), findsWidgets);
        expect(find.text('ANTICA Tab.'), findsWidgets);

        // 5. Test Safety Engine: Scroll to "CKD" comorbidity chip in PatientHeaderBar
        final ckdChip = find.text('CKD');
        expect(ckdChip, findsOneWidget);
        await tester.ensureVisible(ckdChip);
        await tester.pump();
        await tester.tap(ckdChip);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Verify red safety alert appeared
        expect(
          find.textContaining(
            'CRITICAL CONTRAINDICATION: NSAID is strictly contraindicated',
          ),
          findsOneWidget,
        );

        // Select mandatory follow-up
        final followUpBtn = find.text('3 Days');
        await tester.ensureVisible(followUpBtn);
        await tester.pump();
        await tester.tap(followUpBtn);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // 6. Complete consultation: Tap "Print A4 & Mark Seen"
        final printBtn = find.textContaining('Print A4 & Mark Seen');
        expect(printBtn, findsOneWidget);
        await tester.tap(printBtn);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify Critical Safety Alert Override dialog appears due to hard-block
        expect(find.text('Critical Safety Alert Override'), findsOneWidget);

        // Enter clinical override justification
        final reasonField = find.byType(TextField).last;
        await tester.enterText(
          reasonField,
          'Severe acute spasm, single dose administered with hydration',
        );
        await tester.pump();

        // Tap Confirm Override & Complete
        final confirmBtn = find.text('Confirm Override & Complete');
        expect(confirmBtn, findsOneWidget);
        await tester.tap(confirmBtn);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify patient was marked COMPLETED in database
        final completed = await db.getPatientQueueById('test-patient-1');
        expect(completed!.status, equals('COMPLETED'));
        expect(completed.completionTime, isNotNull);
        expect(completed.overrideReason, contains('Severe acute spasm'));

        // Unmount before disposing
        await tester.pumpWidget(const SizedBox.shrink());
        container.read(queueMonitorProvider.notifier).cancelTimers();
        container.dispose();
        await tester.pump(const Duration(milliseconds: 50));
      } finally {
        // Cleanup done
      }
    },
  );
}
