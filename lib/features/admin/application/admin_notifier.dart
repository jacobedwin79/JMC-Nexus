import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/config/clinic_settings.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_mappers.dart';
import '../../../core/database/database_provider.dart';
import '../../encounter/domain/patient_queue_item.dart';
import '../domain/admin_metrics.dart';

enum AdminDateRangeFilter {
  today('Today'),
  yesterday('Yesterday'),
  last7Days('Last 7 Days'),
  thisMonth('This Month'),
  allTime('All Time');

  final String label;
  const AdminDateRangeFilter(this.label);
}

class AdminPanelState {
  final AdminDateRangeFilter selectedFilter;
  final bool isLoading;
  final List<PatientQueueItem> allPatients;
  final List<PatientQueueItem> filteredPatients;
  final AdminSummaryMetrics summary;
  final List<DailyIncomeMetric> dailyIncomeList;
  final List<DiagnosisStatMetric> topDiagnoses;
  final DemographicsMetric demographics;
  final String searchQuery;
  final String statusFilter; // 'ALL', 'COMPLETED', 'WAITING', 'REVISITS'

  const AdminPanelState({
    this.selectedFilter = AdminDateRangeFilter.today,
    this.isLoading = false,
    this.allPatients = const [],
    this.filteredPatients = const [],
    this.summary = const AdminSummaryMetrics(),
    this.dailyIncomeList = const [],
    this.topDiagnoses = const [],
    this.demographics = const DemographicsMetric(),
    this.searchQuery = '',
    this.statusFilter = 'ALL',
  });

