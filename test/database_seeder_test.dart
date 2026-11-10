import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:jmc_nexus/core/database/app_database.dart';
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

  test('Database seeds all clinical tables on initialization', () async {
    final comorbs = await db.getAllComorbidities();
    expect(comorbs.length, greaterThanOrEqualTo(8));

    final complaints = await db.getAllComplaints();
    expect(complaints.length, greaterThanOrEqualTo(10));

    final examSystems = await db.getAllExaminationSystems();
    expect(examSystems.length, equals(4));

    final diagnoses = await db.getAllDiagnoses();
    expect(diagnoses.length, equals(5));

    final drugs = await db.getAllDrugs();
    expect(drugs.length, greaterThanOrEqualTo(15));

    final ageProtocol = await db.getProtocolForDiagnosis('diag_age');
    expect(ageProtocol, isNotNull);
    expect(ageProtocol!.generalAdvice, contains('Hydrate well with ORS'));
  });

  test('PatientQueue token generation auto-increments daily', () async {
    final now = DateTime.now();
    final firstToken = await db.getNextTokenNumberForToday(now);
    expect(firstToken, equals(1));

    await db.insertPatientQueue(
      PatientQueueTableCompanion.insert(
        id: 'patient-1',
        tokenNumber: firstToken,
        patientName: 'Rajesh Kumar',
        age: 45,
        gender: 'M',
        status: 'WAITING',
        entryTime: now,
      ),
    );

    final secondToken = await db.getNextTokenNumberForToday(now);
    expect(secondToken, equals(2));
  });

  test('PatientQueueItem SLA duration evaluations', () {
    final now = DateTime.now();

    final normalItem = PatientQueueItem(
      id: 'p-1',
      tokenNumber: 1,
      patientName: 'Test Normal',
      age: 30,
      gender: 'M',
      entryTime: now.subtract(const Duration(minutes: 15)),
    );
    expect(normalItem.isNormal(now), isTrue);
    expect(normalItem.isWarning(now), isFalse);
    expect(normalItem.isOverdue(now), isFalse);

    final warningItem = PatientQueueItem(
      id: 'p-2',
      tokenNumber: 2,
      patientName: 'Test Warning',
      age: 40,
      gender: 'F',
      entryTime: now.subtract(const Duration(minutes: 35)),
    );
    expect(warningItem.isNormal(now), isFalse);
    expect(warningItem.isWarning(now), isTrue);
    expect(warningItem.isOverdue(now), isFalse);

    final overdueItem = PatientQueueItem(
      id: 'p-3',
      tokenNumber: 3,
      patientName: 'Test Overdue',
      age: 65,
      gender: 'M',
      entryTime: now.subtract(const Duration(minutes: 50)),
    );
    expect(overdueItem.isNormal(now), isFalse);
    expect(overdueItem.isWarning(now), isFalse);
    expect(overdueItem.isOverdue(now), isTrue);
    expect(overdueItem.waitMinutes(now), equals(50));
  });
}

