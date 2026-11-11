import 'dart:convert';
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
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  TextColumn get gender => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get vitalsJson => text().nullable()();
  TextColumn get initialComorbIds => text().nullable()();
  TextColumn get allergies =>
      text().nullable()(); // JSON Array e.g. ["Penicillin", "NSAID"]
  TextColumn get lmp => text().nullable()(); // Last Menstrual Period
  BoolColumn get isPregnant => boolean().withDefault(const Constant(false))();
  TextColumn get status => text()();
  DateTimeColumn get entryTime => dateTime()();
  DateTimeColumn get consultationStartTime => dateTime().nullable()();
  DateTimeColumn get completionTime => dateTime().nullable()();
  TextColumn get compiledPrescriptionJson => text().nullable()();
  TextColumn get encounterSnapshotJson => text().nullable()();
  TextColumn get overrideReason => text().nullable()();

  // Financial & Visit Audit
  RealColumn get consultationFee => real().withDefault(const Constant(0.0))();
  BoolColumn get isRevisit => boolean().withDefault(const Constant(false))();

  // Audit & Sync Fields
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ComorbidityEntry')
class ComorbiditiesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get contraindicatedDrugClasses => text()(); // JSON Array

  // Audit & Sync Fields
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PresentingComplaintEntry')
class PresentingComplaintsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();

  // Audit & Sync Fields
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ComplaintSubQuestionEntry')
class ComplaintSubQuestionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get complaintId =>
      text().references(PresentingComplaintsTable, #id)();
  TextColumn get questionLabel => text()();
  TextColumn get optionsJson => text()(); // JSON Array
  TextColumn get sentenceTemplate => text().withDefault(const Constant(''))();
  BoolColumn get isMultiSelect =>
      boolean().withDefault(const Constant(false))();
  IntColumn get sequenceOrder => integer().withDefault(const Constant(0))();

  // Audit & Sync Fields
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExaminationSystemEntry')
class ExaminationSystemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get systemName => text()();
  TextColumn get defaultNormalText => text()();
  TextColumn get abnormalFindingsJson => text()(); // JSON Array

  // Audit & Sync Fields
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DiagnosisEntry')
class DiagnosesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icd10Code => text().nullable()();
  TextColumn get linkedComplaintIds => text()(); // JSON Array

  // Audit & Sync Fields
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

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

  // Audit & Sync Fields
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PrescriptionProtocolEntry')
class PrescriptionProtocolsTable extends Table {
  TextColumn get id => text()();
  TextColumn get diagnosisId => text().references(DiagnosesTable, #id)();
  TextColumn get protocolItemsJson => text()(); // JSON Array
  TextColumn get generalAdvice => text().withDefault(const Constant(''))();

  // Audit & Sync Fields
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tracks unmapped free-text entries for complaints, examination findings, and diagnoses
/// so that the clinical catalog can grow organically based on real usage.
@DataClassName('UnmappedTermEntry')
class UnmappedTermsTable extends Table {
  TextColumn get id => text()();
  TextColumn get category =>
      text()(); // 'complaint', 'examination', 'diagnosis'
  TextColumn get term => text()();
  TextColumn get encounterId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Audit & Sync Fields
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tracks medication usage frequency so the top 20 medications are always one tap away.
@DataClassName('DrugUsageEntry')
class DrugUsageTable extends Table {
  TextColumn get drugId => text()();
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastUsedAt => dateTime().withDefault(currentDateAndTime)();

  // Audit & Sync Fields
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {drugId};
}

@DriftDatabase(
  tables: [
    PatientQueueTable,
    ComorbiditiesTable,
    PresentingComplaintsTable,
    ComplaintSubQuestionsTable,
    ExaminationSystemsTable,
    DiagnosesTable,
    DrugsTable,
    PrescriptionProtocolsTable,
    UnmappedTermsTable,
    DrugUsageTable,
  ],
)
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
  int get schemaVersion => 4;

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
      if (from < 3) {
        await m.addColumn(patientQueueTable, patientQueueTable.dateOfBirth);
        await m.addColumn(
          patientQueueTable,
          patientQueueTable.encounterSnapshotJson,
        );
        await m.addColumn(patientQueueTable, patientQueueTable.overrideReason);
        await m.addColumn(patientQueueTable, patientQueueTable.updatedAt);
        await m.addColumn(patientQueueTable, patientQueueTable.version);
        await m.addColumn(patientQueueTable, patientQueueTable.deletedAt);

        await m.addColumn(comorbiditiesTable, comorbiditiesTable.updatedAt);
        await m.addColumn(comorbiditiesTable, comorbiditiesTable.version);
        await m.addColumn(comorbiditiesTable, comorbiditiesTable.deletedAt);

        await m.addColumn(
          presentingComplaintsTable,
          presentingComplaintsTable.updatedAt,
        );
        await m.addColumn(
          presentingComplaintsTable,
          presentingComplaintsTable.version,
        );
        await m.addColumn(
          presentingComplaintsTable,
          presentingComplaintsTable.deletedAt,
        );

        await m.addColumn(
          complaintSubQuestionsTable,
          complaintSubQuestionsTable.updatedAt,
        );
        await m.addColumn(
          complaintSubQuestionsTable,
          complaintSubQuestionsTable.version,
        );
        await m.addColumn(
          complaintSubQuestionsTable,
          complaintSubQuestionsTable.deletedAt,
        );

        await m.addColumn(
          examinationSystemsTable,
          examinationSystemsTable.updatedAt,
        );
        await m.addColumn(
          examinationSystemsTable,
          examinationSystemsTable.version,
        );
        await m.addColumn(
          examinationSystemsTable,
          examinationSystemsTable.deletedAt,
        );

        await m.addColumn(diagnosesTable, diagnosesTable.updatedAt);
        await m.addColumn(diagnosesTable, diagnosesTable.version);
        await m.addColumn(diagnosesTable, diagnosesTable.deletedAt);

        await m.addColumn(drugsTable, drugsTable.updatedAt);
        await m.addColumn(drugsTable, drugsTable.version);
        await m.addColumn(drugsTable, drugsTable.deletedAt);

        await m.addColumn(
          prescriptionProtocolsTable,
          prescriptionProtocolsTable.updatedAt,
        );
        await m.addColumn(
          prescriptionProtocolsTable,
          prescriptionProtocolsTable.version,
        );
        await m.addColumn(
          prescriptionProtocolsTable,
          prescriptionProtocolsTable.deletedAt,
        );

        await m.createTable(unmappedTermsTable);
        await m.createTable(drugUsageTable);
      }
      if (from < 4) {
        await m.addColumn(patientQueueTable, patientQueueTable.consultationFee);
        await m.addColumn(patientQueueTable, patientQueueTable.isRevisit);
      }
    },
  );

  // --- QUEUE QUERIES ---

  Future<int> getNextTokenNumberForToday([DateTime? now]) async {
    final reference = now ?? DateTime.now();
    final startOfDay = DateTime(
      reference.year,
      reference.month,
      reference.day,
      0,
      0,
      0,
    );
    final endOfDay = DateTime(
      reference.year,
      reference.month,
      reference.day,
      23,
      59,
      59,
    );

    final query = selectOnly(patientQueueTable)
      ..addColumns([patientQueueTable.tokenNumber.max()])
      ..where(
        patientQueueTable.entryTime.isBiggerOrEqualValue(startOfDay) &
            patientQueueTable.entryTime.isSmallerOrEqualValue(endOfDay) &
            patientQueueTable.deletedAt.isNull(),
      );

    final row = await query.getSingle();
    final maxToken = row.read(patientQueueTable.tokenNumber.max());
    return (maxToken ?? 0) + 1;
  }

  Stream<List<PatientQueueEntry>> watchWaitingQueue() {
    return (select(patientQueueTable)
          ..where((t) => t.status.equals('WAITING') & t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.tokenNumber, mode: OrderingMode.asc),
          ]))
        .watch();
  }

  Stream<List<PatientQueueEntry>> watchAllQueueForToday([DateTime? now]) {
    final reference = now ?? DateTime.now();
    final startOfDay = DateTime(
      reference.year,
      reference.month,
      reference.day,
      0,
      0,
      0,
    );
    final endOfDay = DateTime(
      reference.year,
      reference.month,
      reference.day,
      23,
      59,
      59,
    );

    return (select(patientQueueTable)
          ..where(
            (t) =>
                t.entryTime.isBiggerOrEqualValue(startOfDay) &
                t.entryTime.isSmallerOrEqualValue(endOfDay) &
                t.deletedAt.isNull(),
          )
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.tokenNumber, mode: OrderingMode.asc),
          ]))
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
    String? encounterSnapshotJson,
    String? overrideReason,
  }) async {
    final now = DateTime.now();
    final companion = PatientQueueTableCompanion(
      status: Value(status),
      consultationStartTime: consultationStartTime != null
          ? Value(consultationStartTime)
          : const Value.absent(),
      completionTime: completionTime != null
          ? Value(completionTime)
          : const Value.absent(),
      compiledPrescriptionJson: compiledPrescriptionJson != null
          ? Value(compiledPrescriptionJson)
          : const Value.absent(),
      encounterSnapshotJson: encounterSnapshotJson != null
          ? Value(encounterSnapshotJson)
          : const Value.absent(),
      overrideReason: overrideReason != null
          ? Value(overrideReason)
          : const Value.absent(),
      updatedAt: Value(now),
    );
    final updated = await (update(
      patientQueueTable,
    )..where((t) => t.id.equals(id))).write(companion);
    return updated > 0;
  }

  Future<PatientQueueEntry?> getPatientQueueById(String id) {
    return (select(
      patientQueueTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  /// Searches historical queue entries by patient ID, phone, or name.
  /// Used by reception to quickly reload a returning patient.
  Future<List<PatientQueueEntry>> searchPreviousPatients(
    String query, {
    int limit = 20,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final like = '%${trimmed.toLowerCase()}%';
    final rows = await customSelect(
      'SELECT * FROM ${patientQueueTable.actualTableName} '
      'WHERE deleted_at IS NULL AND ('
      'LOWER(patient_name) LIKE ?1 '
      "OR LOWER(COALESCE(phone, '')) LIKE ?1 "
      "OR LOWER(COALESCE(patient_id, '')) LIKE ?1) "
      'ORDER BY entry_time DESC LIMIT ?2',
      variables: [Variable.withString(like), Variable.withInt(limit)],
      readsFrom: {patientQueueTable},
    ).get();

    return rows.map((row) => patientQueueTable.map(row.data)).toList();
  }

  /// Returns the latest visit recorded for a given persistent patient ID.
  Future<PatientQueueEntry?> getLatestVisitForPatientId(String patientId) {
    return (select(patientQueueTable)
          ..where((t) => t.patientId.equals(patientId) & t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.entryTime, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Returns all completed visits recorded for a given persistent patient ID (visit history).
  Future<List<PatientQueueEntry>> getVisitHistoryForPatient(String patientId) {
    return (select(patientQueueTable)
          ..where(
            (t) =>
                t.patientId.equals(patientId) &
                t.status.equals('COMPLETED') &
                t.deletedAt.isNull(),
          )
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.completionTime,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  /// Watches all non-deleted patient queue entries, optionally filtered by date range.
  Stream<List<PatientQueueEntry>> watchAllPatientQueueEntries({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = select(patientQueueTable)..where((t) => t.deletedAt.isNull());
    if (startDate != null) {
      query.where((t) => t.entryTime.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((t) => t.entryTime.isSmallerOrEqualValue(endDate));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.entryTime, mode: OrderingMode.desc),
    ]);
    return query.watch();
  }

  /// Gets all patient queue entries in a date range.
  Future<List<PatientQueueEntry>> getPatientQueueForDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = select(patientQueueTable)..where((t) => t.deletedAt.isNull());
    if (startDate != null) {
      query.where((t) => t.entryTime.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((t) => t.entryTime.isSmallerOrEqualValue(endDate));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.entryTime, mode: OrderingMode.desc),
    ]);
    return query.get();
  }

  /// Saves autosaved in-memory consultation draft into the database row.
  Future<void> saveEncounterDraft({
    required String id,
    required String draftJson,
  }) async {
    await (update(patientQueueTable)..where((t) => t.id.equals(id))).write(
      PatientQueueTableCompanion(
        compiledPrescriptionJson: Value(draftJson),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Releases a consultation back to the waiting queue (e.g. if cancelled or abandoned).
  Future<void> releaseConsultation(String id) async {
    await (update(patientQueueTable)..where((t) => t.id.equals(id))).write(
      PatientQueueTableCompanion(
        status: const Value('WAITING'),
        consultationStartTime: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // --- SOFT DELETE QUERY FOR QUEUE ---
  Future<void> softDeletePatientQueue(String id) async {
    await (update(patientQueueTable)..where((t) => t.id.equals(id))).write(
      PatientQueueTableCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // --- CATALOG QUERIES ---

  Future<List<ComorbidityEntry>> getAllComorbidities() {
    return (select(comorbiditiesTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<void> insertComorbidity(ComorbiditiesTableCompanion entry) {
    return into(
      comorbiditiesTable,
    ).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<List<PresentingComplaintEntry>> getAllComplaints() {
    return (select(presentingComplaintsTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
        .get();
  }

  Future<List<ComplaintSubQuestionEntry>> getSubQuestionsForComplaint(
    String complaintId,
  ) {
    return (select(complaintSubQuestionsTable)
          ..where(
            (t) => t.complaintId.equals(complaintId) & t.deletedAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.sequenceOrder)]))
        .get();
  }

  Future<List<ExaminationSystemEntry>> getAllExaminationSystems() {
    return (select(
      examinationSystemsTable,
    )..where((t) => t.deletedAt.isNull())).get();
  }

  Future<List<DiagnosisEntry>> getAllDiagnoses() {
    return (select(diagnosesTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<List<DrugEntry>> getAllDrugs() {
    return (select(drugsTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.brandName)]))
        .get();
  }

  /// Removes legacy seeded mock drugs (identified by 'drug_' prefix).
  Future<int> clearLegacyMockDrugs() async {
    return (delete(drugsTable)..where((t) => t.id.like('drug_%'))).go();
  }

  /// Bulk syncs drugs from Supabase public.drugmaster (Read-Only Master Formulary).
  Future<int> syncDrugsFromSupabase(List<Map<String, dynamic>> remoteDrugs) async {
    return transaction(() async {
      // 1. Clean out any legacy mock drugs
      await clearLegacyMockDrugs();

      // 2. Map and insert/replace remote drugs
      for (final row in remoteDrugs) {
        final id = (row['id'] as String?)?.trim();
        if (id == null || id.isEmpty) continue;

        final name = (row['name'] as String?)?.trim() ?? 'Unknown Drug';
        final content = (row['content'] as String?)?.trim() ?? name;
        final category = (row['category'] as String?)?.trim() ?? '';

        final drugClass = _mapDrugCategory(category, content, name);
        final defaultDose = _mapDefaultDose(name);
        final defaultRoute = _mapDefaultRoute(name, category);
        final defaultFrequency = _mapDefaultFrequency(name);
        final defaultDuration = _mapDefaultDuration(name);
        final defaultInstructions = _mapDefaultInstructions(name, category);
        final version = (row['version'] as int?) ?? 1;

        await into(drugsTable).insert(
          DrugsTableCompanion(
            id: Value(id),
            brandName: Value(name),
            genericName: Value(content),
            drugClass: Value(drugClass),
            defaultDose: Value(defaultDose),
            defaultRoute: Value(defaultRoute),
            defaultFrequency: Value(defaultFrequency),
            defaultDuration: Value(defaultDuration),
            defaultInstructions: Value(defaultInstructions),
            updatedAt: Value(DateTime.now()),
            version: Value(version),
            deletedAt: const Value(null),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
      return remoteDrugs.length;
    });
  }

  /// Bulk syncs Presenting Complaints from Supabase (nexus.presenting_complaints).
  Future<int> syncPresentingComplaintsFromSupabase(
    List<Map<String, dynamic>> remoteRows,
  ) async {
    return transaction(() async {
      for (final row in remoteRows) {
        final id = (row['id'] as String?)?.trim();
        if (id == null || id.isEmpty) continue;
        final name = (row['name'] as String?)?.trim() ?? '';
        final category = (row['category'] as String?)?.trim() ?? 'General';
        final displayOrder = (row['display_order'] as int?) ?? 0;
        final version = (row['version'] as int?) ?? 1;

        await into(presentingComplaintsTable).insert(
          PresentingComplaintsTableCompanion(
            id: Value(id),
            name: Value(name),
            category: Value(category),
            displayOrder: Value(displayOrder),
            updatedAt: Value(DateTime.now()),
            version: Value(version),
            deletedAt: const Value(null),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
      return remoteRows.length;
    });
  }

  /// Bulk syncs Complaint Sub-Questions from Supabase (nexus.complaint_sub_questions).
  Future<int> syncComplaintSubQuestionsFromSupabase(
    List<Map<String, dynamic>> remoteRows,
  ) async {
    return transaction(() async {
      for (final row in remoteRows) {
        final id = (row['id'] as String?)?.trim();
        final complaintId = (row['complaint_id'] as String?)?.trim();
        if (id == null || id.isEmpty || complaintId == null || complaintId.isEmpty) continue;

        final questionLabel = (row['question_label'] as String?)?.trim() ?? '';
        final rawOptions = row['options_json'];
        final optionsJson = rawOptions is String ? rawOptions : jsonEncode(rawOptions ?? []);
        final sentenceTemplate = (row['sentence_template'] as String?)?.trim() ?? '';
        final isMultiSelect = (row['is_multi_select'] as bool?) ?? false;
        final sequenceOrder = (row['sequence_order'] as int?) ?? 0;
        final version = (row['version'] as int?) ?? 1;

        await into(complaintSubQuestionsTable).insert(
          ComplaintSubQuestionsTableCompanion(
            id: Value(id),
            complaintId: Value(complaintId),
            questionLabel: Value(questionLabel),
            optionsJson: Value(optionsJson),
            sentenceTemplate: Value(sentenceTemplate),
            isMultiSelect: Value(isMultiSelect),
            sequenceOrder: Value(sequenceOrder),
            updatedAt: Value(DateTime.now()),
            version: Value(version),
            deletedAt: const Value(null),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
      return remoteRows.length;
    });
  }

  /// Bulk syncs Examination Systems from Supabase (nexus.examination_systems).
  Future<int> syncExaminationSystemsFromSupabase(
    List<Map<String, dynamic>> remoteRows,
  ) async {
    return transaction(() async {
      for (final row in remoteRows) {
        final id = (row['id'] as String?)?.trim();
        if (id == null || id.isEmpty) continue;
        final systemName = (row['system_name'] as String?)?.trim() ?? '';
        final defaultNormalText = (row['default_normal_text'] as String?)?.trim() ?? '';
        final rawFindings = row['abnormal_findings_json'];
        final abnormalFindingsJson =
            rawFindings is String ? rawFindings : jsonEncode(rawFindings ?? []);
        final version = (row['version'] as int?) ?? 1;

        await into(examinationSystemsTable).insert(
          ExaminationSystemsTableCompanion(
            id: Value(id),
            systemName: Value(systemName),
            defaultNormalText: Value(defaultNormalText),
            abnormalFindingsJson: Value(abnormalFindingsJson),
            updatedAt: Value(DateTime.now()),
            version: Value(version),
            deletedAt: const Value(null),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
      return remoteRows.length;
    });
  }

  /// Bulk syncs Diagnoses from Supabase (nexus.diagnoses).
  Future<int> syncDiagnosesFromSupabase(
    List<Map<String, dynamic>> remoteRows,
  ) async {
    return transaction(() async {
      for (final row in remoteRows) {
        final id = (row['id'] as String?)?.trim();
        if (id == null || id.isEmpty) continue;
        final name = (row['name'] as String?)?.trim() ?? '';
        final icd10Code = (row['icd10_code'] as String?)?.trim();
        final rawLinked = row['linked_complaint_ids'];
        final linkedComplaintIds =
            rawLinked is String ? rawLinked : jsonEncode(rawLinked ?? []);
        final version = (row['version'] as int?) ?? 1;

        await into(diagnosesTable).insert(
          DiagnosesTableCompanion(
            id: Value(id),
            name: Value(name),
            icd10Code: Value(icd10Code),
            linkedComplaintIds: Value(linkedComplaintIds),
            updatedAt: Value(DateTime.now()),
            version: Value(version),
            deletedAt: const Value(null),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
      return remoteRows.length;
    });
  }

  /// Bulk syncs Prescription Protocols from Supabase (nexus.prescription_protocols).
  Future<int> syncPrescriptionProtocolsFromSupabase(
    List<Map<String, dynamic>> remoteRows,
  ) async {
    return transaction(() async {
      for (final row in remoteRows) {
        final id = (row['id'] as String?)?.trim();
        final diagnosisId = (row['diagnosis_id'] as String?)?.trim();
        if (id == null || id.isEmpty || diagnosisId == null || diagnosisId.isEmpty) continue;

        final rawItems = row['protocol_items_json'];
        final protocolItemsJson =
            rawItems is String ? rawItems : jsonEncode(rawItems ?? []);
        final generalAdvice = (row['general_advice'] as String?)?.trim() ?? '';
        final version = (row['version'] as int?) ?? 1;

        await into(prescriptionProtocolsTable).insert(
          PrescriptionProtocolsTableCompanion(
            id: Value(id),
            diagnosisId: Value(diagnosisId),
            protocolItemsJson: Value(protocolItemsJson),
            generalAdvice: Value(generalAdvice),
            updatedAt: Value(DateTime.now()),
            version: Value(version),
            deletedAt: const Value(null),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
      return remoteRows.length;
    });
  }

  /// Bulk syncs Comorbidities from Supabase (nexus.comorbidities).
  Future<int> syncComorbiditiesFromSupabase(
    List<Map<String, dynamic>> remoteRows,
  ) async {
    return transaction(() async {
      for (final row in remoteRows) {
        final id = (row['id'] as String?)?.trim();
        if (id == null || id.isEmpty) continue;
        final name = (row['name'] as String?)?.trim() ?? '';
        final rawContra = row['contraindicated_drug_classes'];
        final contraJson =
            rawContra is String ? rawContra : jsonEncode(rawContra ?? []);
        final version = (row['version'] as int?) ?? 1;

        await into(comorbiditiesTable).insert(
          ComorbiditiesTableCompanion(
            id: Value(id),
            name: Value(name),
            contraindicatedDrugClasses: Value(contraJson),
            updatedAt: Value(DateTime.now()),
            version: Value(version),
            deletedAt: const Value(null),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
      return remoteRows.length;
    });
  }

  static String _mapDrugCategory(String? category, String? content, String name) {
    final cat = (category ?? '').toUpperCase();
    final cont = (content ?? '').toUpperCase();

    final classes = <String>[];

    if (cont.contains('OFLOXACIN') ||
        cont.contains('CIPROFLOXACIN') ||
        cont.contains('LEVOFLOXACIN') ||
        cont.contains('NORFLOXACIN')) {
      classes.add('Fluoroquinolones');
    }

    if (cont.contains('METFORMIN')) {
      classes.add('Metformin');
    }

    if (cont.contains('IBUPROFEN') ||
        cont.contains('DICLOFENAC') ||
        cont.contains('ACECLOFENAC') ||
        cont.contains('MEFENAMIC') ||
        cont.contains('PIROXICAM') ||
        cont.contains('NIMESULIDE')) {
      classes.add('NSAID');
    }

    if (cont.contains('PARACETAMOL')) {
      classes.add('Antipyretic');
      classes.add('Analgesic');
    }

    if (cont.contains('PREDNISOLONE') ||
        cont.contains('DEXAMETHASONE') ||
        cont.contains('DEFLAZACORT') ||
        cont.contains('BETAMETHASONE')) {
      classes.add('Steroid');
    }

    if (cont.contains('AMLODIPINE') ||
        cont.contains('TELMISARTAN') ||
        cont.contains('LOSARTAN') ||
        cont.contains('ENALAPRIL') ||
        cont.contains('RAMIPRIL')) {
      classes.add('ACE Inhibitors');
      classes.add('Antihypertensive');
    }

    if (cont.contains('ATENOLOL') ||
        cont.contains('METOPROLOL') ||
        cont.contains('PROPRANOLOL') ||
        cont.contains('BISOPROLOL')) {
      classes.add('Beta Blockers');
    }

    if (cat.contains('ANTIBIOTIC') ||
        cont.contains('AMOXICILLIN') ||
        cont.contains('AZITHROMYCIN') ||
        cont.contains('CEFIXIME') ||
        cont.contains('CEFPODOXIME')) {
      if (!classes.contains('Antibiotic')) classes.add('Antibiotic');
    }

    if (cat.contains('GIT') ||
        cont.contains('PANTOPRAZOLE') ||
        cont.contains('RABEPRAZOLE') ||
        cont.contains('OMEPRAZOLE') ||
        cont.contains('DOMPERIDONE')) {
      classes.add('Antacid');
    }

    if (cat.contains('ANTICOLD') ||
        cat.contains('COUGH') ||
        cont.contains('CETIRIZINE') ||
        cont.contains('LEVOCETIRIZINE') ||
        cont.contains('PHENYLEPHRINE') ||
        cont.contains('CHLORPHENIRAMINE')) {
      classes.add('Antihistamine');
      classes.add('Antitussive');
    }

    if (cat.contains('CARDIAC')) {
      if (!classes.contains('Antihypertensive')) classes.add('Antihypertensive');
    }

    if (cat.contains('DIABETIC')) {
      if (!classes.contains('Antidiabetic')) classes.add('Antidiabetic');
    }

    if (cat.contains('INJECTABLE')) {
      classes.add('Injectable');
    }

    if (classes.isNotEmpty) {
      return classes.toSet().join(' / ');
    }

    if (category != null && category.trim().isNotEmpty) {
      var cleaned = category.replaceFirst(RegExp(r'^\(\d+\)\s*'), '').trim();
      if (cleaned.length > 25) {
        cleaned = cleaned.substring(0, 25);
      }
      return cleaned;
    }

    return 'General';
  }

  static String _mapDefaultDose(String name) {
    final upper = name.toUpperCase();
    if (upper.contains('SYP') || upper.contains('SYRUP') || upper.contains('SUSP')) {
      return '5 ml';
    }
    if (upper.contains('DROPS') || upper.contains('DROP')) {
      return '5 drops';
    }
    if (upper.contains('INJ')) {
      return '1 vial';
    }
    if (upper.contains('GEL') || upper.contains('OINT') || upper.contains('CREAM')) {
      return 'Apply locally';
    }
    if (upper.contains('CAP')) {
      return '1 cap';
    }
    return '1 tab';
  }

  static String _mapDefaultRoute(String name, String? category) {
    final upper = name.toUpperCase();
    final cat = (category ?? '').toUpperCase();
    if (upper.contains('INJ') || cat.contains('INJECTABLE')) {
      return 'IV/IM';
    }
    if (upper.contains('GEL') || upper.contains('OINT') || upper.contains('CREAM') || upper.contains('LOTION')) {
      return 'Topical';
    }
    if (upper.contains('EYE') || upper.contains('EAR')) {
      return 'Local';
    }
    return 'PO';
  }

  static String _mapDefaultFrequency(String name) {
    final upper = name.toUpperCase();
    if (upper.contains('RABE') || upper.contains('PANT') || upper.contains('OMEP')) {
      return 'OD Morning';
    }
    if (upper.contains('SYP') || upper.contains('SYRUP') || upper.contains('SUSP') || upper.contains('DROPS')) {
      return 'TID';
    }
    return 'BD';
  }

  static String _mapDefaultDuration(String name) {
    final upper = name.toUpperCase();
    if (upper.contains('AZIROM') || upper.contains('AZITH')) {
      return '3 days';
    }
    return '5 days';
  }

  static String _mapDefaultInstructions(String name, String? category) {
    final upper = name.toUpperCase();
    final cat = (category ?? '').toUpperCase();
    if (upper.contains('RABE') || upper.contains('PANT') || upper.contains('OMEP')) {
      return 'Before breakfast (empty stomach)';
    }
    if (upper.contains('GEL') || upper.contains('OINT') || upper.contains('CREAM')) {
      return 'Apply gently to affected area';
    }
    if (upper.contains('EYE') || upper.contains('EAR')) {
      return 'Instill in affected area';
    }
    if (upper.contains('INJ') || cat.contains('INJECTABLE')) {
      return 'Administer under medical supervision';
    }
    return 'After food';
  }

  Future<PrescriptionProtocolEntry?> getProtocolForDiagnosis(
    String diagnosisId,
  ) {
    return (select(prescriptionProtocolsTable)..where(
          (t) => t.diagnosisId.equals(diagnosisId) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<List<PrescriptionProtocolEntry>> getAllProtocols() {
    return (select(prescriptionProtocolsTable)
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  // --- ADMIN CATALOG EDIT & INSERT OPERATIONS ---

  Future<void> insertOrUpdateComplaint(
    PresentingComplaintsTableCompanion entry,
  ) {
    return into(presentingComplaintsTable).insert(
      entry,
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<bool> softDeleteComplaint(String id) async {
    final updated = await (update(presentingComplaintsTable)
          ..where((t) => t.id.equals(id)))
        .write(
      PresentingComplaintsTableCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return updated > 0;
  }

  Future<void> insertOrUpdateComorbidity(
    ComorbiditiesTableCompanion entry,
  ) {
    return into(comorbiditiesTable).insert(
      entry,
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<bool> softDeleteComorbidity(String id) async {
    final updated = await (update(comorbiditiesTable)
          ..where((t) => t.id.equals(id)))
        .write(
      ComorbiditiesTableCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return updated > 0;
  }

  Future<void> insertOrUpdateDiagnosis(
    DiagnosesTableCompanion entry,
  ) {
    return into(diagnosesTable).insert(
      entry,
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<bool> softDeleteDiagnosis(String id) async {
    final updated = await (update(diagnosesTable)
          ..where((t) => t.id.equals(id)))
        .write(
      DiagnosesTableCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return updated > 0;
  }

  Future<void> insertOrUpdateProtocol(
    PrescriptionProtocolsTableCompanion entry,
  ) {
    return into(prescriptionProtocolsTable).insert(
      entry,
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<bool> softDeleteProtocol(String id) async {
    final updated = await (update(prescriptionProtocolsTable)
          ..where((t) => t.id.equals(id)))
        .write(
      PrescriptionProtocolsTableCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return updated > 0;
  }

  // --- CATALOG EDIT & SOFT-DELETE OPERATIONS ---

  Future<bool> updateDrug({
    required String id,
    required String brandName,
    required String genericName,
    required String drugClass,
    required String defaultDose,
    required String defaultRoute,
    required String defaultFrequency,
    required String defaultDuration,
    required String defaultInstructions,
  }) async {
    final existing = await (select(
      drugsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    final newVersion = (existing?.version ?? 1) + 1;

    final updated = await (update(drugsTable)..where((t) => t.id.equals(id)))
        .write(
          DrugsTableCompanion(
            brandName: Value(brandName),
            genericName: Value(genericName),
            drugClass: Value(drugClass),
            defaultDose: Value(defaultDose),
            defaultRoute: Value(defaultRoute),
            defaultFrequency: Value(defaultFrequency),
            defaultDuration: Value(defaultDuration),
            defaultInstructions: Value(defaultInstructions),
            updatedAt: Value(DateTime.now()),
            version: Value(newVersion),
          ),
        );
    return updated > 0;
  }

  Future<bool> softDeleteDrug(String id) async {
    final existing = await (select(
      drugsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    final newVersion = (existing?.version ?? 1) + 1;

    final updated = await (update(drugsTable)..where((t) => t.id.equals(id)))
        .write(
          DrugsTableCompanion(
            deletedAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
            version: Value(newVersion),
          ),
        );
    return updated > 0;
  }

  // --- UNMAPPED TERMS LOGGING ---

  Future<void> logUnmappedTerm({
    required String id,
    required String category,
    required String term,
    String? encounterId,
  }) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;

    await into(unmappedTermsTable).insert(
      UnmappedTermsTableCompanion.insert(
        id: id,
        category: category,
        term: trimmed,
        encounterId: Value(encounterId),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<List<UnmappedTermEntry>> getUnmappedTerms({String? category}) {
    final query = select(unmappedTermsTable)
      ..where((t) => t.deletedAt.isNull());
    if (category != null) {
      query.where((t) => t.category.equals(category));
    }
    return (query..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  // --- DRUG USAGE FREQUENCY ---

  Future<void> recordDrugUsage(String drugId) async {
    final now = DateTime.now();
    final existing = await (select(
      drugUsageTable,
    )..where((t) => t.drugId.equals(drugId))).getSingleOrNull();
    if (existing == null) {
      await into(drugUsageTable).insert(
        DrugUsageTableCompanion.insert(
          drugId: drugId,
          usageCount: const Value(1),
          lastUsedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    } else {
      await (update(
        drugUsageTable,
      )..where((t) => t.drugId.equals(drugId))).write(
        DrugUsageTableCompanion(
          usageCount: Value(existing.usageCount + 1),
          lastUsedAt: Value(now),
          updatedAt: Value(now),
          version: Value(existing.version + 1),
        ),
      );
    }
  }

  Future<List<DrugEntry>> getTopMedications({int limit = 20}) async {
    // Select drugs ordered by usage count descending from drugUsageTable
    final query = customSelect(
      'SELECT d.* FROM ${drugsTable.actualTableName} d '
      'LEFT JOIN ${drugUsageTable.actualTableName} u ON d.id = u.drug_id '
      'WHERE d.deleted_at IS NULL '
      'ORDER BY COALESCE(u.usage_count, 0) DESC, d.brand_name ASC '
      'LIMIT ?1',
      variables: [Variable.withInt(limit)],
      readsFrom: {drugsTable, drugUsageTable},
    );

    final rows = await query.get();
    return rows.map((r) => drugsTable.map(r.data)).toList();
  }

  Future<void> ensureSeeded() async {
    final count = await (selectOnly(
      diagnosesTable,
    )..addColumns([diagnosesTable.id.count()])).getSingle();
    final total = count.read(diagnosesTable.id.count()) ?? 0;
    if (total == 0) {
      await DatabaseSeeder.seedAll(this);
    }
    // Always purge any legacy mock drugs that may still be in the database
    await clearLegacyMockDrugs();
  }
}
