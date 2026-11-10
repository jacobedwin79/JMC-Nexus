// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encounter_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EncounterState _$EncounterStateFromJson(
  Map<String, dynamic> json,
) => _EncounterState(
  activePatient: json['activePatient'] == null
      ? null
      : PatientQueueItem.fromJson(
          json['activePatient'] as Map<String, dynamic>,
        ),
  selectedComorbidityIds:
      (json['selectedComorbidityIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  allergies:
      (json['allergies'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  lmp: json['lmp'] as String?,
  isPregnant: json['isPregnant'] as bool? ?? false,
  selectedComplaints:
      (json['selectedComplaints'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          SelectedComplaintState.fromJson(e as Map<String, dynamic>),
        ),
      ) ??
      const {},
  examStates:
      (json['examStates'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, ExamSystemState.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  selectedDiagnosisIds:
      (json['selectedDiagnosisIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  activePrescription:
      (json['activePrescription'] as List<dynamic>?)
          ?.map(
            (e) => PrescriptionItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  generalAdvice: json['generalAdvice'] as String? ?? '',
  followUpDays: (json['followUpDays'] as num?)?.toInt(),
  safetyAlerts:
      (json['safetyAlerts'] as List<dynamic>?)
          ?.map((e) => SafetyAlert.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isLetterheadMode: json['isLetterheadMode'] as bool? ?? false,
  isLoading: json['isLoading'] as bool? ?? false,
  lastDraftSavedAt: json['lastDraftSavedAt'] == null
      ? null
      : DateTime.parse(json['lastDraftSavedAt'] as String),
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$EncounterStateToJson(_EncounterState instance) =>
    <String, dynamic>{
      'activePatient': instance.activePatient,
      'selectedComorbidityIds': instance.selectedComorbidityIds,
      'allergies': instance.allergies,
      'lmp': instance.lmp,
      'isPregnant': instance.isPregnant,
      'selectedComplaints': instance.selectedComplaints,
      'examStates': instance.examStates,
      'selectedDiagnosisIds': instance.selectedDiagnosisIds,
      'activePrescription': instance.activePrescription,
      'generalAdvice': instance.generalAdvice,
      'followUpDays': instance.followUpDays,
      'safetyAlerts': instance.safetyAlerts,
      'isLetterheadMode': instance.isLetterheadMode,
      'isLoading': instance.isLoading,
      'lastDraftSavedAt': instance.lastDraftSavedAt?.toIso8601String(),
      'errorMessage': instance.errorMessage,
    };
