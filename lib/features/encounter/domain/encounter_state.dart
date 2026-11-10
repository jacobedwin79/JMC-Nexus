import 'package:freezed_annotation/freezed_annotation.dart';
import 'patient_queue_item.dart';
import 'clinical_models.dart';

part 'encounter_state.freezed.dart';
part 'encounter_state.g.dart';

@freezed
abstract class EncounterState with _$EncounterState {
  const EncounterState._();

  const factory EncounterState({
    PatientQueueItem? activePatient,
    @Default([]) List<String> selectedComorbidityIds,
    @Default({}) Map<String, SelectedComplaintState> selectedComplaints,
    @Default({}) Map<String, ExamSystemState> examStates,
    @Default([]) List<String> selectedDiagnosisIds,
    @Default([]) List<PrescriptionItemModel> activePrescription,
    @Default('') String generalAdvice,
    int? followUpDays,
    @Default([]) List<SafetyAlert> safetyAlerts,
    @Default(false) bool isLetterheadMode,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _EncounterState;

  factory EncounterState.fromJson(Map<String, dynamic> json) =>
      _$EncounterStateFromJson(json);

  bool get hasActivePatient => activePatient != null;
  bool get hasCriticalSafetyAlert =>
      safetyAlerts.any((alert) => alert.severity == AlertSeverity.critical);

  String get compiledComplaintsSummary {
    if (selectedComplaints.isEmpty) return 'No active complaints';
    return selectedComplaints.values
        .map((e) => e.compiledProse.isNotEmpty ? e.compiledProse : e.complaintName)
        .join('; ');
  }

  String get compiledExamSummary {
    if (examStates.isEmpty) return 'Systemic examination normal';
    return examStates.values
        .map((e) => '${e.systemName}: ${e.compiledText.isNotEmpty ? e.compiledText : (e.isNormal ? "Normal" : "Abnormal")}')
        .join(' | ');
  }
}
