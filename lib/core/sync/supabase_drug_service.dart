import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../config/clinic_settings.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class SupabaseDrugSyncState {
  final bool isLoading;
  final int syncedCount;
  final DateTime? lastSyncTime;
  final String? error;

  const SupabaseDrugSyncState({
    this.isLoading = false,
    this.syncedCount = 0,
    this.lastSyncTime,
    this.error,
  });

  SupabaseDrugSyncState copyWith({
    bool? isLoading,
    int? syncedCount,
    DateTime? lastSyncTime,
    String? error,
  }) {
    return SupabaseDrugSyncState(
      isLoading: isLoading ?? this.isLoading,
      syncedCount: syncedCount ?? this.syncedCount,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      error: error,
    );
  }
}

class SupabaseCatalogSyncSummary {
  final int drugCount;
  final int complaintCount;
  final int subQuestionCount;
  final int examSystemCount;
  final int diagnosisCount;
  final int protocolCount;
  final int comorbidityCount;
  final DateTime syncTime;

  const SupabaseCatalogSyncSummary({
    this.drugCount = 0,
    this.complaintCount = 0,
    this.subQuestionCount = 0,
    this.examSystemCount = 0,
    this.diagnosisCount = 0,
    this.protocolCount = 0,
    this.comorbidityCount = 0,
    required this.syncTime,
  });

  int get totalRecords =>
      drugCount +
      complaintCount +
      subQuestionCount +
      examSystemCount +
      diagnosisCount +
      protocolCount +
      comorbidityCount;
}

class SupabaseCatalogSyncState {
  final bool isLoading;
  final SupabaseCatalogSyncSummary? summary;
  final String? error;

  const SupabaseCatalogSyncState({
    this.isLoading = false,
    this.summary,
    this.error,
  });

  SupabaseCatalogSyncState copyWith({
    bool? isLoading,
    SupabaseCatalogSyncSummary? summary,
    String? error,
  }) {
    return SupabaseCatalogSyncState(
      isLoading: isLoading ?? this.isLoading,
      summary: summary ?? this.summary,
      error: error,
    );
  }
}

class SupabaseDrugSyncNotifier extends Notifier<SupabaseDrugSyncState> {
  AppDatabase get _db => ref.read(appDatabaseProvider);
  ClinicSettings get _settings => ref.read(clinicSettingsProvider);

  @override
  SupabaseDrugSyncState build() {
    return const SupabaseDrugSyncState();
  }

  /// Synchronizes drugs from Supabase public.drugmaster (Read-Only Master Formulary)
  Future<int> syncFromSupabase({bool force = false}) async {
    if (state.isLoading) return state.syncedCount;

    state = state.copyWith(isLoading: true, error: null);

    final url = _settings.supabaseUrl.trim();
    final key = _settings.supabaseAnonKey.trim();

    if (url.isEmpty || key.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Supabase credentials are not configured.',
      );
      return 0;
    }

    try {
      final endpoint = Uri.parse('$url/rest/v1/drugmaster?select=*&order=name.asc');
      final response = await http.get(
        endpoint,
        headers: {
          'apikey': key,
          'Authorization': 'Bearer $key',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch drugs from Supabase (HTTP ${response.statusCode}): ${response.body}',
        );
      }

      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw Exception('Unexpected response format from Supabase drugmaster table.');
      }

      final List<Map<String, dynamic>> rawDrugs = decoded
          .whereType<Map<String, dynamic>>()
          .toList();

      final count = await _db.syncDrugsFromSupabase(rawDrugs);

      state = state.copyWith(
        isLoading: false,
        syncedCount: count,
        lastSyncTime: DateTime.now(),
        error: null,
      );

      debugPrint('Successfully synced $count drugs from Supabase public.drugmaster');
      return count;
    } catch (e) {
      final errorMsg = e.toString();
      debugPrint('Error syncing drugs from Supabase: $errorMsg');
      state = state.copyWith(
        isLoading: false,
        error: errorMsg,
      );
      return 0;
    }
  }
}

final supabaseDrugSyncProvider =
    NotifierProvider<SupabaseDrugSyncNotifier, SupabaseDrugSyncState>(
  SupabaseDrugSyncNotifier.new,
);

class SupabaseCatalogSyncNotifier extends Notifier<SupabaseCatalogSyncState> {
  AppDatabase get _db => ref.read(appDatabaseProvider);
  ClinicSettings get _settings => ref.read(clinicSettingsProvider);

  @override
  SupabaseCatalogSyncState build() {
    return const SupabaseCatalogSyncState();
  }

