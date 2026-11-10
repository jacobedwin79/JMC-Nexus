import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_mappers.dart';
import '../../../core/database/database_provider.dart';
import '../domain/patient_queue_item.dart';

class QueueMonitorState {
  final List<PatientQueueItem> allPatients;
  final bool isLoading;
  final DateTime lastTickedAt;

  const QueueMonitorState({
    this.allPatients = const [],
    this.isLoading = true,
    required this.lastTickedAt,
  });

  List<PatientQueueItem> get waitingPatients =>
      allPatients.where((p) => p.queueStatus == QueueStatus.waiting).toList();

  List<PatientQueueItem> get inConsultationPatients => allPatients
      .where((p) => p.queueStatus == QueueStatus.inConsultation)
      .toList();

  List<PatientQueueItem> get completedPatients =>
      allPatients.where((p) => p.queueStatus == QueueStatus.completed).toList();

  List<PatientQueueItem> get overduePatients =>
      waitingPatients.where((p) => p.isOverdue(lastTickedAt)).toList();

  List<PatientQueueItem> get warningPatients =>
      waitingPatients.where((p) => p.isWarning(lastTickedAt)).toList();

  bool get hasOverdue => overduePatients.isNotEmpty;
  int get overdueCount => overduePatients.length;

  String? get overdueBannerText {
    if (overduePatients.isEmpty) return null;
    final tokenList = overduePatients
        .map((p) => '#${p.tokenNumber}')
        .join(', ');
    final count = overduePatients.length;
    return '⚠️ $count ${count == 1 ? "Patient" : "Patients"} waiting > 45 mins (Tokens $tokenList)';
  }

  QueueMonitorState copyWith({
    List<PatientQueueItem>? allPatients,
    bool? isLoading,
    DateTime? lastTickedAt,
  }) {
    return QueueMonitorState(
      allPatients: allPatients ?? this.allPatients,
      isLoading: isLoading ?? this.isLoading,
      lastTickedAt: lastTickedAt ?? this.lastTickedAt,
    );
  }
}

class QueueMonitorNotifier extends Notifier<QueueMonitorState> {
  StreamSubscription<List<PatientQueueEntry>>? _queueSub;
  Timer? _tickerTimer;

  AppDatabase get _db => ref.read(appDatabaseProvider);

  @override
  QueueMonitorState build() {
    ref.onDispose(() {
      cancelTimers();
    });

    _init();

    return QueueMonitorState(lastTickedAt: DateTime.now());
  }

  void cancelTimers() {
    _queueSub?.cancel();
    _queueSub = null;
    _tickerTimer?.cancel();
    _tickerTimer = null;
  }

  void _init() {
    _queueSub = _db.watchAllQueueForToday().listen((entries) {
      final items = entries.map((e) => e.toDomain()).toList();
      state = state.copyWith(
        allPatients: items,
        isLoading: false,
        lastTickedAt: DateTime.now(),
      );
    });

    // Recalculate wait times every 15 seconds
    _tickerTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      state = state.copyWith(lastTickedAt: DateTime.now());
    });
  }

  Future<void> updateStatus({
    required String patientId,
    required QueueStatus newStatus,
    DateTime? consultationStartTime,
    DateTime? completionTime,
    String? compiledPrescriptionJson,
  }) async {
    await _db.updatePatientQueueStatus(
      id: patientId,
      status: newStatus.dbValue,
      consultationStartTime: consultationStartTime,
      completionTime: completionTime,
      compiledPrescriptionJson: compiledPrescriptionJson,
    );
  }
}

final queueMonitorProvider =
    NotifierProvider<QueueMonitorNotifier, QueueMonitorState>(
      QueueMonitorNotifier.new,
    );
