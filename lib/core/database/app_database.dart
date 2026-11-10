import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'seed_data.dart';

part 'app_database.g.dart';

// --- TABLE DEFINITIONS ---

@DataClassName('PatientQueueEntry')
class PatientQueueTable extends Table {
  TextColumn get id => text()();
  /// Persistent patient identifier (UHID / MRN) reused across visits.
  TextColumn get patientId => text().nullable()();
  IntColumn get tokenNumber => integer()();
  TextColumn get patientName => text()();
  IntColumn get age => integer()();
  TextColumn get gender => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get vitalsJson => text().nullable()();
  TextColumn get initialComorbIds => text().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get entryTime => dateTime()();
  DateTimeColumn get consultationStartTime => dateTime().nullable()();
  DateTimeColumn get completionTime => dateTime().nullable()();
  TextColumn get compiledPrescriptionJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ComorbidityEntry')
class ComorbiditiesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get contraindicatedDrugClasses => text()(); // JSON Array

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PresentingComplaintEntry')
class PresentingComplaintsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ComplaintSubQuestionEntry')
class ComplaintSubQuestionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get complaintId => text().references(PresentingComplaintsTable, #id)();
  TextColumn get questionLabel => text()();
  TextColumn get optionsJson => text()(); // JSON Array
  TextColumn get sentenceTemplate => text().withDefault(const Constant(''))();
  BoolColumn get isMultiSelect => boolean().withDefault(const Constant(false))();
  IntColumn get sequenceOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExaminationSystemEntry')
class ExaminationSystemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get systemName => text()();
  TextColumn get defaultNormalText => text()();
  TextColumn get abnormalFindingsJson => text()(); // JSON Array

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DiagnosisEntry')
class DiagnosesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icd10Code => text().nullable()();
  TextColumn get linkedComplaintIds => text()(); // JSON Array

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DrugEntry')
class DrugsTable extends Table {
  TextColumn get id => text()();
  TextColumn get genericName => text()();
  TextColumn get brandName => text()();
  TextColumn get drugClass => text()();
  TextColumn get defaultDose => text()();
  TextColumn get defaultRoute => text()();
  TextColumn get defaultFrequency => text()();
  TextColumn get defaultDuration => text()();
  TextColumn get defaultInstructions => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PrescriptionProtocolEntry')
class PrescriptionProtocolsTable extends Table {
  TextColumn get id => text()();
  TextColumn get diagnosisId => text().references(DiagnosesTable, #id)();
  TextColumn get protocolItemsJson => text()(); // JSON Array
  TextColumn get generalAdvice => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  PatientQueueTable,
  ComorbiditiesTable,
  PresentingComplaintsTable,
  ComplaintSubQuestionsTable,
  ExaminationSystemsTable,
  DiagnosesTable,
  DrugsTable,
  PrescriptionProtocolsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(
          executor ??
              driftDatabase(
                name: 'jmc_nexus',
                web: DriftWebOptions(
                  sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                  driftWorker: Uri.parse('drift_worker.js'),
                ),
              ),
        );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await DatabaseSeeder.seedAll(this);
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(patientQueueTable, patientQueueTable.patientId);
          }
        },
      );

  // --- QUEUE QUERIES ---

  Future<int> getNextTokenNumberForToday([DateTime? now]) async {
    final reference = now ?? DateTime.now();
    final startOfDay = DateTime(reference.year, reference.month, reference.day, 0, 0, 0);
    final endOfDay = DateTime(reference.year, reference.month, reference.day, 23, 59, 59);

    final query = selectOnly(patientQueueTable)
      ..addColumns([patientQueueTable.tokenNumber.max()])
      ..where(patientQueueTable.entryTime.isBiggerOrEqualValue(startOfDay) &
          patientQueueTable.entryTime.isSmallerOrEqualValue(endOfDay));

    final row = await query.getSingle();
    final maxToken = row.read(patientQueueTable.tokenNumber.max());
    return (maxToken ?? 0) + 1;
  }

  Stream<List<PatientQueueEntry>> watchWaitingQueue() {
    return (select(patientQueueTable)
          ..where((t) => t.status.equals('WAITING'))
          ..orderBy([(t) => OrderingTerm(expression: t.tokenNumber, mode: OrderingMode.asc)]))
        .watch();
  }

  Stream<List<PatientQueueEntry>> watchAllQueueForToday([DateTime? now]) {
    final reference = now ?? DateTime.now();
    final startOfDay = DateTime(reference.year, reference.month, reference.day, 0, 0, 0);
    final endOfDay = DateTime(reference.year, reference.month, reference.day, 23, 59, 59);

    return (select(patientQueueTable)
          ..where((t) =>
              t.entryTime.isBiggerOrEqualValue(startOfDay) &
              t.entryTime.isSmallerOrEqualValue(endOfDay))
          ..orderBy([(t) => OrderingTerm(expression: t.tokenNumber, mode: OrderingMode.asc)]))
        .watch();
  }

  Future<int> insertPatientQueue(PatientQueueTableCompanion entry) {
    return into(patientQueueTable).insert(entry);
  }

  Future<bool> updatePatientQueueStatus({
    required String id,
    required String status,
    DateTime? consultationStartTime,
    DateTime? completionTime,
    String? compiledPrescriptionJson,
  }) async {
    final companion = PatientQueueTableCompanion(
      status: Value(status),
      consultationStartTime: consultationStartTime != null
          ? Value(consultationStartTime)
          : const Value.absent(),
      completionTime:
          completionTime != null ? Value(completionTime) : const Value.absent(),
      compiledPrescriptionJson: compiledPrescriptionJson != null
          ? Value(compiledPrescriptionJson)
          : const Value.absent(),
    );
    final updated = await (update(patientQueueTable)..where((t) => t.id.equals(id)))
        .write(companion);
    return updated > 0;
  }

  Future<PatientQueueEntry?> getPatientQueueById(String id) {
    return (select(patientQueueTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // --- CATALOG QUERIES ---

  Future<List<ComorbidityEntry>> getAllComorbidities() {
    return (select(comorbiditiesTable)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  Future<List<PresentingComplaintEntry>> getAllComplaints() {
    return (select(presentingComplaintsTable)
          ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
        .get();
  }

  Future<List<ComplaintSubQuestionEntry>> getSubQuestionsForComplaint(String complaintId) {
    return (select(complaintSubQuestionsTable)
          ..where((t) => t.complaintId.equals(complaintId))
          ..orderBy([(t) => OrderingTerm.asc(t.sequenceOrder)]))
        .get();
  }

  Future<List<ExaminationSystemEntry>> getAllExaminationSystems() {
    return select(examinationSystemsTable).get();
  }

  Future<List<DiagnosisEntry>> getAllDiagnoses() {
    return (select(diagnosesTable)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  Future<List<DrugEntry>> getAllDrugs() {
    return (select(drugsTable)..orderBy([(t) => OrderingTerm.asc(t.brandName)])).get();
  }

  Future<PrescriptionProtocolEntry?> getProtocolForDiagnosis(String diagnosisId) {
    return (select(prescriptionProtocolsTable)
          ..where((t) => t.diagnosisId.equals(diagnosisId)))
        .getSingleOrNull();
  }

  Future<void> ensureSeeded() async {
    final count = await (selectOnly(diagnosesTable)..addColumns([diagnosesTable.id.count()]))
        .getSingle();
    final total = count.read(diagnosesTable.id.count()) ?? 0;
    if (total == 0) {
      await DatabaseSeeder.seedAll(this);
    }
  }
}