  Map<String, String> _buildHeaders() {
    final key = _settings.supabaseAnonKey.trim();
    return {
      'apikey': key,
      'Authorization': 'Bearer $key',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<List<Map<String, dynamic>>> _fetchTable(String path) async {
    final url = _settings.supabaseUrl.trim();
    final endpoint = Uri.parse('$url/rest/v1/$path');
    final response = await http.get(endpoint, headers: _buildHeaders());
    if (response.statusCode != 200) {
      throw Exception('GET $path failed (HTTP ${response.statusCode}): ${response.body}');
    }
    final dynamic decoded = jsonDecode(response.body);
    if (decoded is! List) throw Exception('GET $path returned non-list');
    return decoded.whereType<Map<String, dynamic>>().toList();
  }

  /// Syncs all clinical master catalogs from Supabase (nexus schema and public.drugmaster).
  Future<SupabaseCatalogSyncSummary> syncAllCatalogs() async {
    state = state.copyWith(isLoading: true, error: null);

    final url = _settings.supabaseUrl.trim();
    final key = _settings.supabaseAnonKey.trim();

    if (url.isEmpty || key.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Supabase credentials are not configured.',
      );
      throw Exception('Supabase credentials are not configured.');
    }

    try {
      // 1. Drugs (public.drugmaster)
      final rawDrugs = await _fetchTable('drugmaster?select=*&order=name.asc');
      final dCount = await _db.syncDrugsFromSupabase(rawDrugs);

      // 2. Presenting Complaints (nexus.presenting_complaints)
      final rawComplaints = await _fetchTable(
        'presenting_complaints?select=*&order=display_order.asc',
      );
      final cCount = await _db.syncPresentingComplaintsFromSupabase(rawComplaints);

      // 3. Complaint Sub-Questions (nexus.complaint_sub_questions)
      final rawSubQuestions = await _fetchTable(
        'complaint_sub_questions?select=*&order=sequence_order.asc',
      );
      final sqCount = await _db.syncComplaintSubQuestionsFromSupabase(rawSubQuestions);

      // 4. Examination Systems (nexus.examination_systems)
      final rawExam = await _fetchTable(
        'examination_systems?select=*&order=id.asc',
      );
      final esCount = await _db.syncExaminationSystemsFromSupabase(rawExam);

      // 5. Diagnoses (nexus.diagnoses)
      final rawDiag = await _fetchTable(
        'diagnoses?select=*&order=name.asc',
      );
      final diagCount = await _db.syncDiagnosesFromSupabase(rawDiag);

      // 6. Prescription Protocols (nexus.prescription_protocols)
      final rawProto = await _fetchTable(
        'prescription_protocols?select=*&order=id.asc',
      );
      final protoCount = await _db.syncPrescriptionProtocolsFromSupabase(rawProto);

      // 7. Comorbidities (nexus.comorbidities)
      final rawComorbs = await _fetchTable(
        'comorbidities?select=*&order=name.asc',
      );
      final comorbCount = await _db.syncComorbiditiesFromSupabase(rawComorbs);

      final summary = SupabaseCatalogSyncSummary(
        drugCount: dCount,
        complaintCount: cCount,
        subQuestionCount: sqCount,
        examSystemCount: esCount,
        diagnosisCount: diagCount,
        protocolCount: protoCount,
        comorbidityCount: comorbCount,
        syncTime: DateTime.now(),
      );

      state = state.copyWith(isLoading: false, summary: summary, error: null);
      debugPrint(
        'Synced all clinical catalogs from Supabase: ${summary.totalRecords} records.',
      );
      return summary;
    } catch (e) {
      final msg = e.toString();
      debugPrint('Error syncing clinical catalogs from Supabase: $msg');
      state = state.copyWith(isLoading: false, error: msg);
      rethrow;
    }
  }

  /// Upserts or edits a record in Supabase (Admin role only)
  Future<void> upsertInSupabase(String table, Map<String, dynamic> data) async {
    final url = _settings.supabaseUrl.trim();
    final endpoint = Uri.parse('$url/rest/v1/$table');
    final response = await http.post(
      endpoint,
      headers: {
        ..._buildHeaders(),
        'Prefer': 'resolution=merge-duplicates,return=representation',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode >= 300) {
      throw Exception('Failed to upsert $table in Supabase: ${response.body}');
    }
  }

  /// Deletes a record in Supabase (Admin role only)
  Future<void> deleteInSupabase(String table, String id) async {
    final url = _settings.supabaseUrl.trim();
    final endpoint = Uri.parse('$url/rest/v1/$table?id=eq.$id');
    final response = await http.delete(endpoint, headers: _buildHeaders());
    if (response.statusCode >= 300) {
      throw Exception('Failed to delete $id in $table: ${response.body}');
    }
  }
}

final supabaseCatalogSyncProvider =
    NotifierProvider<SupabaseCatalogSyncNotifier, SupabaseCatalogSyncState>(
  SupabaseCatalogSyncNotifier.new,
);
