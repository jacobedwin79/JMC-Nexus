import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class SyncState {
  final bool isConnected;
  final bool isSyncing;
  final String? syncError;
  final DateTime? lastSyncedAt;

  const SyncState({
    this.isConnected = false,
    this.isSyncing = false,
    this.syncError,
    this.lastSyncedAt,
  });

  SyncState copyWith({
    bool? isConnected,
    bool? isSyncing,
    String? syncError,
    DateTime? lastSyncedAt,
  }) {
    return SyncState(
      isConnected: isConnected ?? this.isConnected,
      isSyncing: isSyncing ?? this.isSyncing,
      syncError: syncError,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}

class RealtimeQueueService extends Notifier<SyncState> {
  SupabaseClient? _client;
  RealtimeChannel? _queueChannel;

  AppDatabase get _db => ref.read(appDatabaseProvider);

  @override
  SyncState build() {
    ref.onDispose(() {
      _queueChannel?.unsubscribe();
    });
    return const SyncState();
  }

  /// Initializes Supabase connection with credentials
  Future<void> initialize({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    try {
      state = state.copyWith(isSyncing: true, syncError: null);

      if (Supabase.instance.isInitialized) {
        _client = Supabase.instance.client;
      } else {
        await Supabase.initialize(
          url: supabaseUrl,
          // ignore: deprecated_member_use
          anonKey: supabaseAnonKey,
        );
        _client = Supabase.instance.client;
      }

      _subscribeToPatientQueue();
      state = state.copyWith(
        isConnected: true,
        isSyncing: false,
        lastSyncedAt: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isConnected: false,
        isSyncing: false,
        syncError: 'Failed to connect to Supabase Realtime: $e',
      );
    }
  }

  void _subscribeToPatientQueue() {
    if (_client == null) return;

    _queueChannel = _client!
        .channel('public:patient_queue')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'patient_queue',
          callback: (payload) async {
            try {
              final record = payload.newRecord;
              if (record.isEmpty) return;

              final id = record['id'] as String;
              final patientId = record['patient_id'] as String?;
              final tokenNumber = record['token_number'] as int;
              final patientName = record['patient_name'] as String;
              final age = record['age'] as int;
              final gender = record['gender'] as String;
              final phone = record['phone'] as String?;
              final vitalsJson = record['vitals_json'] as String?;
              final comorbIds = record['initial_comorb_ids'] as String?;
              final allergies = record['allergies'] as String?;
              final lmp = record['lmp'] as String?;
              final isPregnant = record['is_pregnant'] as bool? ?? false;
              final status = record['status'] as String;
              final entryTime = DateTime.parse(record['entry_time'] as String);

              final consultTimeStr = record['consultation_start_time'] as String?;
              final consultTime = consultTimeStr != null ? DateTime.parse(consultTimeStr) : null;

              final compTimeStr = record['completion_time'] as String?;
              final compTime = compTimeStr != null ? DateTime.parse(compTimeStr) : null;

              final rxJson = record['compiled_prescription_json'] as String?;

              // Upsert into local SQLite Drift database
              await _db.into(_db.patientQueueTable).insertOnConflictUpdate(
                    PatientQueueTableCompanion.insert(
                      id: id,
                      patientId: Value(patientId),
                      tokenNumber: tokenNumber,
                      patientName: patientName,
                      age: age,
                      gender: gender,
                      phone: Value(phone),
                      vitalsJson: Value(vitalsJson),
                      initialComorbIds: Value(comorbIds),
                      allergies: Value(allergies),
                      lmp: Value(lmp),
                      isPregnant: Value(isPregnant),
                      status: status,
                      entryTime: entryTime,
                      consultationStartTime: Value(consultTime),
                      completionTime: Value(compTime),
                      compiledPrescriptionJson: Value(rxJson),
                    ),
                  );

              state = state.copyWith(lastSyncedAt: DateTime.now());
            } catch (e) {
              debugPrint('Error applying remote queue update to SQLite: $e');
            }
          },
        )
        .subscribe();
  }

  /// Pushes a local patient queue record up to Supabase
  Future<void> pushPatientQueueRecord({
    required String id,
    String? patientId,
    required int tokenNumber,
    required String patientName,
    required int age,
    required String gender,
    String? phone,
    String? vitalsJson,
    String? initialComorbIds,
    String? allergies,
    String? lmp,
    bool isPregnant = false,
    required String status,
    required DateTime entryTime,
    DateTime? consultationStartTime,
    DateTime? completionTime,
    String? compiledPrescriptionJson,
  }) async {
    if (_client == null || !state.isConnected) return;

    try {
      await _client!.from('patient_queue').upsert({
        'id': id,
        'patient_id': patientId,
        'token_number': tokenNumber,
        'patient_name': patientName,
        'age': age,
        'gender': gender,
        'phone': phone,
        'vitals_json': vitalsJson,
        'initial_comorb_ids': initialComorbIds,
        'allergies': allergies,
        'lmp': lmp,
        'is_pregnant': isPregnant,
        'status': status,
        'entry_time': entryTime.toUtc().toIso8601String(),
        'consultation_start_time': consultationStartTime?.toUtc().toIso8601String(),
        'completion_time': completionTime?.toUtc().toIso8601String(),
        'compiled_prescription_json': compiledPrescriptionJson,
      });
      state = state.copyWith(lastSyncedAt: DateTime.now());
    } catch (e) {
      debugPrint('Failed to push patient queue to Supabase: $e');
    }
  }
}

final realtimeQueueServiceProvider =
    NotifierProvider<RealtimeQueueService, SyncState>(RealtimeQueueService.new);
