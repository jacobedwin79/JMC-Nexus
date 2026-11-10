// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_queue_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientQueueItem _$PatientQueueItemFromJson(Map<String, dynamic> json) =>
    _PatientQueueItem(
      id: json['id'] as String,
      patientId: json['patientId'] as String?,
      tokenNumber: (json['tokenNumber'] as num).toInt(),
      patientName: json['patientName'] as String,
      age: (json['age'] as num).toInt(),
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      phone: json['phone'] as String?,
      vitals: json['vitals'] as Map<String, dynamic>? ?? const {},
      initialComorbIds:
          (json['initialComorbIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allergies:
          (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lmp: json['lmp'] as String?,
      isPregnant: json['isPregnant'] as bool? ?? false,
      status: json['status'] as String? ?? 'WAITING',
      entryTime: DateTime.parse(json['entryTime'] as String),
      consultationStartTime: json['consultationStartTime'] == null
          ? null
          : DateTime.parse(json['consultationStartTime'] as String),
      completionTime: json['completionTime'] == null
          ? null
          : DateTime.parse(json['completionTime'] as String),
      compiledPrescriptionJson: json['compiledPrescriptionJson'] as String?,
      overrideReason: json['overrideReason'] as String?,
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0.0,
      isRevisit: json['isRevisit'] as bool? ?? false,
    );

Map<String, dynamic> _$PatientQueueItemToJson(
  _PatientQueueItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'patientId': instance.patientId,
  'tokenNumber': instance.tokenNumber,
  'patientName': instance.patientName,
  'age': instance.age,
  'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
  'gender': instance.gender,
  'phone': instance.phone,
  'vitals': instance.vitals,
  'initialComorbIds': instance.initialComorbIds,
  'allergies': instance.allergies,
  'lmp': instance.lmp,
  'isPregnant': instance.isPregnant,
  'status': instance.status,
  'entryTime': instance.entryTime.toIso8601String(),
  'consultationStartTime': instance.consultationStartTime?.toIso8601String(),
  'completionTime': instance.completionTime?.toIso8601String(),
  'compiledPrescriptionJson': instance.compiledPrescriptionJson,
  'overrideReason': instance.overrideReason,
  'consultationFee': instance.consultationFee,
  'isRevisit': instance.isRevisit,
};
