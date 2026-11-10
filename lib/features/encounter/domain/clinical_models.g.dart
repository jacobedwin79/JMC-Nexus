// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinical_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientVitals _$PatientVitalsFromJson(Map<String, dynamic> json) =>
    _PatientVitals(
      bpSys: (json['bpSys'] as num?)?.toInt(),
      bpDia: (json['bpDia'] as num?)?.toInt(),
      pulse: (json['pulse'] as num?)?.toInt(),
      spo2: (json['spo2'] as num?)?.toInt(),
      temp: (json['temp'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PatientVitalsToJson(_PatientVitals instance) =>
    <String, dynamic>{
      'bpSys': instance.bpSys,
      'bpDia': instance.bpDia,
      'pulse': instance.pulse,
      'spo2': instance.spo2,
      'temp': instance.temp,
      'weight': instance.weight,
    };

_ComorbidityModel _$ComorbidityModelFromJson(Map<String, dynamic> json) =>
    _ComorbidityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      contraindicatedDrugClasses:
          (json['contraindicatedDrugClasses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ComorbidityModelToJson(_ComorbidityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contraindicatedDrugClasses': instance.contraindicatedDrugClasses,
    };

_ComplaintSubQuestionModel _$ComplaintSubQuestionModelFromJson(
  Map<String, dynamic> json,
) => _ComplaintSubQuestionModel(
  id: json['id'] as String,
  complaintId: json['complaintId'] as String,
  questionLabel: json['questionLabel'] as String,
  options:
      (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  sentenceTemplate: json['sentenceTemplate'] as String? ?? '',
  isMultiSelect: json['isMultiSelect'] as bool? ?? false,
  sequenceOrder: (json['sequenceOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ComplaintSubQuestionModelToJson(
  _ComplaintSubQuestionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'complaintId': instance.complaintId,
  'questionLabel': instance.questionLabel,
  'options': instance.options,
  'sentenceTemplate': instance.sentenceTemplate,
  'isMultiSelect': instance.isMultiSelect,
  'sequenceOrder': instance.sequenceOrder,
};

_PresentingComplaintModel _$PresentingComplaintModelFromJson(
  Map<String, dynamic> json,
) => _PresentingComplaintModel(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
  subQuestions:
      (json['subQuestions'] as List<dynamic>?)
          ?.map(
            (e) =>
                ComplaintSubQuestionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$PresentingComplaintModelToJson(
  _PresentingComplaintModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'displayOrder': instance.displayOrder,
  'subQuestions': instance.subQuestions,
};

_SelectedComplaintState _$SelectedComplaintStateFromJson(
  Map<String, dynamic> json,
) => _SelectedComplaintState(
  complaintId: json['complaintId'] as String,
  complaintName: json['complaintName'] as String,
  selectedOptions:
      (json['selectedOptions'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ) ??
      const {},
  compiledProse: json['compiledProse'] as String? ?? '',
);

Map<String, dynamic> _$SelectedComplaintStateToJson(
  _SelectedComplaintState instance,
) => <String, dynamic>{
  'complaintId': instance.complaintId,
  'complaintName': instance.complaintName,
  'selectedOptions': instance.selectedOptions,
  'compiledProse': instance.compiledProse,
};

_ExamSystemModel _$ExamSystemModelFromJson(Map<String, dynamic> json) =>
    _ExamSystemModel(
      id: json['id'] as String,
      systemName: json['systemName'] as String,
      defaultNormalText: json['defaultNormalText'] as String,
      abnormalFindings:
          (json['abnormalFindings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ExamSystemModelToJson(_ExamSystemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'systemName': instance.systemName,
      'defaultNormalText': instance.defaultNormalText,
      'abnormalFindings': instance.abnormalFindings,
    };

_ExamSystemState _$ExamSystemStateFromJson(Map<String, dynamic> json) =>
    _ExamSystemState(
      systemId: json['systemId'] as String,
      systemName: json['systemName'] as String,
      isNormal: json['isNormal'] as bool? ?? true,
      selectedAbnormals:
          (json['selectedAbnormals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      customNotes: json['customNotes'] as String?,
      compiledText: json['compiledText'] as String? ?? '',
    );

Map<String, dynamic> _$ExamSystemStateToJson(_ExamSystemState instance) =>
    <String, dynamic>{
      'systemId': instance.systemId,
      'systemName': instance.systemName,
      'isNormal': instance.isNormal,
      'selectedAbnormals': instance.selectedAbnormals,
      'customNotes': instance.customNotes,
      'compiledText': instance.compiledText,
    };

_DiagnosisModel _$DiagnosisModelFromJson(Map<String, dynamic> json) =>
    _DiagnosisModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icd10Code: json['icd10Code'] as String?,
      linkedComplaintIds:
          (json['linkedComplaintIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DiagnosisModelToJson(_DiagnosisModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icd10Code': instance.icd10Code,
      'linkedComplaintIds': instance.linkedComplaintIds,
    };

_DrugModel _$DrugModelFromJson(Map<String, dynamic> json) => _DrugModel(
  id: json['id'] as String,
  genericName: json['genericName'] as String,
  brandName: json['brandName'] as String,
  drugClass: json['drugClass'] as String,
  defaultDose: json['defaultDose'] as String,
  defaultRoute: json['defaultRoute'] as String,
  defaultFrequency: json['defaultFrequency'] as String,
  defaultDuration: json['defaultDuration'] as String,
  defaultInstructions: json['defaultInstructions'] as String,
);

Map<String, dynamic> _$DrugModelToJson(_DrugModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'genericName': instance.genericName,
      'brandName': instance.brandName,
      'drugClass': instance.drugClass,
      'defaultDose': instance.defaultDose,
      'defaultRoute': instance.defaultRoute,
      'defaultFrequency': instance.defaultFrequency,
      'defaultDuration': instance.defaultDuration,
      'defaultInstructions': instance.defaultInstructions,
    };

_PrescriptionItemModel _$PrescriptionItemModelFromJson(
  Map<String, dynamic> json,
) => _PrescriptionItemModel(
  drugId: json['drugId'] as String,
  genericName: json['genericName'] as String,
  brandName: json['brandName'] as String,
  drugClass: json['drugClass'] as String,
  dose: json['dose'] as String,
  route: json['route'] as String,
  frequency: json['frequency'] as String,
  duration: json['duration'] as String,
  instructions: json['instructions'] as String,
  isCustom: json['isCustom'] as bool? ?? false,
);

Map<String, dynamic> _$PrescriptionItemModelToJson(
  _PrescriptionItemModel instance,
) => <String, dynamic>{
  'drugId': instance.drugId,
  'genericName': instance.genericName,
  'brandName': instance.brandName,
  'drugClass': instance.drugClass,
  'dose': instance.dose,
  'route': instance.route,
  'frequency': instance.frequency,
  'duration': instance.duration,
  'instructions': instance.instructions,
  'isCustom': instance.isCustom,
};

_ProtocolItemEntry _$ProtocolItemEntryFromJson(Map<String, dynamic> json) =>
    _ProtocolItemEntry(
      drugId: json['drugId'] as String,
      doseOverride: json['doseOverride'] as String?,
      frequencyOverride: json['frequencyOverride'] as String?,
      durationOverride: json['durationOverride'] as String?,
      instructionsOverride: json['instructionsOverride'] as String?,
    );

Map<String, dynamic> _$ProtocolItemEntryToJson(_ProtocolItemEntry instance) =>
    <String, dynamic>{
      'drugId': instance.drugId,
      'doseOverride': instance.doseOverride,
      'frequencyOverride': instance.frequencyOverride,
      'durationOverride': instance.durationOverride,
      'instructionsOverride': instance.instructionsOverride,
    };

_PrescriptionProtocolModel _$PrescriptionProtocolModelFromJson(
  Map<String, dynamic> json,
) => _PrescriptionProtocolModel(
  id: json['id'] as String,
  diagnosisId: json['diagnosisId'] as String,
  protocolItems:
      (json['protocolItems'] as List<dynamic>?)
          ?.map((e) => ProtocolItemEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  generalAdvice: json['generalAdvice'] as String? ?? '',
);

Map<String, dynamic> _$PrescriptionProtocolModelToJson(
  _PrescriptionProtocolModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'diagnosisId': instance.diagnosisId,
  'protocolItems': instance.protocolItems,
  'generalAdvice': instance.generalAdvice,
};

_SafetyAlert _$SafetyAlertFromJson(Map<String, dynamic> json) => _SafetyAlert(
  drugName: json['drugName'] as String,
  drugClass: json['drugClass'] as String,
  comorbidityName: json['comorbidityName'] as String,
  message: json['message'] as String,
  severity:
      $enumDecodeNullable(_$AlertSeverityEnumMap, json['severity']) ??
      AlertSeverity.critical,
);

Map<String, dynamic> _$SafetyAlertToJson(_SafetyAlert instance) =>
    <String, dynamic>{
      'drugName': instance.drugName,
      'drugClass': instance.drugClass,
      'comorbidityName': instance.comorbidityName,
      'message': instance.message,
      'severity': _$AlertSeverityEnumMap[instance.severity]!,
    };

const _$AlertSeverityEnumMap = {
  AlertSeverity.warning: 'warning',
  AlertSeverity.critical: 'critical',
};
