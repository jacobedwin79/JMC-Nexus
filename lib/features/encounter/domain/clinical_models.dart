import 'package:freezed_annotation/freezed_annotation.dart';

part 'clinical_models.freezed.dart';
part 'clinical_models.g.dart';

@freezed
abstract class PatientVitals with _$PatientVitals {
  const PatientVitals._();

  const factory PatientVitals({
    int? bpSys,
    int? bpDia,
    int? pulse,
    int? spo2,
    double? temp,
    double? weight,
  }) = _PatientVitals;

  factory PatientVitals.fromJson(Map<String, dynamic> json) =>
      _$PatientVitalsFromJson(json);

  String get bpDisplay {
    if (bpSys != null && bpDia != null) return '$bpSys/$bpDia mmHg';
    if (bpSys != null) return '$bpSys/- mmHg';
    return 'Not recorded';
  }

  String get pulseDisplay => pulse != null ? '$pulse bpm' : '--';
  String get spo2Display => spo2 != null ? '$spo2%' : '--';
  String get tempDisplay => temp != null ? '$temp°F' : '--';
  String get weightDisplay => weight != null ? '$weight kg' : '--';

  bool get hasAnyVitals =>
      bpSys != null ||
      bpDia != null ||
      pulse != null ||
      spo2 != null ||
      temp != null ||
      weight != null;

  bool get isHypotensive => (bpSys != null && bpSys! < 90) || (bpDia != null && bpDia! < 60);
  bool get isHypertensive => (bpSys != null && bpSys! >= 140) || (bpDia != null && bpDia! >= 90);
  bool get isTachycardic => pulse != null && pulse! > 100;
  bool get isHypoxemic => spo2 != null && spo2! < 95;
  bool get isFebrile => temp != null && temp! >= 99.5;
}

@freezed
abstract class ComorbidityModel with _$ComorbidityModel {
  const factory ComorbidityModel({
    required String id,
    required String name,
    @Default([]) List<String> contraindicatedDrugClasses,
  }) = _ComorbidityModel;

  factory ComorbidityModel.fromJson(Map<String, dynamic> json) =>
      _$ComorbidityModelFromJson(json);
}

@freezed
abstract class ComplaintSubQuestionModel with _$ComplaintSubQuestionModel {
  const factory ComplaintSubQuestionModel({
    required String id,
    required String complaintId,
    required String questionLabel,
    @Default([]) List<String> options,
    @Default('') String sentenceTemplate,
    @Default(false) bool isMultiSelect,
    @Default(0) int sequenceOrder,
  }) = _ComplaintSubQuestionModel;

  factory ComplaintSubQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintSubQuestionModelFromJson(json);
}

@freezed
abstract class PresentingComplaintModel with _$PresentingComplaintModel {
  const factory PresentingComplaintModel({
    required String id,
    required String name,
    required String category,
    @Default(0) int displayOrder,
    @Default([]) List<ComplaintSubQuestionModel> subQuestions,
  }) = _PresentingComplaintModel;

  factory PresentingComplaintModel.fromJson(Map<String, dynamic> json) =>
      _$PresentingComplaintModelFromJson(json);
}

@freezed
abstract class SelectedComplaintState with _$SelectedComplaintState {
  const factory SelectedComplaintState({
    required String complaintId,
    required String complaintName,
    @Default({}) Map<String, List<String>> selectedOptions, // subQuestionId -> options
    @Default('') String compiledProse,
  }) = _SelectedComplaintState;

  factory SelectedComplaintState.fromJson(Map<String, dynamic> json) =>
      _$SelectedComplaintStateFromJson(json);
}

@freezed
abstract class ExamSystemModel with _$ExamSystemModel {
  const factory ExamSystemModel({
    required String id,
    required String systemName,
    required String defaultNormalText,
    @Default([]) List<String> abnormalFindings,
  }) = _ExamSystemModel;

  factory ExamSystemModel.fromJson(Map<String, dynamic> json) =>
      _$ExamSystemModelFromJson(json);
}

@freezed
abstract class ExamSystemState with _$ExamSystemState {
  const factory ExamSystemState({
    required String systemId,
    required String systemName,
    @Default(true) bool isNormal,
    @Default([]) List<String> selectedAbnormals,
    String? customNotes,
    @Default('') String compiledText,
  }) = _ExamSystemState;

  factory ExamSystemState.fromJson(Map<String, dynamic> json) =>
      _$ExamSystemStateFromJson(json);
}

@freezed
abstract class DiagnosisModel with _$DiagnosisModel {
  const factory DiagnosisModel({
    required String id,
    required String name,
    String? icd10Code,
    @Default([]) List<String> linkedComplaintIds,
  }) = _DiagnosisModel;

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) =>
      _$DiagnosisModelFromJson(json);
}

@freezed
abstract class DrugModel with _$DrugModel {
  const factory DrugModel({
    required String id,
    required String genericName,
    required String brandName,
    required String drugClass,
    required String defaultDose,
    required String defaultRoute,
    required String defaultFrequency,
    required String defaultDuration,
    required String defaultInstructions,
  }) = _DrugModel;

  factory DrugModel.fromJson(Map<String, dynamic> json) =>
      _$DrugModelFromJson(json);
}

@freezed
abstract class PrescriptionItemModel with _$PrescriptionItemModel {
  const factory PrescriptionItemModel({
    required String drugId,
    required String genericName,
    required String brandName,
    required String drugClass,
    required String dose,
    required String route,
    required String frequency,
    required String duration,
    required String instructions,
    @Default(false) bool isCustom,
  }) = _PrescriptionItemModel;

  factory PrescriptionItemModel.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionItemModelFromJson(json);
}

@freezed
abstract class ProtocolItemEntry with _$ProtocolItemEntry {
  const factory ProtocolItemEntry({
    required String drugId,
    String? doseOverride,
    String? frequencyOverride,
    String? durationOverride,
    String? instructionsOverride,
  }) = _ProtocolItemEntry;

  factory ProtocolItemEntry.fromJson(Map<String, dynamic> json) =>
      _$ProtocolItemEntryFromJson(json);
}

@freezed
abstract class PrescriptionProtocolModel with _$PrescriptionProtocolModel {
  const factory PrescriptionProtocolModel({
    required String id,
    required String diagnosisId,
    @Default([]) List<ProtocolItemEntry> protocolItems,
    @Default('') String generalAdvice,
  }) = _PrescriptionProtocolModel;

  factory PrescriptionProtocolModel.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionProtocolModelFromJson(json);
}

enum AlertSeverity {
  warning,
  critical,
}

@freezed
abstract class SafetyAlert with _$SafetyAlert {
  const factory SafetyAlert({
    required String drugName,
    required String drugClass,
    required String comorbidityName,
    required String message,
    @Default(AlertSeverity.critical) AlertSeverity severity,
  }) = _SafetyAlert;

  factory SafetyAlert.fromJson(Map<String, dynamic> json) =>
      _$SafetyAlertFromJson(json);
}
