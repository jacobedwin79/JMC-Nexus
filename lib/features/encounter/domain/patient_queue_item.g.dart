// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_queue_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientQueueItem _$PatientQueueItemFromJson(Map<String, dynamic> json) =>
    _PatientQueueItem(
      id: json['id'] as String,
      tokenNumber: (json['tokenNumber'] as num).toInt(),
      patientName: json['patientName'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      phone: json['phone'] as String?,
      vitals: json['vitals'] as Map<String, dynamic>? ?? const {},
      initialComorbIds:
          (json['initialComorbIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: json['status'] as String? ?? 'WAITING',
      entryTime: DateTime.parse(json['entryTime'] as String),
      consultationStartTime: json['consultationStartTime'] == null
          ? null
          : DateTime.parse(json['consultationStartTime'] as String),
      completionTime: json['completionTime'] == null
          ? null
          : DateTime.parse(json['completionTime'] as String),
      compiledPrescriptionJson: json['compiledPrescriptionJson'] as String?,
    );

Map<String, dynamic> _$PatientQueueItemToJson(
  _PatientQueueItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'tokenNumber': instance.tokenNumber,
  'patientName': instance.patientName,
  'age': instance.age,
  'gender': instance.gender,
  'phone': instance.phone,
  'vitals': instance.vitals,
  'initialComorbIds': instance.initialComorbIds,
  'status': instance.status,
  'entryTime': instance.entryTime.toIso8601String(),
  'consultationStartTime': instance.consultationStartTime?.toIso8601String(),
  'completionTime': instance.completionTime?.toIso8601String(),
  'compiledPrescriptionJson': instance.compiledPrescriptionJson,
};
