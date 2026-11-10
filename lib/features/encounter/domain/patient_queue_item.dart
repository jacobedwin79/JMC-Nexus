import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/sync/server_time_service.dart';
import '../../../core/utils/age_calculator.dart';

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
    String? patientId,
    required int tokenNumber,
    required String patientName,
    required int age,
    DateTime? dateOfBirth,
    required String gender,
    String? phone,
    @Default({}) Map<String, dynamic> vitals,
    @Default([]) List<String> initialComorbIds,
    @Default([]) List<String> allergies,
    String? lmp,
    @Default(false) bool isPregnant,
    @Default('WAITING') String status,
    required DateTime entryTime,
    DateTime? consultationStartTime,
    DateTime? completionTime,
    String? compiledPrescriptionJson,
    String? overrideReason,
  }) = _PatientQueueItem;

  factory PatientQueueItem.fromJson(Map<String, dynamic> json) =>
      _$PatientQueueItemFromJson(json);

  QueueStatus get queueStatus => QueueStatus.fromDb(status);

  /// Dynamically formatted age string:
  /// - Days for neonates (< 30 days)
  /// - Weeks/Months for infants (< 1 year)
  /// - Years for older children and adults
  String get dynamicAgeDisplay {
    if (dateOfBirth != null) {
      return AgeCalculator.formatAge(dateOfBirth!);
    }
    return '$age ${age == 1 ? "year" : "years"}';
  }

  /// Compact age tag (e.g. "12d", "5m", "42y")
  String get compactAgeDisplay {
    if (dateOfBirth != null) {
      return AgeCalculator.formatAgeCompact(dateOfBirth!);
    }
    return '${age}y';
  }

  /// Numeric age in years for clinical thresholds & stratification
  int get calculatedAge {
    if (dateOfBirth != null) {
      return AgeCalculator.calculateYears(dateOfBirth!);
    }
    return age;
  }

  /// SLA Wait time calculation synchronized via ServerTimeService to prevent terminal clock skewing
  int waitMinutes([DateTime? referenceTime]) {
    final now = referenceTime ?? ServerTimeService.now;
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
