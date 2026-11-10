import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:jmc_nexus/core/database/app_database.dart';
import 'package:jmc_nexus/core/database/database_provider.dart';
import 'package:jmc_nexus/core/theme/app_theme.dart';
import 'package:jmc_nexus/features/encounter/application/queue_monitor_notifier.dart';
import 'package:jmc_nexus/features/encounter/domain/clinical_models.dart';
import 'package:jmc_nexus/features/reception/application/reception_notifier.dart';
import 'package:jmc_nexus/features/reception/presentation/reception_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.ensureSeeded();
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'ReceptionNotifier registers patient and auto-increments token',
    () async {
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      try {
        final reception = container.read(receptionProvider.notifier);
        await reception.refreshNextToken();
        expect(container.read(receptionProvider).nextTokenNumber, equals(1));

        // Register patient 1
        reception.setPatientName('Aarav Sharma');
        reception.setAge(28);
        reception.setGender('M');
        reception.updateVitals(bpSys: 120, bpDia: 80, pulse: 76);
        reception.toggleComorbidity('comorb_htn');

        final token1 = await reception.registerAndGenerateToken();
        expect(token1, equals(1));
        expect(container.read(receptionProvider).nextTokenNumber, equals(2));

        // Register patient 2
        reception.setPatientName('Sunita Patel');
        reception.setAge(52);
        reception.setGender('F');

        final token2 = await reception.registerAndGenerateToken();
        expect(token2, equals(2));
        expect(container.read(receptionProvider).nextTokenNumber, equals(3));
      } finally {
        container.dispose();
      }
    },
  );

  test(
    'QueueMonitorNotifier evaluates 3 mock patients and triggers >45m overdue SLA alert',
    () async {
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );

      try {
        // Keep queue monitor active
        container.listen(queueMonitorProvider, (_, __) {});

        final reception = container.read(receptionProvider.notifier);

        // Patient 1: Checked in 10 minutes ago (Normal <30m)
        await reception.registerMockPatientWithElapsedWait(
          name: 'Patient 1 (Recent)',
          age: 25,
          gender: 'M',
          elapsedWait: const Duration(minutes: 10),
        );

        // Patient 2: Checked in 35 minutes ago (Warning 30-44m)
        await reception.registerMockPatientWithElapsedWait(
          name: 'Patient 2 (Warning)',
          age: 45,
          gender: 'F',
          elapsedWait: const Duration(minutes: 35),
        );

        // Patient 3: Checked in 50 minutes ago (Critical SLA Breach >45m)
        await reception.registerMockPatientWithElapsedWait(
          name: 'Patient 3 (Overdue)',
          age: 70,
          gender: 'M',
          elapsedWait: const Duration(minutes: 50),
          vitals: const PatientVitals(bpSys: 150, bpDia: 95, pulse: 92),
        );

        // Allow stream to emit
        await Future.delayed(const Duration(milliseconds: 150));

        final queueState = container.read(queueMonitorProvider);

        expect(queueState.allPatients.length, equals(3));
        expect(queueState.waitingPatients.length, equals(3));
        expect(queueState.warningPatients.length, equals(1));
        expect(queueState.overduePatients.length, equals(1));
        expect(queueState.hasOverdue, isTrue);
        expect(queueState.overdueCount, equals(1));
        expect(queueState.overdueBannerText, contains('#3'));
      } finally {
        container.read(queueMonitorProvider.notifier).cancelTimers();
        container.dispose();
      }
    },
  );

  testWidgets(
    'ReceptionScreen renders split view and displays overdue SLA banner',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );

      try {
        // Keep queue active
        container.listen(queueMonitorProvider, (_, __) {});

        // Seed one overdue patient
        await container
            .read(receptionProvider.notifier)
            .registerMockPatientWithElapsedWait(
              name: 'Overdue Patient',
              age: 60,
              gender: 'F',
              elapsedWait: const Duration(minutes: 50),
            );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: ReceptionScreen(onSwitchToDoctor: () {}),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Verify UI components
        expect(find.text('JMC Nexus • Reception Terminal'), findsOneWidget);
        expect(find.text('Patient Full Name *'), findsOneWidget);
        expect(find.text('Doctor Terminal'), findsOneWidget);

        // Verify Overdue SLA banner presence
        expect(find.textContaining('waiting > 45 mins'), findsWidgets);
        expect(find.text('Overdue Patient'), findsOneWidget);

        // Unmount widget tree before disposing
        await tester.pumpWidget(const SizedBox.shrink());
        container.read(queueMonitorProvider.notifier).cancelTimers();
        container.dispose();
        await tester.pump(const Duration(milliseconds: 50));
      } finally {
        // Cleaned up above
      }
    },
  );
}
