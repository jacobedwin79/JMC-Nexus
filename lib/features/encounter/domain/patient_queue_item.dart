import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_queue_item.freezed.dart';
part 'patient_queue_item.g.dart';

enum QueueStatus {
  @JsonValue('WAITING')
  waiting,
  @JsonValue('IN_CONSULTATION')
  inConsultation,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled;

  String get dbValue {
    switch (this) {
      case QueueStatus.waiting:
        return 'WAITING';
      case QueueStatus.inConsultation:
        return 'IN_CONSULTATION';
      case QueueStatus.completed:
        return 'COMPLETED';
      case QueueStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static QueueStatus fromDb(String value) {
    switch (value.toUpperCase()) {
      case 'IN_CONSULTATION':
        return QueueStatus.inConsultation;
      case 'COMPLETED':
        return QueueStatus.completed;
      case 'CANCELLED':
        return QueueStatus.cancelled;
      case 'WAITING':
      default:
        return QueueStatus.waiting;
    }
  }
}

@freezed
abstract class PatientQueueItem with _$PatientQueueItem {
  const PatientQueueItem._();

  const factory PatientQueueItem({
    required String id,
    required int tokenNumber,
    required String patientName,
    required int age,
    required String gender,
    String? phone,
    @Default({}) Map<String, dynamic> vitals,
    @Default([]) List<String> initialComorbIds,
    @Default('WAITING') String status,
    required DateTime entryTime,
    DateTime? consultationStartTime,
    DateTime? completionTime,
    String? compiledPrescriptionJson,
  }) = _PatientQueueItem;

  factory PatientQueueItem.fromJson(Map<String, dynamic> json) =>
      _$PatientQueueItemFromJson(json);

  QueueStatus get queueStatus => QueueStatus.fromDb(status);

  int waitMinutes([DateTime? referenceTime]) {
    final now = referenceTime ?? DateTime.now();
    final diff = now.difference(entryTime.toLocal()).inMinutes;
    return diff < 0 ? 0 : diff;
  }

  bool isOverdue([DateTime? referenceTime]) => waitMinutes(referenceTime) >= 45;
  bool isWarning([DateTime? referenceTime]) {
    final mins = waitMinutes(referenceTime);
    return mins >= 30 && mins < 45;
  }
  bool isNormal([DateTime? referenceTime]) => waitMinutes(referenceTime) < 30;

  String get waitTimeDisplay {
    final mins = waitMinutes();
    if (mins < 60) return '${mins}m';
    final hrs = mins ~/ 60;
    final remMins = mins % 60;
    return '${hrs}h ${remMins}m';
  }
}
