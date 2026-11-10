import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:jmc_nexus/core/database/app_database.dart';
import 'package:jmc_nexus/core/database/database_provider.dart';
import 'package:jmc_nexus/main.dart';

void main() {
  testWidgets('JMC Nexus App smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final testDb = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(testDb),
        ],
        child: const JmcNexusApp(),
      ),
    );

    // Initial loading frame
    expect(find.byType(JmcNexusApp), findsOneWidget);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Reception Terminal loaded
    expect(find.text('JMC Nexus • Reception Terminal'), findsOneWidget);

    await testDb.close();
  });
}
