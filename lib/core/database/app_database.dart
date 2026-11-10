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

  Future<PrescriptionProtocolEntry?> getProtocolForDiagnosis(
    String diagnosisId,
  ) {
    return (select(prescriptionProtocolsTable)..where(
          (t) => t.diagnosisId.equals(diagnosisId) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
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
  }
}