  AdminPanelState copyWith({
    AdminDateRangeFilter? selectedFilter,
    bool? isLoading,
    List<PatientQueueItem>? allPatients,
    List<PatientQueueItem>? filteredPatients,
    AdminSummaryMetrics? summary,
    List<DailyIncomeMetric>? dailyIncomeList,
    List<DiagnosisStatMetric>? topDiagnoses,
    DemographicsMetric? demographics,
    String? searchQuery,
    String? statusFilter,
  }) {
    return AdminPanelState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isLoading: isLoading ?? this.isLoading,
      allPatients: allPatients ?? this.allPatients,
      filteredPatients: filteredPatients ?? this.filteredPatients,
      summary: summary ?? this.summary,
      dailyIncomeList: dailyIncomeList ?? this.dailyIncomeList,
      topDiagnoses: topDiagnoses ?? this.topDiagnoses,
      demographics: demographics ?? this.demographics,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

class AdminNotifier extends Notifier<AdminPanelState> {
  AppDatabase get _db => ref.read(appDatabaseProvider);
  StreamSubscription? _sub;

  @override
  AdminPanelState build() {
    ref.onDispose(() {
      _sub?.cancel();
    });
    _listenToQueue();
    Future.microtask(() => refresh());
    return const AdminPanelState(isLoading: true);
  }

  void _listenToQueue() {
    _sub?.cancel();
    _sub = _db.watchAllPatientQueueEntries().listen((entries) {
      final domainList = entries.map((e) => e.toDomain()).toList();
      _computeAndEmitState(domainList);
    });
  }

  Future<void> refresh() async {
    try {
      final entries = await _db.getPatientQueueForDateRange();
      final domainList = entries.map((e) => e.toDomain()).toList();
      _computeAndEmitState(domainList);
    } catch (_) {}
  }

  void setDateFilter(AdminDateRangeFilter filter) {
    state = state.copyWith(selectedFilter: filter);
    _computeAndEmitState(state.allPatients);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyPatientFilters();
  }

  void setStatusFilter(String status) {
    state = state.copyWith(statusFilter: status);
    _applyPatientFilters();
  }

  void _computeAndEmitState(List<PatientQueueItem> allPatients) {
    ClinicSettings settings;
    try {
      settings = ref.read(clinicSettingsProvider);
    } catch (_) {
      settings = const ClinicSettings();
    }
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    DateTime? filterStart;
    DateTime? filterEnd;

    switch (state.selectedFilter) {
      case AdminDateRangeFilter.today:
        filterStart = todayStart;
        filterEnd = todayEnd;
        break;
      case AdminDateRangeFilter.yesterday:
        final y = todayStart.subtract(const Duration(days: 1));
        filterStart = y;
        filterEnd = DateTime(y.year, y.month, y.day, 23, 59, 59);
        break;
      case AdminDateRangeFilter.last7Days:
        filterStart = todayStart.subtract(const Duration(days: 6));
        filterEnd = todayEnd;
        break;
      case AdminDateRangeFilter.thisMonth:
        filterStart = DateTime(now.year, now.month, 1);
        filterEnd = todayEnd;
        break;
      case AdminDateRangeFilter.allTime:
        filterStart = null;
        filterEnd = null;
        break;
    }

    // Filter patients based on selected date range
    final inRangePatients = allPatients.where((p) {
      if (filterStart != null && p.entryTime.isBefore(filterStart)) {
        return false;
      }
      if (filterEnd != null && p.entryTime.isAfter(filterEnd)) {
        return false;
      }
      return true;
    }).toList();

    // Today patients specifically for today revenue/patient count
    final todayPatients = allPatients.where((p) {
      return p.entryTime.isAfter(todayStart) && p.entryTime.isBefore(todayEnd);
    }).toList();

    // 1. Calculate Summary Metrics
    int completed = 0;
    int waiting = 0;
    int inConsult = 0;
    int cancelled = 0;
    int revisits = 0;
    int newCount = 0;
    double totalIncome = 0.0;
    double newIncome = 0.0;
    double revisitIncome = 0.0;
    double totalWaitMinutes = 0.0;
    int waitCount = 0;
    double totalConsultMinutes = 0.0;
    int consultCount = 0;

    int pediatric = 0;
    int adult = 0;
    int geriatric = 0;
    final diagnosisFrequency = <String, int>{};

    for (final p in inRangePatients) {
      final isRevisit = p.isRevisit;
      if (isRevisit) {
        revisits++;
      } else {
        newCount++;
      }

      // Demographic
      if (p.calculatedAge < 12) {
        pediatric++;
      } else if (p.calculatedAge >= 60) {
        geriatric++;
      } else {
        adult++;
      }

      // Status
      switch (p.queueStatus) {
        case QueueStatus.completed:
          completed++;
          break;
        case QueueStatus.waiting:
          waiting++;
          break;
        case QueueStatus.inConsultation:
          inConsult++;
          break;
        case QueueStatus.cancelled:
          cancelled++;
          break;
      }

      // Income calculation:
      // If consultationFee recorded > 0, use it.
      // If 0 and completed/visited, fallback to default fee from settings
      double fee = p.consultationFee;
      if (fee <= 0 && p.queueStatus != QueueStatus.cancelled) {
        fee = isRevisit ? settings.revisitFee : settings.consultationFee;
      }

      if (p.queueStatus != QueueStatus.cancelled) {
        totalIncome += fee;
        if (isRevisit) {
          revisitIncome += fee;
        } else {
          newIncome += fee;
        }
      }

      // Wait & Consult durations
      if (p.consultationStartTime != null) {
        final waitDur = p.consultationStartTime!.difference(p.entryTime);
        if (waitDur.inMinutes >= 0 && waitDur.inMinutes < 600) {
          totalWaitMinutes += waitDur.inMinutes;
          waitCount++;
        }
      }

      if (p.completionTime != null && p.consultationStartTime != null) {
        final consultDur =
            p.completionTime!.difference(p.consultationStartTime!);
        if (consultDur.inMinutes >= 0 && consultDur.inMinutes < 300) {
          totalConsultMinutes += consultDur.inMinutes;
          consultCount++;
        }
      }

      // Extract diagnoses from snapshot or compiled prescription if available
      if (p.compiledPrescriptionJson != null &&
          p.compiledPrescriptionJson!.isNotEmpty) {
        try {
          final decoded =
              jsonDecode(p.compiledPrescriptionJson!) as Map<String, dynamic>;
          final diagList = decoded['diagnoses'] as List?;
          if (diagList != null) {
            for (final d in diagList) {
              final name = d is Map ? (d['name'] as String?) : d.toString();
              if (name != null && name.trim().isNotEmpty) {
                diagnosisFrequency[name.trim()] =
                    (diagnosisFrequency[name.trim()] ?? 0) + 1;
              }
            }
          }
        } catch (_) {}
      }
    }

    // Today's total income calculation
    double todayIncome = 0.0;
    for (final p in todayPatients) {
      if (p.queueStatus != QueueStatus.cancelled) {
        double fee = p.consultationFee;
        if (fee <= 0) {
          fee = p.isRevisit ? settings.revisitFee : settings.consultationFee;
        }
        todayIncome += fee;
      }
    }

    final totalPts = inRangePatients.length;
    final revisitPct = totalPts > 0 ? (revisits / totalPts) * 100 : 0.0;
    final avgIncome = totalPts > 0 ? totalIncome / totalPts : 0.0;
    final avgWait = waitCount > 0 ? totalWaitMinutes / waitCount : 0.0;
    final avgConsult =
        consultCount > 0 ? totalConsultMinutes / consultCount : 0.0;

    final summary = AdminSummaryMetrics(
      totalPatients: totalPts,
      newPatients: newCount,
      revisitPatients: revisits,
      revisitPercentage: revisitPct,
      completedConsultations: completed,
      waitingPatients: waiting,
      inConsultationPatients: inConsult,
      cancelledPatients: cancelled,
      totalIncome: totalIncome,
      todayIncome: todayIncome,
      newPatientIncome: newIncome,
      revisitPatientIncome: revisitIncome,
      avgIncomePerPatient: avgIncome,
      avgWaitTimeMinutes: avgWait,
      avgConsultationMinutes: avgConsult,
    );

    // 2. Group Day-by-Day Income & Patient Count
    final dateGroups = <String, List<PatientQueueItem>>{};
    final dateFormat = DateFormat('yyyy-MM-dd');

    for (final p in inRangePatients) {
      final key = dateFormat.format(p.entryTime);
      dateGroups.putIfAbsent(key, () => []).add(p);
    }

    final dailyMetrics = <DailyIncomeMetric>[];
    final sortedDateKeys = dateGroups.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    for (final key in sortedDateKeys) {
      final list = dateGroups[key]!;
      int dNew = 0;
      int dRevisit = 0;
      int dCompleted = 0;
      double dIncome = 0.0;

      for (final item in list) {
        if (item.isRevisit) {
          dRevisit++;
        } else {
          dNew++;
        }
        if (item.queueStatus == QueueStatus.completed) {
          dCompleted++;
        }
        if (item.queueStatus != QueueStatus.cancelled) {
          double fee = item.consultationFee;
          if (fee <= 0) {
            fee = item.isRevisit
                ? settings.revisitFee
                : settings.consultationFee;
          }
          dIncome += fee;
        }
      }

      dailyMetrics.add(
        DailyIncomeMetric(
          date: DateTime.parse(key),
          totalPatients: list.length,
          newPatients: dNew,
          revisitPatients: dRevisit,
          completedPatients: dCompleted,
          totalIncome: dIncome,
        ),
      );
    }

    // 3. Top Diagnoses
    final topDiagList = <DiagnosisStatMetric>[];
    final sortedDiags = diagnosisFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final diagTotal = sortedDiags.fold<int>(0, (sum, e) => sum + e.value);

    for (final entry in sortedDiags.take(8)) {
      final pct = diagTotal > 0 ? (entry.value / diagTotal) * 100 : 0.0;
      topDiagList.add(
        DiagnosisStatMetric(
          diagnosisName: entry.key,
          count: entry.value,
          percentage: pct,
        ),
      );
    }

    // 4. Demographics
    final demographics = DemographicsMetric(
      pediatric: pediatric,
      adult: adult,
      geriatric: geriatric,
    );

    state = state.copyWith(
      isLoading: false,
      allPatients: allPatients,
      summary: summary,
      dailyIncomeList: dailyMetrics,
      topDiagnoses: topDiagList,
      demographics: demographics,
    );

    _applyPatientFilters(inRangePatients);
  }

  void _applyPatientFilters([List<PatientQueueItem>? sourceList]) {
    final base = sourceList ??
        state.allPatients.where((p) {
          switch (state.selectedFilter) {
            case AdminDateRangeFilter.today:
              final now = DateTime.now();
              return p.entryTime.year == now.year &&
                  p.entryTime.month == now.month &&
                  p.entryTime.day == now.day;
            case AdminDateRangeFilter.yesterday:
              final y = DateTime.now().subtract(const Duration(days: 1));
              return p.entryTime.year == y.year &&
                  p.entryTime.month == y.month &&
                  p.entryTime.day == y.day;
            case AdminDateRangeFilter.last7Days:
              return p.entryTime.isAfter(
                DateTime.now().subtract(const Duration(days: 7)),
              );
            case AdminDateRangeFilter.thisMonth:
              final now = DateTime.now();
              return p.entryTime.year == now.year &&
                  p.entryTime.month == now.month;
            case AdminDateRangeFilter.allTime:
              return true;
          }
        }).toList();

    var results = base;

    // Filter by Status Tab
    if (state.statusFilter == 'COMPLETED') {
      results = results
          .where((p) => p.queueStatus == QueueStatus.completed)
          .toList();
    } else if (state.statusFilter == 'WAITING') {
      results = results
          .where((p) => p.queueStatus == QueueStatus.waiting)
          .toList();
    } else if (state.statusFilter == 'REVISITS') {
      results = results.where((p) => p.isRevisit).toList();
    }

    // Search query filter
    final q = state.searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      results = results.where((p) {
        final nameMatch = p.patientName.toLowerCase().contains(q);
        final idMatch = (p.patientId ?? '').toLowerCase().contains(q);
        final phoneMatch = (p.phone ?? '').contains(q);
        final tokenMatch = p.tokenNumber.toString() == q;
        return nameMatch || idMatch || phoneMatch || tokenMatch;
      }).toList();
    }

    state = state.copyWith(filteredPatients: results);
  }
}

final adminPanelProvider =
    NotifierProvider<AdminNotifier, AdminPanelState>(AdminNotifier.new);
