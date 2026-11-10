// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PatientQueueTableTable extends PatientQueueTable
    with TableInfo<$PatientQueueTableTable, PatientQueueEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tokenNumberMeta = const VerificationMeta(
    'tokenNumber',
  );
  @override
  late final GeneratedColumn<int> tokenNumber = GeneratedColumn<int>(
    'token_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientNameMeta = const VerificationMeta(
    'patientName',
  );
  @override
  late final GeneratedColumn<String> patientName = GeneratedColumn<String>(
    'patient_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vitalsJsonMeta = const VerificationMeta(
    'vitalsJson',
  );
  @override
  late final GeneratedColumn<String> vitalsJson = GeneratedColumn<String>(
    'vitals_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialComorbIdsMeta = const VerificationMeta(
    'initialComorbIds',
  );
  @override
  late final GeneratedColumn<String> initialComorbIds = GeneratedColumn<String>(
    'initial_comorb_ids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lmpMeta = const VerificationMeta('lmp');
  @override
  late final GeneratedColumn<String> lmp = GeneratedColumn<String>(
    'lmp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPregnantMeta = const VerificationMeta(
    'isPregnant',
  );
  @override
  late final GeneratedColumn<bool> isPregnant = GeneratedColumn<bool>(
    'is_pregnant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pregnant" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryTimeMeta = const VerificationMeta(
    'entryTime',
  );
  @override
  late final GeneratedColumn<DateTime> entryTime = GeneratedColumn<DateTime>(
    'entry_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consultationStartTimeMeta =
      const VerificationMeta('consultationStartTime');
  @override
  late final GeneratedColumn<DateTime> consultationStartTime =
      GeneratedColumn<DateTime>(
        'consultation_start_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completionTimeMeta = const VerificationMeta(
    'completionTime',
  );
  @override
  late final GeneratedColumn<DateTime> completionTime =
      GeneratedColumn<DateTime>(
        'completion_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _compiledPrescriptionJsonMeta =
      const VerificationMeta('compiledPrescriptionJson');
  @override
  late final GeneratedColumn<String> compiledPrescriptionJson =
      GeneratedColumn<String>(
        'compiled_prescription_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    tokenNumber,
    patientName,
    age,
    gender,
    phone,
    vitalsJson,
    initialComorbIds,
    allergies,
    lmp,
    isPregnant,
    status,
    entryTime,
    consultationStartTime,
    completionTime,
    compiledPrescriptionJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patient_queue_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatientQueueEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    }
    if (data.containsKey('token_number')) {
      context.handle(
        _tokenNumberMeta,
        tokenNumber.isAcceptableOrUnknown(
          data['token_number']!,
          _tokenNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tokenNumberMeta);
    }
    if (data.containsKey('patient_name')) {
      context.handle(
        _patientNameMeta,
        patientName.isAcceptableOrUnknown(
          data['patient_name']!,
          _patientNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patientNameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('vitals_json')) {
      context.handle(
        _vitalsJsonMeta,
        vitalsJson.isAcceptableOrUnknown(data['vitals_json']!, _vitalsJsonMeta),
      );
    }
    if (data.containsKey('initial_comorb_ids')) {
      context.handle(
        _initialComorbIdsMeta,
        initialComorbIds.isAcceptableOrUnknown(
          data['initial_comorb_ids']!,
          _initialComorbIdsMeta,
        ),
      );
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    }
    if (data.containsKey('lmp')) {
      context.handle(
        _lmpMeta,
        lmp.isAcceptableOrUnknown(data['lmp']!, _lmpMeta),
      );
    }
    if (data.containsKey('is_pregnant')) {
      context.handle(
        _isPregnantMeta,
        isPregnant.isAcceptableOrUnknown(data['is_pregnant']!, _isPregnantMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('entry_time')) {
      context.handle(
        _entryTimeMeta,
        entryTime.isAcceptableOrUnknown(data['entry_time']!, _entryTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_entryTimeMeta);
    }
    if (data.containsKey('consultation_start_time')) {
      context.handle(
        _consultationStartTimeMeta,
        consultationStartTime.isAcceptableOrUnknown(
          data['consultation_start_time']!,
          _consultationStartTimeMeta,
        ),
      );
    }
    if (data.containsKey('completion_time')) {
      context.handle(
        _completionTimeMeta,
        completionTime.isAcceptableOrUnknown(
          data['completion_time']!,
          _completionTimeMeta,
        ),
      );
    }
    if (data.containsKey('compiled_prescription_json')) {
      context.handle(
        _compiledPrescriptionJsonMeta,
        compiledPrescriptionJson.isAcceptableOrUnknown(
          data['compiled_prescription_json']!,
          _compiledPrescriptionJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatientQueueEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientQueueEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      ),
      tokenNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}token_number'],
      )!,
      patientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      vitalsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vitals_json'],
      ),
      initialComorbIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initial_comorb_ids'],
      ),
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      ),
      lmp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lmp'],
      ),
      isPregnant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pregnant'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      entryTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_time'],
      )!,
      consultationStartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}consultation_start_time'],
      ),
      completionTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completion_time'],
      ),
      compiledPrescriptionJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}compiled_prescription_json'],
      ),
    );
  }

  @override
  $PatientQueueTableTable createAlias(String alias) {
    return $PatientQueueTableTable(attachedDatabase, alias);
  }
}

class PatientQueueEntry extends DataClass
    implements Insertable<PatientQueueEntry> {
  final String id;

  /// Persistent patient identifier (UHID / MRN) reused across visits.
  final String? patientId;
  final int tokenNumber;
  final String patientName;
  final int age;
  final String gender;
  final String? phone;
  final String? vitalsJson;
  final String? initialComorbIds;
  final String? allergies;
  final String? lmp;
  final bool isPregnant;
  final String status;
  final DateTime entryTime;
  final DateTime? consultationStartTime;
  final DateTime? completionTime;
  final String? compiledPrescriptionJson;
  const PatientQueueEntry({
    required this.id,
    this.patientId,
    required this.tokenNumber,
    required this.patientName,
    required this.age,
    required this.gender,
    this.phone,
    this.vitalsJson,
    this.initialComorbIds,
    this.allergies,
    this.lmp,
    required this.isPregnant,
    required this.status,
    required this.entryTime,
    this.consultationStartTime,
    this.completionTime,
    this.compiledPrescriptionJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || patientId != null) {
      map['patient_id'] = Variable<String>(patientId);
    }
    map['token_number'] = Variable<int>(tokenNumber);
    map['patient_name'] = Variable<String>(patientName);
    map['age'] = Variable<int>(age);
    map['gender'] = Variable<String>(gender);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || vitalsJson != null) {
      map['vitals_json'] = Variable<String>(vitalsJson);
    }
    if (!nullToAbsent || initialComorbIds != null) {
      map['initial_comorb_ids'] = Variable<String>(initialComorbIds);
    }
    if (!nullToAbsent || allergies != null) {
      map['allergies'] = Variable<String>(allergies);
    }
    if (!nullToAbsent || lmp != null) {
      map['lmp'] = Variable<String>(lmp);
    }
    map['is_pregnant'] = Variable<bool>(isPregnant);
    map['status'] = Variable<String>(status);
    map['entry_time'] = Variable<DateTime>(entryTime);
    if (!nullToAbsent || consultationStartTime != null) {
      map['consultation_start_time'] = Variable<DateTime>(
        consultationStartTime,
      );
    }
    if (!nullToAbsent || completionTime != null) {
      map['completion_time'] = Variable<DateTime>(completionTime);
    }
    if (!nullToAbsent || compiledPrescriptionJson != null) {
      map['compiled_prescription_json'] = Variable<String>(
        compiledPrescriptionJson,
      );
    }
    return map;
  }

  PatientQueueTableCompanion toCompanion(bool nullToAbsent) {
    return PatientQueueTableCompanion(
      id: Value(id),
      patientId: patientId == null && nullToAbsent
          ? const Value.absent()
          : Value(patientId),
      tokenNumber: Value(tokenNumber),
      patientName: Value(patientName),
      age: Value(age),
      gender: Value(gender),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      vitalsJson: vitalsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(vitalsJson),
      initialComorbIds: initialComorbIds == null && nullToAbsent
          ? const Value.absent()
          : Value(initialComorbIds),
      allergies: allergies == null && nullToAbsent
          ? const Value.absent()
          : Value(allergies),
      lmp: lmp == null && nullToAbsent ? const Value.absent() : Value(lmp),
      isPregnant: Value(isPregnant),
      status: Value(status),
      entryTime: Value(entryTime),
      consultationStartTime: consultationStartTime == null && nullToAbsent
          ? const Value.absent()
          : Value(consultationStartTime),
      completionTime: completionTime == null && nullToAbsent
          ? const Value.absent()
          : Value(completionTime),
      compiledPrescriptionJson: compiledPrescriptionJson == null && nullToAbsent
          ? const Value.absent()
          : Value(compiledPrescriptionJson),
    );
  }

  factory PatientQueueEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientQueueEntry(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String?>(json['patientId']),
      tokenNumber: serializer.fromJson<int>(json['tokenNumber']),
      patientName: serializer.fromJson<String>(json['patientName']),
      age: serializer.fromJson<int>(json['age']),
      gender: serializer.fromJson<String>(json['gender']),
      phone: serializer.fromJson<String?>(json['phone']),
      vitalsJson: serializer.fromJson<String?>(json['vitalsJson']),
      initialComorbIds: serializer.fromJson<String?>(json['initialComorbIds']),
      allergies: serializer.fromJson<String?>(json['allergies']),
      lmp: serializer.fromJson<String?>(json['lmp']),
      isPregnant: serializer.fromJson<bool>(json['isPregnant']),
      status: serializer.fromJson<String>(json['status']),
      entryTime: serializer.fromJson<DateTime>(json['entryTime']),
      consultationStartTime: serializer.fromJson<DateTime?>(
        json['consultationStartTime'],
      ),
      completionTime: serializer.fromJson<DateTime?>(json['completionTime']),
      compiledPrescriptionJson: serializer.fromJson<String?>(
        json['compiledPrescriptionJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String?>(patientId),
      'tokenNumber': serializer.toJson<int>(tokenNumber),
      'patientName': serializer.toJson<String>(patientName),
      'age': serializer.toJson<int>(age),
      'gender': serializer.toJson<String>(gender),
      'phone': serializer.toJson<String?>(phone),
      'vitalsJson': serializer.toJson<String?>(vitalsJson),
      'initialComorbIds': serializer.toJson<String?>(initialComorbIds),
      'allergies': serializer.toJson<String?>(allergies),
      'lmp': serializer.toJson<String?>(lmp),
      'isPregnant': serializer.toJson<bool>(isPregnant),
      'status': serializer.toJson<String>(status),
      'entryTime': serializer.toJson<DateTime>(entryTime),
      'consultationStartTime': serializer.toJson<DateTime?>(
        consultationStartTime,
      ),
      'completionTime': serializer.toJson<DateTime?>(completionTime),
      'compiledPrescriptionJson': serializer.toJson<String?>(
        compiledPrescriptionJson,
      ),
    };
  }

  PatientQueueEntry copyWith({
    String? id,
    Value<String?> patientId = const Value.absent(),
    int? tokenNumber,
    String? patientName,
    int? age,
    String? gender,
    Value<String?> phone = const Value.absent(),
    Value<String?> vitalsJson = const Value.absent(),
    Value<String?> initialComorbIds = const Value.absent(),
    Value<String?> allergies = const Value.absent(),
    Value<String?> lmp = const Value.absent(),
    bool? isPregnant,
    String? status,
    DateTime? entryTime,
    Value<DateTime?> consultationStartTime = const Value.absent(),
    Value<DateTime?> completionTime = const Value.absent(),
    Value<String?> compiledPrescriptionJson = const Value.absent(),
  }) => PatientQueueEntry(
    id: id ?? this.id,
    patientId: patientId.present ? patientId.value : this.patientId,
    tokenNumber: tokenNumber ?? this.tokenNumber,
    patientName: patientName ?? this.patientName,
    age: age ?? this.age,
    gender: gender ?? this.gender,
    phone: phone.present ? phone.value : this.phone,
    vitalsJson: vitalsJson.present ? vitalsJson.value : this.vitalsJson,
    initialComorbIds: initialComorbIds.present
        ? initialComorbIds.value
        : this.initialComorbIds,
    allergies: allergies.present ? allergies.value : this.allergies,
    lmp: lmp.present ? lmp.value : this.lmp,
    isPregnant: isPregnant ?? this.isPregnant,
    status: status ?? this.status,
    entryTime: entryTime ?? this.entryTime,
    consultationStartTime: consultationStartTime.present
        ? consultationStartTime.value
        : this.consultationStartTime,
    completionTime: completionTime.present
        ? completionTime.value
        : this.completionTime,
    compiledPrescriptionJson: compiledPrescriptionJson.present
        ? compiledPrescriptionJson.value
        : this.compiledPrescriptionJson,
  );
  PatientQueueEntry copyWithCompanion(PatientQueueTableCompanion data) {
    return PatientQueueEntry(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      tokenNumber: data.tokenNumber.present
          ? data.tokenNumber.value
          : this.tokenNumber,
      patientName: data.patientName.present
          ? data.patientName.value
          : this.patientName,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      phone: data.phone.present ? data.phone.value : this.phone,
      vitalsJson: data.vitalsJson.present
          ? data.vitalsJson.value
          : this.vitalsJson,
      initialComorbIds: data.initialComorbIds.present
          ? data.initialComorbIds.value
          : this.initialComorbIds,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      lmp: data.lmp.present ? data.lmp.value : this.lmp,
      isPregnant: data.isPregnant.present
          ? data.isPregnant.value
          : this.isPregnant,
      status: data.status.present ? data.status.value : this.status,
      entryTime: data.entryTime.present ? data.entryTime.value : this.entryTime,
      consultationStartTime: data.consultationStartTime.present
          ? data.consultationStartTime.value
          : this.consultationStartTime,
      completionTime: data.completionTime.present
          ? data.completionTime.value
          : this.completionTime,
      compiledPrescriptionJson: data.compiledPrescriptionJson.present
          ? data.compiledPrescriptionJson.value
          : this.compiledPrescriptionJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientQueueEntry(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('tokenNumber: $tokenNumber, ')
          ..write('patientName: $patientName, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('phone: $phone, ')
          ..write('vitalsJson: $vitalsJson, ')
          ..write('initialComorbIds: $initialComorbIds, ')
          ..write('allergies: $allergies, ')
          ..write('lmp: $lmp, ')
          ..write('isPregnant: $isPregnant, ')
          ..write('status: $status, ')
          ..write('entryTime: $entryTime, ')
          ..write('consultationStartTime: $consultationStartTime, ')
          ..write('completionTime: $completionTime, ')
          ..write('compiledPrescriptionJson: $compiledPrescriptionJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    tokenNumber,
    patientName,
    age,
    gender,
    phone,
    vitalsJson,
    initialComorbIds,
    allergies,
    lmp,
    isPregnant,
    status,
    entryTime,
    consultationStartTime,
    completionTime,
    compiledPrescriptionJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientQueueEntry &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.tokenNumber == this.tokenNumber &&
          other.patientName == this.patientName &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.phone == this.phone &&
          other.vitalsJson == this.vitalsJson &&
          other.initialComorbIds == this.initialComorbIds &&
          other.allergies == this.allergies &&
          other.lmp == this.lmp &&
          other.isPregnant == this.isPregnant &&
          other.status == this.status &&
          other.entryTime == this.entryTime &&
          other.consultationStartTime == this.consultationStartTime &&
          other.completionTime == this.completionTime &&
          other.compiledPrescriptionJson == this.compiledPrescriptionJson);
}

class PatientQueueTableCompanion extends UpdateCompanion<PatientQueueEntry> {
  final Value<String> id;
  final Value<String?> patientId;
  final Value<int> tokenNumber;
  final Value<String> patientName;
  final Value<int> age;
  final Value<String> gender;
  final Value<String?> phone;
  final Value<String?> vitalsJson;
  final Value<String?> initialComorbIds;
  final Value<String?> allergies;
  final Value<String?> lmp;
  final Value<bool> isPregnant;
  final Value<String> status;
  final Value<DateTime> entryTime;
  final Value<DateTime?> consultationStartTime;
  final Value<DateTime?> completionTime;
  final Value<String?> compiledPrescriptionJson;
  final Value<int> rowid;
  const PatientQueueTableCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.tokenNumber = const Value.absent(),
    this.patientName = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.phone = const Value.absent(),
    this.vitalsJson = const Value.absent(),
    this.initialComorbIds = const Value.absent(),
    this.allergies = const Value.absent(),
    this.lmp = const Value.absent(),
    this.isPregnant = const Value.absent(),
    this.status = const Value.absent(),
    this.entryTime = const Value.absent(),
    this.consultationStartTime = const Value.absent(),
    this.completionTime = const Value.absent(),
    this.compiledPrescriptionJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientQueueTableCompanion.insert({
    required String id,
    this.patientId = const Value.absent(),
    required int tokenNumber,
    required String patientName,
    required int age,
    required String gender,
    this.phone = const Value.absent(),
    this.vitalsJson = const Value.absent(),
    this.initialComorbIds = const Value.absent(),
    this.allergies = const Value.absent(),
    this.lmp = const Value.absent(),
    this.isPregnant = const Value.absent(),
    required String status,
    required DateTime entryTime,
    this.consultationStartTime = const Value.absent(),
    this.completionTime = const Value.absent(),
    this.compiledPrescriptionJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokenNumber = Value(tokenNumber),
       patientName = Value(patientName),
       age = Value(age),
       gender = Value(gender),
       status = Value(status),
       entryTime = Value(entryTime);
  static Insertable<PatientQueueEntry> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<int>? tokenNumber,
    Expression<String>? patientName,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<String>? phone,
    Expression<String>? vitalsJson,
    Expression<String>? initialComorbIds,
    Expression<String>? allergies,
    Expression<String>? lmp,
    Expression<bool>? isPregnant,
    Expression<String>? status,
    Expression<DateTime>? entryTime,
    Expression<DateTime>? consultationStartTime,
    Expression<DateTime>? completionTime,
    Expression<String>? compiledPrescriptionJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (tokenNumber != null) 'token_number': tokenNumber,
      if (patientName != null) 'patient_name': patientName,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (phone != null) 'phone': phone,
      if (vitalsJson != null) 'vitals_json': vitalsJson,
      if (initialComorbIds != null) 'initial_comorb_ids': initialComorbIds,
      if (allergies != null) 'allergies': allergies,
      if (lmp != null) 'lmp': lmp,
      if (isPregnant != null) 'is_pregnant': isPregnant,
      if (status != null) 'status': status,
      if (entryTime != null) 'entry_time': entryTime,
      if (consultationStartTime != null)
        'consultation_start_time': consultationStartTime,
      if (completionTime != null) 'completion_time': completionTime,
      if (compiledPrescriptionJson != null)
        'compiled_prescription_json': compiledPrescriptionJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientQueueTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? patientId,
    Value<int>? tokenNumber,
    Value<String>? patientName,
    Value<int>? age,
    Value<String>? gender,
    Value<String?>? phone,
    Value<String?>? vitalsJson,
    Value<String?>? initialComorbIds,
    Value<String?>? allergies,
    Value<String?>? lmp,
    Value<bool>? isPregnant,
    Value<String>? status,
    Value<DateTime>? entryTime,
    Value<DateTime?>? consultationStartTime,
    Value<DateTime?>? completionTime,
    Value<String?>? compiledPrescriptionJson,
    Value<int>? rowid,
  }) {
    return PatientQueueTableCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      patientName: patientName ?? this.patientName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      vitalsJson: vitalsJson ?? this.vitalsJson,
      initialComorbIds: initialComorbIds ?? this.initialComorbIds,
      allergies: allergies ?? this.allergies,
      lmp: lmp ?? this.lmp,
      isPregnant: isPregnant ?? this.isPregnant,
      status: status ?? this.status,
      entryTime: entryTime ?? this.entryTime,
      consultationStartTime:
          consultationStartTime ?? this.consultationStartTime,
      completionTime: completionTime ?? this.completionTime,
      compiledPrescriptionJson:
          compiledPrescriptionJson ?? this.compiledPrescriptionJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (tokenNumber.present) {
      map['token_number'] = Variable<int>(tokenNumber.value);
    }
    if (patientName.present) {
      map['patient_name'] = Variable<String>(patientName.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (vitalsJson.present) {
      map['vitals_json'] = Variable<String>(vitalsJson.value);
    }
    if (initialComorbIds.present) {
      map['initial_comorb_ids'] = Variable<String>(initialComorbIds.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (lmp.present) {
      map['lmp'] = Variable<String>(lmp.value);
    }
    if (isPregnant.present) {
      map['is_pregnant'] = Variable<bool>(isPregnant.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (entryTime.present) {
      map['entry_time'] = Variable<DateTime>(entryTime.value);
    }
    if (consultationStartTime.present) {
      map['consultation_start_time'] = Variable<DateTime>(
        consultationStartTime.value,
      );
    }
    if (completionTime.present) {
      map['completion_time'] = Variable<DateTime>(completionTime.value);
    }
    if (compiledPrescriptionJson.present) {
      map['compiled_prescription_json'] = Variable<String>(
        compiledPrescriptionJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('tokenNumber: $tokenNumber, ')
          ..write('patientName: $patientName, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('phone: $phone, ')
          ..write('vitalsJson: $vitalsJson, ')
          ..write('initialComorbIds: $initialComorbIds, ')
          ..write('allergies: $allergies, ')
          ..write('lmp: $lmp, ')
          ..write('isPregnant: $isPregnant, ')
          ..write('status: $status, ')
          ..write('entryTime: $entryTime, ')
          ..write('consultationStartTime: $consultationStartTime, ')
          ..write('completionTime: $completionTime, ')
          ..write('compiledPrescriptionJson: $compiledPrescriptionJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ComorbiditiesTableTable extends ComorbiditiesTable
    with TableInfo<$ComorbiditiesTableTable, ComorbidityEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComorbiditiesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contraindicatedDrugClassesMeta =
      const VerificationMeta('contraindicatedDrugClasses');
  @override
  late final GeneratedColumn<String> contraindicatedDrugClasses =
      GeneratedColumn<String>(
        'contraindicated_drug_classes',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [id, name, contraindicatedDrugClasses];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'comorbidities_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComorbidityEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('contraindicated_drug_classes')) {
      context.handle(
        _contraindicatedDrugClassesMeta,
        contraindicatedDrugClasses.isAcceptableOrUnknown(
          data['contraindicated_drug_classes']!,
          _contraindicatedDrugClassesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contraindicatedDrugClassesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ComorbidityEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComorbidityEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      contraindicatedDrugClasses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contraindicated_drug_classes'],
      )!,
    );
  }

  @override
  $ComorbiditiesTableTable createAlias(String alias) {
    return $ComorbiditiesTableTable(attachedDatabase, alias);
  }
}

class ComorbidityEntry extends DataClass
    implements Insertable<ComorbidityEntry> {
  final String id;
  final String name;
  final String contraindicatedDrugClasses;
  const ComorbidityEntry({
    required this.id,
    required this.name,
    required this.contraindicatedDrugClasses,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['contraindicated_drug_classes'] = Variable<String>(
      contraindicatedDrugClasses,
    );
    return map;
  }

  ComorbiditiesTableCompanion toCompanion(bool nullToAbsent) {
    return ComorbiditiesTableCompanion(
      id: Value(id),
      name: Value(name),
      contraindicatedDrugClasses: Value(contraindicatedDrugClasses),
    );
  }

  factory ComorbidityEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComorbidityEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      contraindicatedDrugClasses: serializer.fromJson<String>(
        json['contraindicatedDrugClasses'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'contraindicatedDrugClasses': serializer.toJson<String>(
        contraindicatedDrugClasses,
      ),
    };
  }

  ComorbidityEntry copyWith({
    String? id,
    String? name,
    String? contraindicatedDrugClasses,
  }) => ComorbidityEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    contraindicatedDrugClasses:
        contraindicatedDrugClasses ?? this.contraindicatedDrugClasses,
  );
  ComorbidityEntry copyWithCompanion(ComorbiditiesTableCompanion data) {
    return ComorbidityEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contraindicatedDrugClasses: data.contraindicatedDrugClasses.present
          ? data.contraindicatedDrugClasses.value
          : this.contraindicatedDrugClasses,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComorbidityEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contraindicatedDrugClasses: $contraindicatedDrugClasses')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, contraindicatedDrugClasses);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComorbidityEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.contraindicatedDrugClasses == this.contraindicatedDrugClasses);
}

class ComorbiditiesTableCompanion extends UpdateCompanion<ComorbidityEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> contraindicatedDrugClasses;
  final Value<int> rowid;
  const ComorbiditiesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contraindicatedDrugClasses = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComorbiditiesTableCompanion.insert({
    required String id,
    required String name,
    required String contraindicatedDrugClasses,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       contraindicatedDrugClasses = Value(contraindicatedDrugClasses);
  static Insertable<ComorbidityEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? contraindicatedDrugClasses,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contraindicatedDrugClasses != null)
        'contraindicated_drug_classes': contraindicatedDrugClasses,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComorbiditiesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? contraindicatedDrugClasses,
    Value<int>? rowid,
  }) {
    return ComorbiditiesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      contraindicatedDrugClasses:
          contraindicatedDrugClasses ?? this.contraindicatedDrugClasses,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contraindicatedDrugClasses.present) {
      map['contraindicated_drug_classes'] = Variable<String>(
        contraindicatedDrugClasses.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComorbiditiesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contraindicatedDrugClasses: $contraindicatedDrugClasses, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PresentingComplaintsTableTable extends PresentingComplaintsTable
    with TableInfo<$PresentingComplaintsTableTable, PresentingComplaintEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresentingComplaintsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, category, displayOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presenting_complaints_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PresentingComplaintEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PresentingComplaintEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PresentingComplaintEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $PresentingComplaintsTableTable createAlias(String alias) {
    return $PresentingComplaintsTableTable(attachedDatabase, alias);
  }
}

class PresentingComplaintEntry extends DataClass
    implements Insertable<PresentingComplaintEntry> {
  final String id;
  final String name;
  final String category;
  final int displayOrder;
  const PresentingComplaintEntry({
    required this.id,
    required this.name,
    required this.category,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  PresentingComplaintsTableCompanion toCompanion(bool nullToAbsent) {
    return PresentingComplaintsTableCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      displayOrder: Value(displayOrder),
    );
  }

  factory PresentingComplaintEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PresentingComplaintEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  PresentingComplaintEntry copyWith({
    String? id,
    String? name,
    String? category,
    int? displayOrder,
  }) => PresentingComplaintEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  PresentingComplaintEntry copyWithCompanion(
    PresentingComplaintsTableCompanion data,
  ) {
    return PresentingComplaintEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PresentingComplaintEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, displayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PresentingComplaintEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.displayOrder == this.displayOrder);
}

class PresentingComplaintsTableCompanion
    extends UpdateCompanion<PresentingComplaintEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> displayOrder;
  final Value<int> rowid;
  const PresentingComplaintsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PresentingComplaintsTableCompanion.insert({
    required String id,
    required String name,
    required String category,
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category);
  static Insertable<PresentingComplaintEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? displayOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PresentingComplaintsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<int>? displayOrder,
    Value<int>? rowid,
  }) {
    return PresentingComplaintsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      displayOrder: displayOrder ?? this.displayOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresentingComplaintsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ComplaintSubQuestionsTableTable extends ComplaintSubQuestionsTable
    with
        TableInfo<$ComplaintSubQuestionsTableTable, ComplaintSubQuestionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComplaintSubQuestionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _complaintIdMeta = const VerificationMeta(
    'complaintId',
  );
  @override
  late final GeneratedColumn<String> complaintId = GeneratedColumn<String>(
    'complaint_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES presenting_complaints_table (id)',
    ),
  );
  static const VerificationMeta _questionLabelMeta = const VerificationMeta(
    'questionLabel',
  );
  @override
  late final GeneratedColumn<String> questionLabel = GeneratedColumn<String>(
    'question_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsJsonMeta = const VerificationMeta(
    'optionsJson',
  );
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
    'options_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentenceTemplateMeta = const VerificationMeta(
    'sentenceTemplate',
  );
  @override
  late final GeneratedColumn<String> sentenceTemplate = GeneratedColumn<String>(
    'sentence_template',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isMultiSelectMeta = const VerificationMeta(
    'isMultiSelect',
  );
  @override
  late final GeneratedColumn<bool> isMultiSelect = GeneratedColumn<bool>(
    'is_multi_select',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_multi_select" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sequenceOrderMeta = const VerificationMeta(
    'sequenceOrder',
  );
  @override
  late final GeneratedColumn<int> sequenceOrder = GeneratedColumn<int>(
    'sequence_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    complaintId,
    questionLabel,
    optionsJson,
    sentenceTemplate,
    isMultiSelect,
    sequenceOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'complaint_sub_questions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComplaintSubQuestionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('complaint_id')) {
      context.handle(
        _complaintIdMeta,
        complaintId.isAcceptableOrUnknown(
          data['complaint_id']!,
          _complaintIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_complaintIdMeta);
    }
    if (data.containsKey('question_label')) {
      context.handle(
        _questionLabelMeta,
        questionLabel.isAcceptableOrUnknown(
          data['question_label']!,
          _questionLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionLabelMeta);
    }
    if (data.containsKey('options_json')) {
      context.handle(
        _optionsJsonMeta,
        optionsJson.isAcceptableOrUnknown(
          data['options_json']!,
          _optionsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_optionsJsonMeta);
    }
    if (data.containsKey('sentence_template')) {
      context.handle(
        _sentenceTemplateMeta,
        sentenceTemplate.isAcceptableOrUnknown(
          data['sentence_template']!,
          _sentenceTemplateMeta,
        ),
      );
    }
    if (data.containsKey('is_multi_select')) {
      context.handle(
        _isMultiSelectMeta,
        isMultiSelect.isAcceptableOrUnknown(
          data['is_multi_select']!,
          _isMultiSelectMeta,
        ),
      );
    }
    if (data.containsKey('sequence_order')) {
      context.handle(
        _sequenceOrderMeta,
        sequenceOrder.isAcceptableOrUnknown(
          data['sequence_order']!,
          _sequenceOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ComplaintSubQuestionEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComplaintSubQuestionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      complaintId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}complaint_id'],
      )!,
      questionLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_label'],
      )!,
      optionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_json'],
      )!,
      sentenceTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sentence_template'],
      )!,
      isMultiSelect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_multi_select'],
      )!,
      sequenceOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_order'],
      )!,
    );
  }

  @override
  $ComplaintSubQuestionsTableTable createAlias(String alias) {
    return $ComplaintSubQuestionsTableTable(attachedDatabase, alias);
  }
}

class ComplaintSubQuestionEntry extends DataClass
    implements Insertable<ComplaintSubQuestionEntry> {
  final String id;
  final String complaintId;
  final String questionLabel;
  final String optionsJson;
  final String sentenceTemplate;
  final bool isMultiSelect;
  final int sequenceOrder;
  const ComplaintSubQuestionEntry({
    required this.id,
    required this.complaintId,
    required this.questionLabel,
    required this.optionsJson,
    required this.sentenceTemplate,
    required this.isMultiSelect,
    required this.sequenceOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['complaint_id'] = Variable<String>(complaintId);
    map['question_label'] = Variable<String>(questionLabel);
    map['options_json'] = Variable<String>(optionsJson);
    map['sentence_template'] = Variable<String>(sentenceTemplate);
    map['is_multi_select'] = Variable<bool>(isMultiSelect);
    map['sequence_order'] = Variable<int>(sequenceOrder);
    return map;
  }

  ComplaintSubQuestionsTableCompanion toCompanion(bool nullToAbsent) {
    return ComplaintSubQuestionsTableCompanion(
      id: Value(id),
      complaintId: Value(complaintId),
      questionLabel: Value(questionLabel),
      optionsJson: Value(optionsJson),
      sentenceTemplate: Value(sentenceTemplate),
      isMultiSelect: Value(isMultiSelect),
      sequenceOrder: Value(sequenceOrder),
    );
  }

  factory ComplaintSubQuestionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComplaintSubQuestionEntry(
      id: serializer.fromJson<String>(json['id']),
      complaintId: serializer.fromJson<String>(json['complaintId']),
      questionLabel: serializer.fromJson<String>(json['questionLabel']),
      optionsJson: serializer.fromJson<String>(json['optionsJson']),
      sentenceTemplate: serializer.fromJson<String>(json['sentenceTemplate']),
      isMultiSelect: serializer.fromJson<bool>(json['isMultiSelect']),
      sequenceOrder: serializer.fromJson<int>(json['sequenceOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'complaintId': serializer.toJson<String>(complaintId),
      'questionLabel': serializer.toJson<String>(questionLabel),
      'optionsJson': serializer.toJson<String>(optionsJson),
      'sentenceTemplate': serializer.toJson<String>(sentenceTemplate),
      'isMultiSelect': serializer.toJson<bool>(isMultiSelect),
      'sequenceOrder': serializer.toJson<int>(sequenceOrder),
    };
  }

  ComplaintSubQuestionEntry copyWith({
    String? id,
    String? complaintId,
    String? questionLabel,
    String? optionsJson,
    String? sentenceTemplate,
    bool? isMultiSelect,
    int? sequenceOrder,
  }) => ComplaintSubQuestionEntry(
    id: id ?? this.id,
    complaintId: complaintId ?? this.complaintId,
    questionLabel: questionLabel ?? this.questionLabel,
    optionsJson: optionsJson ?? this.optionsJson,
    sentenceTemplate: sentenceTemplate ?? this.sentenceTemplate,
    isMultiSelect: isMultiSelect ?? this.isMultiSelect,
    sequenceOrder: sequenceOrder ?? this.sequenceOrder,
  );
  ComplaintSubQuestionEntry copyWithCompanion(
    ComplaintSubQuestionsTableCompanion data,
  ) {
    return ComplaintSubQuestionEntry(
      id: data.id.present ? data.id.value : this.id,
      complaintId: data.complaintId.present
          ? data.complaintId.value
          : this.complaintId,
      questionLabel: data.questionLabel.present
          ? data.questionLabel.value
          : this.questionLabel,
      optionsJson: data.optionsJson.present
          ? data.optionsJson.value
          : this.optionsJson,
      sentenceTemplate: data.sentenceTemplate.present
          ? data.sentenceTemplate.value
          : this.sentenceTemplate,
      isMultiSelect: data.isMultiSelect.present
          ? data.isMultiSelect.value
          : this.isMultiSelect,
      sequenceOrder: data.sequenceOrder.present
          ? data.sequenceOrder.value
          : this.sequenceOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComplaintSubQuestionEntry(')
          ..write('id: $id, ')
          ..write('complaintId: $complaintId, ')
          ..write('questionLabel: $questionLabel, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('sentenceTemplate: $sentenceTemplate, ')
          ..write('isMultiSelect: $isMultiSelect, ')
          ..write('sequenceOrder: $sequenceOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    complaintId,
    questionLabel,
    optionsJson,
    sentenceTemplate,
    isMultiSelect,
    sequenceOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComplaintSubQuestionEntry &&
          other.id == this.id &&
          other.complaintId == this.complaintId &&
          other.questionLabel == this.questionLabel &&
          other.optionsJson == this.optionsJson &&
          other.sentenceTemplate == this.sentenceTemplate &&
          other.isMultiSelect == this.isMultiSelect &&
          other.sequenceOrder == this.sequenceOrder);
}

class ComplaintSubQuestionsTableCompanion
    extends UpdateCompanion<ComplaintSubQuestionEntry> {
  final Value<String> id;
  final Value<String> complaintId;
  final Value<String> questionLabel;
  final Value<String> optionsJson;
  final Value<String> sentenceTemplate;
  final Value<bool> isMultiSelect;
  final Value<int> sequenceOrder;
  final Value<int> rowid;
  const ComplaintSubQuestionsTableCompanion({
    this.id = const Value.absent(),
    this.complaintId = const Value.absent(),
    this.questionLabel = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.sentenceTemplate = const Value.absent(),
    this.isMultiSelect = const Value.absent(),
    this.sequenceOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComplaintSubQuestionsTableCompanion.insert({
    required String id,
    required String complaintId,
    required String questionLabel,
    required String optionsJson,
    this.sentenceTemplate = const Value.absent(),
    this.isMultiSelect = const Value.absent(),
    this.sequenceOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       complaintId = Value(complaintId),
       questionLabel = Value(questionLabel),
       optionsJson = Value(optionsJson);
  static Insertable<ComplaintSubQuestionEntry> custom({
    Expression<String>? id,
    Expression<String>? complaintId,
    Expression<String>? questionLabel,
    Expression<String>? optionsJson,
    Expression<String>? sentenceTemplate,
    Expression<bool>? isMultiSelect,
    Expression<int>? sequenceOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (complaintId != null) 'complaint_id': complaintId,
      if (questionLabel != null) 'question_label': questionLabel,
      if (optionsJson != null) 'options_json': optionsJson,
      if (sentenceTemplate != null) 'sentence_template': sentenceTemplate,
      if (isMultiSelect != null) 'is_multi_select': isMultiSelect,
      if (sequenceOrder != null) 'sequence_order': sequenceOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComplaintSubQuestionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? complaintId,
    Value<String>? questionLabel,
    Value<String>? optionsJson,
    Value<String>? sentenceTemplate,
    Value<bool>? isMultiSelect,
    Value<int>? sequenceOrder,
    Value<int>? rowid,
  }) {
    return ComplaintSubQuestionsTableCompanion(
      id: id ?? this.id,
      complaintId: complaintId ?? this.complaintId,
      questionLabel: questionLabel ?? this.questionLabel,
      optionsJson: optionsJson ?? this.optionsJson,
      sentenceTemplate: sentenceTemplate ?? this.sentenceTemplate,
      isMultiSelect: isMultiSelect ?? this.isMultiSelect,
      sequenceOrder: sequenceOrder ?? this.sequenceOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (complaintId.present) {
      map['complaint_id'] = Variable<String>(complaintId.value);
    }
    if (questionLabel.present) {
      map['question_label'] = Variable<String>(questionLabel.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (sentenceTemplate.present) {
      map['sentence_template'] = Variable<String>(sentenceTemplate.value);
    }
    if (isMultiSelect.present) {
      map['is_multi_select'] = Variable<bool>(isMultiSelect.value);
    }
    if (sequenceOrder.present) {
      map['sequence_order'] = Variable<int>(sequenceOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComplaintSubQuestionsTableCompanion(')
          ..write('id: $id, ')
          ..write('complaintId: $complaintId, ')
          ..write('questionLabel: $questionLabel, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('sentenceTemplate: $sentenceTemplate, ')
          ..write('isMultiSelect: $isMultiSelect, ')
          ..write('sequenceOrder: $sequenceOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExaminationSystemsTableTable extends ExaminationSystemsTable
    with TableInfo<$ExaminationSystemsTableTable, ExaminationSystemEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExaminationSystemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _systemNameMeta = const VerificationMeta(
    'systemName',
  );
  @override
  late final GeneratedColumn<String> systemName = GeneratedColumn<String>(
    'system_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultNormalTextMeta = const VerificationMeta(
    'defaultNormalText',
  );
  @override
  late final GeneratedColumn<String> defaultNormalText =
      GeneratedColumn<String>(
        'default_normal_text',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _abnormalFindingsJsonMeta =
      const VerificationMeta('abnormalFindingsJson');
  @override
  late final GeneratedColumn<String> abnormalFindingsJson =
      GeneratedColumn<String>(
        'abnormal_findings_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    systemName,
    defaultNormalText,
    abnormalFindingsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'examination_systems_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExaminationSystemEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('system_name')) {
      context.handle(
        _systemNameMeta,
        systemName.isAcceptableOrUnknown(data['system_name']!, _systemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_systemNameMeta);
    }
    if (data.containsKey('default_normal_text')) {
      context.handle(
        _defaultNormalTextMeta,
        defaultNormalText.isAcceptableOrUnknown(
          data['default_normal_text']!,
          _defaultNormalTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultNormalTextMeta);
    }
    if (data.containsKey('abnormal_findings_json')) {
      context.handle(
        _abnormalFindingsJsonMeta,
        abnormalFindingsJson.isAcceptableOrUnknown(
          data['abnormal_findings_json']!,
          _abnormalFindingsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_abnormalFindingsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExaminationSystemEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExaminationSystemEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      systemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_name'],
      )!,
      defaultNormalText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_normal_text'],
      )!,
      abnormalFindingsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abnormal_findings_json'],
      )!,
    );
  }

  @override
  $ExaminationSystemsTableTable createAlias(String alias) {
    return $ExaminationSystemsTableTable(attachedDatabase, alias);
  }
}

class ExaminationSystemEntry extends DataClass
    implements Insertable<ExaminationSystemEntry> {
  final String id;
  final String systemName;
  final String defaultNormalText;
  final String abnormalFindingsJson;
  const ExaminationSystemEntry({
    required this.id,
    required this.systemName,
    required this.defaultNormalText,
    required this.abnormalFindingsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['system_name'] = Variable<String>(systemName);
    map['default_normal_text'] = Variable<String>(defaultNormalText);
    map['abnormal_findings_json'] = Variable<String>(abnormalFindingsJson);
    return map;
  }

  ExaminationSystemsTableCompanion toCompanion(bool nullToAbsent) {
    return ExaminationSystemsTableCompanion(
      id: Value(id),
      systemName: Value(systemName),
      defaultNormalText: Value(defaultNormalText),
      abnormalFindingsJson: Value(abnormalFindingsJson),
    );
  }

  factory ExaminationSystemEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExaminationSystemEntry(
      id: serializer.fromJson<String>(json['id']),
      systemName: serializer.fromJson<String>(json['systemName']),
      defaultNormalText: serializer.fromJson<String>(json['defaultNormalText']),
      abnormalFindingsJson: serializer.fromJson<String>(
        json['abnormalFindingsJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'systemName': serializer.toJson<String>(systemName),
      'defaultNormalText': serializer.toJson<String>(defaultNormalText),
      'abnormalFindingsJson': serializer.toJson<String>(abnormalFindingsJson),
    };
  }

  ExaminationSystemEntry copyWith({
    String? id,
    String? systemName,
    String? defaultNormalText,
    String? abnormalFindingsJson,
  }) => ExaminationSystemEntry(
    id: id ?? this.id,
    systemName: systemName ?? this.systemName,
    defaultNormalText: defaultNormalText ?? this.defaultNormalText,
    abnormalFindingsJson: abnormalFindingsJson ?? this.abnormalFindingsJson,
  );
  ExaminationSystemEntry copyWithCompanion(
    ExaminationSystemsTableCompanion data,
  ) {
    return ExaminationSystemEntry(
      id: data.id.present ? data.id.value : this.id,
      systemName: data.systemName.present
          ? data.systemName.value
          : this.systemName,
      defaultNormalText: data.defaultNormalText.present
          ? data.defaultNormalText.value
          : this.defaultNormalText,
      abnormalFindingsJson: data.abnormalFindingsJson.present
          ? data.abnormalFindingsJson.value
          : this.abnormalFindingsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExaminationSystemEntry(')
          ..write('id: $id, ')
          ..write('systemName: $systemName, ')
          ..write('defaultNormalText: $defaultNormalText, ')
          ..write('abnormalFindingsJson: $abnormalFindingsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, systemName, defaultNormalText, abnormalFindingsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExaminationSystemEntry &&
          other.id == this.id &&
          other.systemName == this.systemName &&
          other.defaultNormalText == this.defaultNormalText &&
          other.abnormalFindingsJson == this.abnormalFindingsJson);
}

class ExaminationSystemsTableCompanion
    extends UpdateCompanion<ExaminationSystemEntry> {
  final Value<String> id;
  final Value<String> systemName;
  final Value<String> defaultNormalText;
  final Value<String> abnormalFindingsJson;
  final Value<int> rowid;
  const ExaminationSystemsTableCompanion({
    this.id = const Value.absent(),
    this.systemName = const Value.absent(),
    this.defaultNormalText = const Value.absent(),
    this.abnormalFindingsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExaminationSystemsTableCompanion.insert({
    required String id,
    required String systemName,
    required String defaultNormalText,
    required String abnormalFindingsJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       systemName = Value(systemName),
       defaultNormalText = Value(defaultNormalText),
       abnormalFindingsJson = Value(abnormalFindingsJson);
  static Insertable<ExaminationSystemEntry> custom({
    Expression<String>? id,
    Expression<String>? systemName,
    Expression<String>? defaultNormalText,
    Expression<String>? abnormalFindingsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (systemName != null) 'system_name': systemName,
      if (defaultNormalText != null) 'default_normal_text': defaultNormalText,
      if (abnormalFindingsJson != null)
        'abnormal_findings_json': abnormalFindingsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExaminationSystemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? systemName,
    Value<String>? defaultNormalText,
    Value<String>? abnormalFindingsJson,
    Value<int>? rowid,
  }) {
    return ExaminationSystemsTableCompanion(
      id: id ?? this.id,
      systemName: systemName ?? this.systemName,
      defaultNormalText: defaultNormalText ?? this.defaultNormalText,
      abnormalFindingsJson: abnormalFindingsJson ?? this.abnormalFindingsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (systemName.present) {
      map['system_name'] = Variable<String>(systemName.value);
    }
    if (defaultNormalText.present) {
      map['default_normal_text'] = Variable<String>(defaultNormalText.value);
    }
    if (abnormalFindingsJson.present) {
      map['abnormal_findings_json'] = Variable<String>(
        abnormalFindingsJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExaminationSystemsTableCompanion(')
          ..write('id: $id, ')
          ..write('systemName: $systemName, ')
          ..write('defaultNormalText: $defaultNormalText, ')
          ..write('abnormalFindingsJson: $abnormalFindingsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiagnosesTableTable extends DiagnosesTable
    with TableInfo<$DiagnosesTableTable, DiagnosisEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiagnosesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _icd10CodeMeta = const VerificationMeta(
    'icd10Code',
  );
  @override
  late final GeneratedColumn<String> icd10Code = GeneratedColumn<String>(
    'icd10_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedComplaintIdsMeta =
      const VerificationMeta('linkedComplaintIds');
  @override
  late final GeneratedColumn<String> linkedComplaintIds =
      GeneratedColumn<String>(
        'linked_complaint_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icd10Code,
    linkedComplaintIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diagnoses_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiagnosisEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icd10_code')) {
      context.handle(
        _icd10CodeMeta,
        icd10Code.isAcceptableOrUnknown(data['icd10_code']!, _icd10CodeMeta),
      );
    }
    if (data.containsKey('linked_complaint_ids')) {
      context.handle(
        _linkedComplaintIdsMeta,
        linkedComplaintIds.isAcceptableOrUnknown(
          data['linked_complaint_ids']!,
          _linkedComplaintIdsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_linkedComplaintIdsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiagnosisEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiagnosisEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icd10Code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icd10_code'],
      ),
      linkedComplaintIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_complaint_ids'],
      )!,
    );
  }

  @override
  $DiagnosesTableTable createAlias(String alias) {
    return $DiagnosesTableTable(attachedDatabase, alias);
  }
}

class DiagnosisEntry extends DataClass implements Insertable<DiagnosisEntry> {
  final String id;
  final String name;
  final String? icd10Code;
  final String linkedComplaintIds;
  const DiagnosisEntry({
    required this.id,
    required this.name,
    this.icd10Code,
    required this.linkedComplaintIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icd10Code != null) {
      map['icd10_code'] = Variable<String>(icd10Code);
    }
    map['linked_complaint_ids'] = Variable<String>(linkedComplaintIds);
    return map;
  }

  DiagnosesTableCompanion toCompanion(bool nullToAbsent) {
    return DiagnosesTableCompanion(
      id: Value(id),
      name: Value(name),
      icd10Code: icd10Code == null && nullToAbsent
          ? const Value.absent()
          : Value(icd10Code),
      linkedComplaintIds: Value(linkedComplaintIds),
    );
  }

  factory DiagnosisEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiagnosisEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icd10Code: serializer.fromJson<String?>(json['icd10Code']),
      linkedComplaintIds: serializer.fromJson<String>(
        json['linkedComplaintIds'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icd10Code': serializer.toJson<String?>(icd10Code),
      'linkedComplaintIds': serializer.toJson<String>(linkedComplaintIds),
    };
  }

  DiagnosisEntry copyWith({
    String? id,
    String? name,
    Value<String?> icd10Code = const Value.absent(),
    String? linkedComplaintIds,
  }) => DiagnosisEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    icd10Code: icd10Code.present ? icd10Code.value : this.icd10Code,
    linkedComplaintIds: linkedComplaintIds ?? this.linkedComplaintIds,
  );
  DiagnosisEntry copyWithCompanion(DiagnosesTableCompanion data) {
    return DiagnosisEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icd10Code: data.icd10Code.present ? data.icd10Code.value : this.icd10Code,
      linkedComplaintIds: data.linkedComplaintIds.present
          ? data.linkedComplaintIds.value
          : this.linkedComplaintIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosisEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icd10Code: $icd10Code, ')
          ..write('linkedComplaintIds: $linkedComplaintIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icd10Code, linkedComplaintIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiagnosisEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.icd10Code == this.icd10Code &&
          other.linkedComplaintIds == this.linkedComplaintIds);
}

class DiagnosesTableCompanion extends UpdateCompanion<DiagnosisEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icd10Code;
  final Value<String> linkedComplaintIds;
  final Value<int> rowid;
  const DiagnosesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icd10Code = const Value.absent(),
    this.linkedComplaintIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiagnosesTableCompanion.insert({
    required String id,
    required String name,
    this.icd10Code = const Value.absent(),
    required String linkedComplaintIds,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       linkedComplaintIds = Value(linkedComplaintIds);
  static Insertable<DiagnosisEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icd10Code,
    Expression<String>? linkedComplaintIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icd10Code != null) 'icd10_code': icd10Code,
      if (linkedComplaintIds != null)
        'linked_complaint_ids': linkedComplaintIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiagnosesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? icd10Code,
    Value<String>? linkedComplaintIds,
    Value<int>? rowid,
  }) {
    return DiagnosesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icd10Code: icd10Code ?? this.icd10Code,
      linkedComplaintIds: linkedComplaintIds ?? this.linkedComplaintIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icd10Code.present) {
      map['icd10_code'] = Variable<String>(icd10Code.value);
    }
    if (linkedComplaintIds.present) {
      map['linked_complaint_ids'] = Variable<String>(linkedComplaintIds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icd10Code: $icd10Code, ')
          ..write('linkedComplaintIds: $linkedComplaintIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DrugsTableTable extends DrugsTable
    with TableInfo<$DrugsTableTable, DrugEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrugsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genericNameMeta = const VerificationMeta(
    'genericName',
  );
  @override
  late final GeneratedColumn<String> genericName = GeneratedColumn<String>(
    'generic_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandNameMeta = const VerificationMeta(
    'brandName',
  );
  @override
  late final GeneratedColumn<String> brandName = GeneratedColumn<String>(
    'brand_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _drugClassMeta = const VerificationMeta(
    'drugClass',
  );
  @override
  late final GeneratedColumn<String> drugClass = GeneratedColumn<String>(
    'drug_class',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultDoseMeta = const VerificationMeta(
    'defaultDose',
  );
  @override
  late final GeneratedColumn<String> defaultDose = GeneratedColumn<String>(
    'default_dose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultRouteMeta = const VerificationMeta(
    'defaultRoute',
  );
  @override
  late final GeneratedColumn<String> defaultRoute = GeneratedColumn<String>(
    'default_route',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultFrequencyMeta = const VerificationMeta(
    'defaultFrequency',
  );
  @override
  late final GeneratedColumn<String> defaultFrequency = GeneratedColumn<String>(
    'default_frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultDurationMeta = const VerificationMeta(
    'defaultDuration',
  );
  @override
  late final GeneratedColumn<String> defaultDuration = GeneratedColumn<String>(
    'default_duration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultInstructionsMeta =
      const VerificationMeta('defaultInstructions');
  @override
  late final GeneratedColumn<String> defaultInstructions =
      GeneratedColumn<String>(
        'default_instructions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    genericName,
    brandName,
    drugClass,
    defaultDose,
    defaultRoute,
    defaultFrequency,
    defaultDuration,
    defaultInstructions,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drugs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DrugEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('generic_name')) {
      context.handle(
        _genericNameMeta,
        genericName.isAcceptableOrUnknown(
          data['generic_name']!,
          _genericNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_genericNameMeta);
    }
    if (data.containsKey('brand_name')) {
      context.handle(
        _brandNameMeta,
        brandName.isAcceptableOrUnknown(data['brand_name']!, _brandNameMeta),
      );
    } else if (isInserting) {
      context.missing(_brandNameMeta);
    }
    if (data.containsKey('drug_class')) {
      context.handle(
        _drugClassMeta,
        drugClass.isAcceptableOrUnknown(data['drug_class']!, _drugClassMeta),
      );
    } else if (isInserting) {
      context.missing(_drugClassMeta);
    }
    if (data.containsKey('default_dose')) {
      context.handle(
        _defaultDoseMeta,
        defaultDose.isAcceptableOrUnknown(
          data['default_dose']!,
          _defaultDoseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultDoseMeta);
    }
    if (data.containsKey('default_route')) {
      context.handle(
        _defaultRouteMeta,
        defaultRoute.isAcceptableOrUnknown(
          data['default_route']!,
          _defaultRouteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultRouteMeta);
    }
    if (data.containsKey('default_frequency')) {
      context.handle(
        _defaultFrequencyMeta,
        defaultFrequency.isAcceptableOrUnknown(
          data['default_frequency']!,
          _defaultFrequencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultFrequencyMeta);
    }
    if (data.containsKey('default_duration')) {
      context.handle(
        _defaultDurationMeta,
        defaultDuration.isAcceptableOrUnknown(
          data['default_duration']!,
          _defaultDurationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultDurationMeta);
    }
    if (data.containsKey('default_instructions')) {
      context.handle(
        _defaultInstructionsMeta,
        defaultInstructions.isAcceptableOrUnknown(
          data['default_instructions']!,
          _defaultInstructionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultInstructionsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DrugEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DrugEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      genericName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generic_name'],
      )!,
      brandName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_name'],
      )!,
      drugClass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drug_class'],
      )!,
      defaultDose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_dose'],
      )!,
      defaultRoute: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_route'],
      )!,
      defaultFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_frequency'],
      )!,
      defaultDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_duration'],
      )!,
      defaultInstructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_instructions'],
      )!,
    );
  }

  @override
  $DrugsTableTable createAlias(String alias) {
    return $DrugsTableTable(attachedDatabase, alias);
  }
}

class DrugEntry extends DataClass implements Insertable<DrugEntry> {
  final String id;
  final String genericName;
  final String brandName;
  final String drugClass;
  final String defaultDose;
  final String defaultRoute;
  final String defaultFrequency;
  final String defaultDuration;
  final String defaultInstructions;
  const DrugEntry({
    required this.id,
    required this.genericName,
    required this.brandName,
    required this.drugClass,
    required this.defaultDose,
    required this.defaultRoute,
    required this.defaultFrequency,
    required this.defaultDuration,
    required this.defaultInstructions,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['generic_name'] = Variable<String>(genericName);
    map['brand_name'] = Variable<String>(brandName);
    map['drug_class'] = Variable<String>(drugClass);
    map['default_dose'] = Variable<String>(defaultDose);
    map['default_route'] = Variable<String>(defaultRoute);
    map['default_frequency'] = Variable<String>(defaultFrequency);
    map['default_duration'] = Variable<String>(defaultDuration);
    map['default_instructions'] = Variable<String>(defaultInstructions);
    return map;
  }

  DrugsTableCompanion toCompanion(bool nullToAbsent) {
    return DrugsTableCompanion(
      id: Value(id),
      genericName: Value(genericName),
      brandName: Value(brandName),
      drugClass: Value(drugClass),
      defaultDose: Value(defaultDose),
      defaultRoute: Value(defaultRoute),
      defaultFrequency: Value(defaultFrequency),
      defaultDuration: Value(defaultDuration),
      defaultInstructions: Value(defaultInstructions),
    );
  }

  factory DrugEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DrugEntry(
      id: serializer.fromJson<String>(json['id']),
      genericName: serializer.fromJson<String>(json['genericName']),
      brandName: serializer.fromJson<String>(json['brandName']),
      drugClass: serializer.fromJson<String>(json['drugClass']),
      defaultDose: serializer.fromJson<String>(json['defaultDose']),
      defaultRoute: serializer.fromJson<String>(json['defaultRoute']),
      defaultFrequency: serializer.fromJson<String>(json['defaultFrequency']),
      defaultDuration: serializer.fromJson<String>(json['defaultDuration']),
      defaultInstructions: serializer.fromJson<String>(
        json['defaultInstructions'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'genericName': serializer.toJson<String>(genericName),
      'brandName': serializer.toJson<String>(brandName),
      'drugClass': serializer.toJson<String>(drugClass),
      'defaultDose': serializer.toJson<String>(defaultDose),
      'defaultRoute': serializer.toJson<String>(defaultRoute),
      'defaultFrequency': serializer.toJson<String>(defaultFrequency),
      'defaultDuration': serializer.toJson<String>(defaultDuration),
      'defaultInstructions': serializer.toJson<String>(defaultInstructions),
    };
  }

  DrugEntry copyWith({
    String? id,
    String? genericName,
    String? brandName,
    String? drugClass,
    String? defaultDose,
    String? defaultRoute,
    String? defaultFrequency,
    String? defaultDuration,
    String? defaultInstructions,
  }) => DrugEntry(
    id: id ?? this.id,
    genericName: genericName ?? this.genericName,
    brandName: brandName ?? this.brandName,
    drugClass: drugClass ?? this.drugClass,
    defaultDose: defaultDose ?? this.defaultDose,
    defaultRoute: defaultRoute ?? this.defaultRoute,
    defaultFrequency: defaultFrequency ?? this.defaultFrequency,
    defaultDuration: defaultDuration ?? this.defaultDuration,
    defaultInstructions: defaultInstructions ?? this.defaultInstructions,
  );
  DrugEntry copyWithCompanion(DrugsTableCompanion data) {
    return DrugEntry(
      id: data.id.present ? data.id.value : this.id,
      genericName: data.genericName.present
          ? data.genericName.value
          : this.genericName,
      brandName: data.brandName.present ? data.brandName.value : this.brandName,
      drugClass: data.drugClass.present ? data.drugClass.value : this.drugClass,
      defaultDose: data.defaultDose.present
          ? data.defaultDose.value
          : this.defaultDose,
      defaultRoute: data.defaultRoute.present
          ? data.defaultRoute.value
          : this.defaultRoute,
      defaultFrequency: data.defaultFrequency.present
          ? data.defaultFrequency.value
          : this.defaultFrequency,
      defaultDuration: data.defaultDuration.present
          ? data.defaultDuration.value
          : this.defaultDuration,
      defaultInstructions: data.defaultInstructions.present
          ? data.defaultInstructions.value
          : this.defaultInstructions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DrugEntry(')
          ..write('id: $id, ')
          ..write('genericName: $genericName, ')
          ..write('brandName: $brandName, ')
          ..write('drugClass: $drugClass, ')
          ..write('defaultDose: $defaultDose, ')
          ..write('defaultRoute: $defaultRoute, ')
          ..write('defaultFrequency: $defaultFrequency, ')
          ..write('defaultDuration: $defaultDuration, ')
          ..write('defaultInstructions: $defaultInstructions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    genericName,
    brandName,
    drugClass,
    defaultDose,
    defaultRoute,
    defaultFrequency,
    defaultDuration,
    defaultInstructions,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrugEntry &&
          other.id == this.id &&
          other.genericName == this.genericName &&
          other.brandName == this.brandName &&
          other.drugClass == this.drugClass &&
          other.defaultDose == this.defaultDose &&
          other.defaultRoute == this.defaultRoute &&
          other.defaultFrequency == this.defaultFrequency &&
          other.defaultDuration == this.defaultDuration &&
          other.defaultInstructions == this.defaultInstructions);
}

class DrugsTableCompanion extends UpdateCompanion<DrugEntry> {
  final Value<String> id;
  final Value<String> genericName;
  final Value<String> brandName;
  final Value<String> drugClass;
  final Value<String> defaultDose;
  final Value<String> defaultRoute;
  final Value<String> defaultFrequency;
  final Value<String> defaultDuration;
  final Value<String> defaultInstructions;
  final Value<int> rowid;
  const DrugsTableCompanion({
    this.id = const Value.absent(),
    this.genericName = const Value.absent(),
    this.brandName = const Value.absent(),
    this.drugClass = const Value.absent(),
    this.defaultDose = const Value.absent(),
    this.defaultRoute = const Value.absent(),
    this.defaultFrequency = const Value.absent(),
    this.defaultDuration = const Value.absent(),
    this.defaultInstructions = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DrugsTableCompanion.insert({
    required String id,
    required String genericName,
    required String brandName,
    required String drugClass,
    required String defaultDose,
    required String defaultRoute,
    required String defaultFrequency,
    required String defaultDuration,
    required String defaultInstructions,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       genericName = Value(genericName),
       brandName = Value(brandName),
       drugClass = Value(drugClass),
       defaultDose = Value(defaultDose),
       defaultRoute = Value(defaultRoute),
       defaultFrequency = Value(defaultFrequency),
       defaultDuration = Value(defaultDuration),
       defaultInstructions = Value(defaultInstructions);
  static Insertable<DrugEntry> custom({
    Expression<String>? id,
    Expression<String>? genericName,
    Expression<String>? brandName,
    Expression<String>? drugClass,
    Expression<String>? defaultDose,
    Expression<String>? defaultRoute,
    Expression<String>? defaultFrequency,
    Expression<String>? defaultDuration,
    Expression<String>? defaultInstructions,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (genericName != null) 'generic_name': genericName,
      if (brandName != null) 'brand_name': brandName,
      if (drugClass != null) 'drug_class': drugClass,
      if (defaultDose != null) 'default_dose': defaultDose,
      if (defaultRoute != null) 'default_route': defaultRoute,
      if (defaultFrequency != null) 'default_frequency': defaultFrequency,
      if (defaultDuration != null) 'default_duration': defaultDuration,
      if (defaultInstructions != null)
        'default_instructions': defaultInstructions,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DrugsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? genericName,
    Value<String>? brandName,
    Value<String>? drugClass,
    Value<String>? defaultDose,
    Value<String>? defaultRoute,
    Value<String>? defaultFrequency,
    Value<String>? defaultDuration,
    Value<String>? defaultInstructions,
    Value<int>? rowid,
  }) {
    return DrugsTableCompanion(
      id: id ?? this.id,
      genericName: genericName ?? this.genericName,
      brandName: brandName ?? this.brandName,
      drugClass: drugClass ?? this.drugClass,
      defaultDose: defaultDose ?? this.defaultDose,
      defaultRoute: defaultRoute ?? this.defaultRoute,
      defaultFrequency: defaultFrequency ?? this.defaultFrequency,
      defaultDuration: defaultDuration ?? this.defaultDuration,
      defaultInstructions: defaultInstructions ?? this.defaultInstructions,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (genericName.present) {
      map['generic_name'] = Variable<String>(genericName.value);
    }
    if (brandName.present) {
      map['brand_name'] = Variable<String>(brandName.value);
    }
    if (drugClass.present) {
      map['drug_class'] = Variable<String>(drugClass.value);
    }
    if (defaultDose.present) {
      map['default_dose'] = Variable<String>(defaultDose.value);
    }
    if (defaultRoute.present) {
      map['default_route'] = Variable<String>(defaultRoute.value);
    }
    if (defaultFrequency.present) {
      map['default_frequency'] = Variable<String>(defaultFrequency.value);
    }
    if (defaultDuration.present) {
      map['default_duration'] = Variable<String>(defaultDuration.value);
    }
    if (defaultInstructions.present) {
      map['default_instructions'] = Variable<String>(defaultInstructions.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrugsTableCompanion(')
          ..write('id: $id, ')
          ..write('genericName: $genericName, ')
          ..write('brandName: $brandName, ')
          ..write('drugClass: $drugClass, ')
          ..write('defaultDose: $defaultDose, ')
          ..write('defaultRoute: $defaultRoute, ')
          ..write('defaultFrequency: $defaultFrequency, ')
          ..write('defaultDuration: $defaultDuration, ')
          ..write('defaultInstructions: $defaultInstructions, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrescriptionProtocolsTableTable extends PrescriptionProtocolsTable
    with
        TableInfo<$PrescriptionProtocolsTableTable, PrescriptionProtocolEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrescriptionProtocolsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diagnosisIdMeta = const VerificationMeta(
    'diagnosisId',
  );
  @override
  late final GeneratedColumn<String> diagnosisId = GeneratedColumn<String>(
    'diagnosis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diagnoses_table (id)',
    ),
  );
  static const VerificationMeta _protocolItemsJsonMeta = const VerificationMeta(
    'protocolItemsJson',
  );
  @override
  late final GeneratedColumn<String> protocolItemsJson =
      GeneratedColumn<String>(
        'protocol_items_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _generalAdviceMeta = const VerificationMeta(
    'generalAdvice',
  );
  @override
  late final GeneratedColumn<String> generalAdvice = GeneratedColumn<String>(
    'general_advice',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diagnosisId,
    protocolItemsJson,
    generalAdvice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prescription_protocols_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrescriptionProtocolEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('diagnosis_id')) {
      context.handle(
        _diagnosisIdMeta,
        diagnosisId.isAcceptableOrUnknown(
          data['diagnosis_id']!,
          _diagnosisIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diagnosisIdMeta);
    }
    if (data.containsKey('protocol_items_json')) {
      context.handle(
        _protocolItemsJsonMeta,
        protocolItemsJson.isAcceptableOrUnknown(
          data['protocol_items_json']!,
          _protocolItemsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_protocolItemsJsonMeta);
    }
    if (data.containsKey('general_advice')) {
      context.handle(
        _generalAdviceMeta,
        generalAdvice.isAcceptableOrUnknown(
          data['general_advice']!,
          _generalAdviceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrescriptionProtocolEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrescriptionProtocolEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      diagnosisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnosis_id'],
      )!,
      protocolItemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocol_items_json'],
      )!,
      generalAdvice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}general_advice'],
      )!,
    );
  }

  @override
  $PrescriptionProtocolsTableTable createAlias(String alias) {
    return $PrescriptionProtocolsTableTable(attachedDatabase, alias);
  }
}

class PrescriptionProtocolEntry extends DataClass
    implements Insertable<PrescriptionProtocolEntry> {
  final String id;
  final String diagnosisId;
  final String protocolItemsJson;
  final String generalAdvice;
  const PrescriptionProtocolEntry({
    required this.id,
    required this.diagnosisId,
    required this.protocolItemsJson,
    required this.generalAdvice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['diagnosis_id'] = Variable<String>(diagnosisId);
    map['protocol_items_json'] = Variable<String>(protocolItemsJson);
    map['general_advice'] = Variable<String>(generalAdvice);
    return map;
  }

  PrescriptionProtocolsTableCompanion toCompanion(bool nullToAbsent) {
    return PrescriptionProtocolsTableCompanion(
      id: Value(id),
      diagnosisId: Value(diagnosisId),
      protocolItemsJson: Value(protocolItemsJson),
      generalAdvice: Value(generalAdvice),
    );
  }

  factory PrescriptionProtocolEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrescriptionProtocolEntry(
      id: serializer.fromJson<String>(json['id']),
      diagnosisId: serializer.fromJson<String>(json['diagnosisId']),
      protocolItemsJson: serializer.fromJson<String>(json['protocolItemsJson']),
      generalAdvice: serializer.fromJson<String>(json['generalAdvice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'diagnosisId': serializer.toJson<String>(diagnosisId),
      'protocolItemsJson': serializer.toJson<String>(protocolItemsJson),
      'generalAdvice': serializer.toJson<String>(generalAdvice),
    };
  }

  PrescriptionProtocolEntry copyWith({
    String? id,
    String? diagnosisId,
    String? protocolItemsJson,
    String? generalAdvice,
  }) => PrescriptionProtocolEntry(
    id: id ?? this.id,
    diagnosisId: diagnosisId ?? this.diagnosisId,
    protocolItemsJson: protocolItemsJson ?? this.protocolItemsJson,
    generalAdvice: generalAdvice ?? this.generalAdvice,
  );
  PrescriptionProtocolEntry copyWithCompanion(
    PrescriptionProtocolsTableCompanion data,
  ) {
    return PrescriptionProtocolEntry(
      id: data.id.present ? data.id.value : this.id,
      diagnosisId: data.diagnosisId.present
          ? data.diagnosisId.value
          : this.diagnosisId,
      protocolItemsJson: data.protocolItemsJson.present
          ? data.protocolItemsJson.value
          : this.protocolItemsJson,
      generalAdvice: data.generalAdvice.present
          ? data.generalAdvice.value
          : this.generalAdvice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrescriptionProtocolEntry(')
          ..write('id: $id, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('protocolItemsJson: $protocolItemsJson, ')
          ..write('generalAdvice: $generalAdvice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, diagnosisId, protocolItemsJson, generalAdvice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrescriptionProtocolEntry &&
          other.id == this.id &&
          other.diagnosisId == this.diagnosisId &&
          other.protocolItemsJson == this.protocolItemsJson &&
          other.generalAdvice == this.generalAdvice);
}

class PrescriptionProtocolsTableCompanion
    extends UpdateCompanion<PrescriptionProtocolEntry> {
  final Value<String> id;
  final Value<String> diagnosisId;
  final Value<String> protocolItemsJson;
  final Value<String> generalAdvice;
  final Value<int> rowid;
  const PrescriptionProtocolsTableCompanion({
    this.id = const Value.absent(),
    this.diagnosisId = const Value.absent(),
    this.protocolItemsJson = const Value.absent(),
    this.generalAdvice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrescriptionProtocolsTableCompanion.insert({
    required String id,
    required String diagnosisId,
    required String protocolItemsJson,
    this.generalAdvice = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       diagnosisId = Value(diagnosisId),
       protocolItemsJson = Value(protocolItemsJson);
  static Insertable<PrescriptionProtocolEntry> custom({
    Expression<String>? id,
    Expression<String>? diagnosisId,
    Expression<String>? protocolItemsJson,
    Expression<String>? generalAdvice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diagnosisId != null) 'diagnosis_id': diagnosisId,
      if (protocolItemsJson != null) 'protocol_items_json': protocolItemsJson,
      if (generalAdvice != null) 'general_advice': generalAdvice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrescriptionProtocolsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? diagnosisId,
    Value<String>? protocolItemsJson,
    Value<String>? generalAdvice,
    Value<int>? rowid,
  }) {
    return PrescriptionProtocolsTableCompanion(
      id: id ?? this.id,
      diagnosisId: diagnosisId ?? this.diagnosisId,
      protocolItemsJson: protocolItemsJson ?? this.protocolItemsJson,
      generalAdvice: generalAdvice ?? this.generalAdvice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (diagnosisId.present) {
      map['diagnosis_id'] = Variable<String>(diagnosisId.value);
    }
    if (protocolItemsJson.present) {
      map['protocol_items_json'] = Variable<String>(protocolItemsJson.value);
    }
    if (generalAdvice.present) {
      map['general_advice'] = Variable<String>(generalAdvice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrescriptionProtocolsTableCompanion(')
          ..write('id: $id, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('protocolItemsJson: $protocolItemsJson, ')
          ..write('generalAdvice: $generalAdvice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientQueueTableTable patientQueueTable =
      $PatientQueueTableTable(this);
  late final $ComorbiditiesTableTable comorbiditiesTable =
      $ComorbiditiesTableTable(this);
  late final $PresentingComplaintsTableTable presentingComplaintsTable =
      $PresentingComplaintsTableTable(this);
  late final $ComplaintSubQuestionsTableTable complaintSubQuestionsTable =
      $ComplaintSubQuestionsTableTable(this);
  late final $ExaminationSystemsTableTable examinationSystemsTable =
      $ExaminationSystemsTableTable(this);
  late final $DiagnosesTableTable diagnosesTable = $DiagnosesTableTable(this);
  late final $DrugsTableTable drugsTable = $DrugsTableTable(this);
  late final $PrescriptionProtocolsTableTable prescriptionProtocolsTable =
      $PrescriptionProtocolsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    patientQueueTable,
    comorbiditiesTable,
    presentingComplaintsTable,
    complaintSubQuestionsTable,
    examinationSystemsTable,
    diagnosesTable,
    drugsTable,
    prescriptionProtocolsTable,
  ];
}

typedef $$PatientQueueTableTableCreateCompanionBuilder =
    PatientQueueTableCompanion Function({
      required String id,
      Value<String?> patientId,
      required int tokenNumber,
      required String patientName,
      required int age,
      required String gender,
      Value<String?> phone,
      Value<String?> vitalsJson,
      Value<String?> initialComorbIds,
      Value<String?> allergies,
      Value<String?> lmp,
      Value<bool> isPregnant,
      required String status,
      required DateTime entryTime,
      Value<DateTime?> consultationStartTime,
      Value<DateTime?> completionTime,
      Value<String?> compiledPrescriptionJson,
      Value<int> rowid,
    });
typedef $$PatientQueueTableTableUpdateCompanionBuilder =
    PatientQueueTableCompanion Function({
      Value<String> id,
      Value<String?> patientId,
      Value<int> tokenNumber,
      Value<String> patientName,
      Value<int> age,
      Value<String> gender,
      Value<String?> phone,
      Value<String?> vitalsJson,
      Value<String?> initialComorbIds,
      Value<String?> allergies,
      Value<String?> lmp,
      Value<bool> isPregnant,
      Value<String> status,
      Value<DateTime> entryTime,
      Value<DateTime?> consultationStartTime,
      Value<DateTime?> completionTime,
      Value<String?> compiledPrescriptionJson,
      Value<int> rowid,
    });

class $$PatientQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $PatientQueueTableTable> {
  $$PatientQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tokenNumber => $composableBuilder(
    column: $table.tokenNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patientName => $composableBuilder(
    column: $table.patientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vitalsJson => $composableBuilder(
    column: $table.vitalsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initialComorbIds => $composableBuilder(
    column: $table.initialComorbIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lmp => $composableBuilder(
    column: $table.lmp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPregnant => $composableBuilder(
    column: $table.isPregnant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryTime => $composableBuilder(
    column: $table.entryTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get consultationStartTime => $composableBuilder(
    column: $table.consultationStartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completionTime => $composableBuilder(
    column: $table.completionTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get compiledPrescriptionJson => $composableBuilder(
    column: $table.compiledPrescriptionJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PatientQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientQueueTableTable> {
  $$PatientQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientId => $composableBuilder(
    column: $table.patientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tokenNumber => $composableBuilder(
    column: $table.tokenNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patientName => $composableBuilder(
    column: $table.patientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vitalsJson => $composableBuilder(
    column: $table.vitalsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initialComorbIds => $composableBuilder(
    column: $table.initialComorbIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lmp => $composableBuilder(
    column: $table.lmp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPregnant => $composableBuilder(
    column: $table.isPregnant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryTime => $composableBuilder(
    column: $table.entryTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get consultationStartTime => $composableBuilder(
    column: $table.consultationStartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completionTime => $composableBuilder(
    column: $table.completionTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get compiledPrescriptionJson => $composableBuilder(
    column: $table.compiledPrescriptionJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatientQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientQueueTableTable> {
  $$PatientQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<int> get tokenNumber => $composableBuilder(
    column: $table.tokenNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get patientName => $composableBuilder(
    column: $table.patientName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get vitalsJson => $composableBuilder(
    column: $table.vitalsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get initialComorbIds => $composableBuilder(
    column: $table.initialComorbIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get lmp =>
      $composableBuilder(column: $table.lmp, builder: (column) => column);

  GeneratedColumn<bool> get isPregnant => $composableBuilder(
    column: $table.isPregnant,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get entryTime =>
      $composableBuilder(column: $table.entryTime, builder: (column) => column);

  GeneratedColumn<DateTime> get consultationStartTime => $composableBuilder(
    column: $table.consultationStartTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completionTime => $composableBuilder(
    column: $table.completionTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get compiledPrescriptionJson => $composableBuilder(
    column: $table.compiledPrescriptionJson,
    builder: (column) => column,
  );
}

class $$PatientQueueTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatientQueueTableTable,
          PatientQueueEntry,
          $$PatientQueueTableTableFilterComposer,
          $$PatientQueueTableTableOrderingComposer,
          $$PatientQueueTableTableAnnotationComposer,
          $$PatientQueueTableTableCreateCompanionBuilder,
          $$PatientQueueTableTableUpdateCompanionBuilder,
          (
            PatientQueueEntry,
            BaseReferences<
              _$AppDatabase,
              $PatientQueueTableTable,
              PatientQueueEntry
            >,
          ),
          PatientQueueEntry,
          PrefetchHooks Function()
        > {
  $$PatientQueueTableTableTableManager(
    _$AppDatabase db,
    $PatientQueueTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientQueueTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> patientId = const Value.absent(),
                Value<int> tokenNumber = const Value.absent(),
                Value<String> patientName = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> vitalsJson = const Value.absent(),
                Value<String?> initialComorbIds = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<String?> lmp = const Value.absent(),
                Value<bool> isPregnant = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> entryTime = const Value.absent(),
                Value<DateTime?> consultationStartTime = const Value.absent(),
                Value<DateTime?> completionTime = const Value.absent(),
                Value<String?> compiledPrescriptionJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatientQueueTableCompanion(
                id: id,
                patientId: patientId,
                tokenNumber: tokenNumber,
                patientName: patientName,
                age: age,
                gender: gender,
                phone: phone,
                vitalsJson: vitalsJson,
                initialComorbIds: initialComorbIds,
                allergies: allergies,
                lmp: lmp,
                isPregnant: isPregnant,
                status: status,
                entryTime: entryTime,
                consultationStartTime: consultationStartTime,
                completionTime: completionTime,
                compiledPrescriptionJson: compiledPrescriptionJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> patientId = const Value.absent(),
                required int tokenNumber,
                required String patientName,
                required int age,
                required String gender,
                Value<String?> phone = const Value.absent(),
                Value<String?> vitalsJson = const Value.absent(),
                Value<String?> initialComorbIds = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<String?> lmp = const Value.absent(),
                Value<bool> isPregnant = const Value.absent(),
                required String status,
                required DateTime entryTime,
                Value<DateTime?> consultationStartTime = const Value.absent(),
                Value<DateTime?> completionTime = const Value.absent(),
                Value<String?> compiledPrescriptionJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatientQueueTableCompanion.insert(
                id: id,
                patientId: patientId,
                tokenNumber: tokenNumber,
                patientName: patientName,
                age: age,
                gender: gender,
                phone: phone,
                vitalsJson: vitalsJson,
                initialComorbIds: initialComorbIds,
                allergies: allergies,
                lmp: lmp,
                isPregnant: isPregnant,
                status: status,
                entryTime: entryTime,
                consultationStartTime: consultationStartTime,
                completionTime: completionTime,
                compiledPrescriptionJson: compiledPrescriptionJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PatientQueueTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatientQueueTableTable,
      PatientQueueEntry,
      $$PatientQueueTableTableFilterComposer,
      $$PatientQueueTableTableOrderingComposer,
      $$PatientQueueTableTableAnnotationComposer,
      $$PatientQueueTableTableCreateCompanionBuilder,
      $$PatientQueueTableTableUpdateCompanionBuilder,
      (
        PatientQueueEntry,
        BaseReferences<
          _$AppDatabase,
          $PatientQueueTableTable,
          PatientQueueEntry
        >,
      ),
      PatientQueueEntry,
      PrefetchHooks Function()
    >;
typedef $$ComorbiditiesTableTableCreateCompanionBuilder =
    ComorbiditiesTableCompanion Function({
      required String id,
      required String name,
      required String contraindicatedDrugClasses,
      Value<int> rowid,
    });
typedef $$ComorbiditiesTableTableUpdateCompanionBuilder =
    ComorbiditiesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> contraindicatedDrugClasses,
      Value<int> rowid,
    });

class $$ComorbiditiesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ComorbiditiesTableTable> {
  $$ComorbiditiesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contraindicatedDrugClasses => $composableBuilder(
    column: $table.contraindicatedDrugClasses,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ComorbiditiesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ComorbiditiesTableTable> {
  $$ComorbiditiesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contraindicatedDrugClasses => $composableBuilder(
    column: $table.contraindicatedDrugClasses,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ComorbiditiesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComorbiditiesTableTable> {
  $$ComorbiditiesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contraindicatedDrugClasses => $composableBuilder(
    column: $table.contraindicatedDrugClasses,
    builder: (column) => column,
  );
}

class $$ComorbiditiesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComorbiditiesTableTable,
          ComorbidityEntry,
          $$ComorbiditiesTableTableFilterComposer,
          $$ComorbiditiesTableTableOrderingComposer,
          $$ComorbiditiesTableTableAnnotationComposer,
          $$ComorbiditiesTableTableCreateCompanionBuilder,
          $$ComorbiditiesTableTableUpdateCompanionBuilder,
          (
            ComorbidityEntry,
            BaseReferences<
              _$AppDatabase,
              $ComorbiditiesTableTable,
              ComorbidityEntry
            >,
          ),
          ComorbidityEntry,
          PrefetchHooks Function()
        > {
  $$ComorbiditiesTableTableTableManager(
    _$AppDatabase db,
    $ComorbiditiesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComorbiditiesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComorbiditiesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComorbiditiesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> contraindicatedDrugClasses = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComorbiditiesTableCompanion(
                id: id,
                name: name,
                contraindicatedDrugClasses: contraindicatedDrugClasses,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String contraindicatedDrugClasses,
                Value<int> rowid = const Value.absent(),
              }) => ComorbiditiesTableCompanion.insert(
                id: id,
                name: name,
                contraindicatedDrugClasses: contraindicatedDrugClasses,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ComorbiditiesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComorbiditiesTableTable,
      ComorbidityEntry,
      $$ComorbiditiesTableTableFilterComposer,
      $$ComorbiditiesTableTableOrderingComposer,
      $$ComorbiditiesTableTableAnnotationComposer,
      $$ComorbiditiesTableTableCreateCompanionBuilder,
      $$ComorbiditiesTableTableUpdateCompanionBuilder,
      (
        ComorbidityEntry,
        BaseReferences<
          _$AppDatabase,
          $ComorbiditiesTableTable,
          ComorbidityEntry
        >,
      ),
      ComorbidityEntry,
      PrefetchHooks Function()
    >;
typedef $$PresentingComplaintsTableTableCreateCompanionBuilder =
    PresentingComplaintsTableCompanion Function({
      required String id,
      required String name,
      required String category,
      Value<int> displayOrder,
      Value<int> rowid,
    });
typedef $$PresentingComplaintsTableTableUpdateCompanionBuilder =
    PresentingComplaintsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<int> displayOrder,
      Value<int> rowid,
    });

final class $$PresentingComplaintsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PresentingComplaintsTableTable,
          PresentingComplaintEntry
        > {
  $$PresentingComplaintsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ComplaintSubQuestionsTableTable,
    List<ComplaintSubQuestionEntry>
  >
  _complaintSubQuestionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.complaintSubQuestionsTable,
        aliasName: $_aliasNameGenerator(
          db.presentingComplaintsTable.id,
          db.complaintSubQuestionsTable.complaintId,
        ),
      );

  $$ComplaintSubQuestionsTableTableProcessedTableManager
  get complaintSubQuestionsTableRefs {
    final manager = $$ComplaintSubQuestionsTableTableTableManager(
      $_db,
      $_db.complaintSubQuestionsTable,
    ).filter((f) => f.complaintId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _complaintSubQuestionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PresentingComplaintsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PresentingComplaintsTableTable> {
  $$PresentingComplaintsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> complaintSubQuestionsTableRefs(
    Expression<bool> Function($$ComplaintSubQuestionsTableTableFilterComposer f)
    f,
  ) {
    final $$ComplaintSubQuestionsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.complaintSubQuestionsTable,
          getReferencedColumn: (t) => t.complaintId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ComplaintSubQuestionsTableTableFilterComposer(
                $db: $db,
                $table: $db.complaintSubQuestionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PresentingComplaintsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PresentingComplaintsTableTable> {
  $$PresentingComplaintsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PresentingComplaintsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresentingComplaintsTableTable> {
  $$PresentingComplaintsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  Expression<T> complaintSubQuestionsTableRefs<T extends Object>(
    Expression<T> Function(
      $$ComplaintSubQuestionsTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$ComplaintSubQuestionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.complaintSubQuestionsTable,
          getReferencedColumn: (t) => t.complaintId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ComplaintSubQuestionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.complaintSubQuestionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PresentingComplaintsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresentingComplaintsTableTable,
          PresentingComplaintEntry,
          $$PresentingComplaintsTableTableFilterComposer,
          $$PresentingComplaintsTableTableOrderingComposer,
          $$PresentingComplaintsTableTableAnnotationComposer,
          $$PresentingComplaintsTableTableCreateCompanionBuilder,
          $$PresentingComplaintsTableTableUpdateCompanionBuilder,
          (
            PresentingComplaintEntry,
            $$PresentingComplaintsTableTableReferences,
          ),
          PresentingComplaintEntry,
          PrefetchHooks Function({bool complaintSubQuestionsTableRefs})
        > {
  $$PresentingComplaintsTableTableTableManager(
    _$AppDatabase db,
    $PresentingComplaintsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresentingComplaintsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PresentingComplaintsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PresentingComplaintsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PresentingComplaintsTableCompanion(
                id: id,
                name: name,
                category: category,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PresentingComplaintsTableCompanion.insert(
                id: id,
                name: name,
                category: category,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PresentingComplaintsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({complaintSubQuestionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (complaintSubQuestionsTableRefs)
                  db.complaintSubQuestionsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (complaintSubQuestionsTableRefs)
                    await $_getPrefetchedData<
                      PresentingComplaintEntry,
                      $PresentingComplaintsTableTable,
                      ComplaintSubQuestionEntry
                    >(
                      currentTable: table,
                      referencedTable:
                          $$PresentingComplaintsTableTableReferences
                              ._complaintSubQuestionsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PresentingComplaintsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).complaintSubQuestionsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.complaintId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PresentingComplaintsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresentingComplaintsTableTable,
      PresentingComplaintEntry,
      $$PresentingComplaintsTableTableFilterComposer,
      $$PresentingComplaintsTableTableOrderingComposer,
      $$PresentingComplaintsTableTableAnnotationComposer,
      $$PresentingComplaintsTableTableCreateCompanionBuilder,
      $$PresentingComplaintsTableTableUpdateCompanionBuilder,
      (PresentingComplaintEntry, $$PresentingComplaintsTableTableReferences),
      PresentingComplaintEntry,
      PrefetchHooks Function({bool complaintSubQuestionsTableRefs})
    >;
typedef $$ComplaintSubQuestionsTableTableCreateCompanionBuilder =
    ComplaintSubQuestionsTableCompanion Function({
      required String id,
      required String complaintId,
      required String questionLabel,
      required String optionsJson,
      Value<String> sentenceTemplate,
      Value<bool> isMultiSelect,
      Value<int> sequenceOrder,
      Value<int> rowid,
    });
typedef $$ComplaintSubQuestionsTableTableUpdateCompanionBuilder =
    ComplaintSubQuestionsTableCompanion Function({
      Value<String> id,
      Value<String> complaintId,
      Value<String> questionLabel,
      Value<String> optionsJson,
      Value<String> sentenceTemplate,
      Value<bool> isMultiSelect,
      Value<int> sequenceOrder,
      Value<int> rowid,
    });

final class $$ComplaintSubQuestionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ComplaintSubQuestionsTableTable,
          ComplaintSubQuestionEntry
        > {
  $$ComplaintSubQuestionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PresentingComplaintsTableTable _complaintIdTable(_$AppDatabase db) =>
      db.presentingComplaintsTable.createAlias(
        $_aliasNameGenerator(
          db.complaintSubQuestionsTable.complaintId,
          db.presentingComplaintsTable.id,
        ),
      );

  $$PresentingComplaintsTableTableProcessedTableManager get complaintId {
    final $_column = $_itemColumn<String>('complaint_id')!;

    final manager = $$PresentingComplaintsTableTableTableManager(
      $_db,
      $_db.presentingComplaintsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_complaintIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ComplaintSubQuestionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ComplaintSubQuestionsTableTable> {
  $$ComplaintSubQuestionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionLabel => $composableBuilder(
    column: $table.questionLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sentenceTemplate => $composableBuilder(
    column: $table.sentenceTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMultiSelect => $composableBuilder(
    column: $table.isMultiSelect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceOrder => $composableBuilder(
    column: $table.sequenceOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$PresentingComplaintsTableTableFilterComposer get complaintId {
    final $$PresentingComplaintsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.complaintId,
          referencedTable: $db.presentingComplaintsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PresentingComplaintsTableTableFilterComposer(
                $db: $db,
                $table: $db.presentingComplaintsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ComplaintSubQuestionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ComplaintSubQuestionsTableTable> {
  $$ComplaintSubQuestionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionLabel => $composableBuilder(
    column: $table.questionLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sentenceTemplate => $composableBuilder(
    column: $table.sentenceTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMultiSelect => $composableBuilder(
    column: $table.isMultiSelect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceOrder => $composableBuilder(
    column: $table.sequenceOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$PresentingComplaintsTableTableOrderingComposer get complaintId {
    final $$PresentingComplaintsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.complaintId,
          referencedTable: $db.presentingComplaintsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PresentingComplaintsTableTableOrderingComposer(
                $db: $db,
                $table: $db.presentingComplaintsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ComplaintSubQuestionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComplaintSubQuestionsTableTable> {
  $$ComplaintSubQuestionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questionLabel => $composableBuilder(
    column: $table.questionLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sentenceTemplate => $composableBuilder(
    column: $table.sentenceTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMultiSelect => $composableBuilder(
    column: $table.isMultiSelect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sequenceOrder => $composableBuilder(
    column: $table.sequenceOrder,
    builder: (column) => column,
  );

  $$PresentingComplaintsTableTableAnnotationComposer get complaintId {
    final $$PresentingComplaintsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.complaintId,
          referencedTable: $db.presentingComplaintsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PresentingComplaintsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.presentingComplaintsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ComplaintSubQuestionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComplaintSubQuestionsTableTable,
          ComplaintSubQuestionEntry,
          $$ComplaintSubQuestionsTableTableFilterComposer,
          $$ComplaintSubQuestionsTableTableOrderingComposer,
          $$ComplaintSubQuestionsTableTableAnnotationComposer,
          $$ComplaintSubQuestionsTableTableCreateCompanionBuilder,
          $$ComplaintSubQuestionsTableTableUpdateCompanionBuilder,
          (
            ComplaintSubQuestionEntry,
            $$ComplaintSubQuestionsTableTableReferences,
          ),
          ComplaintSubQuestionEntry,
          PrefetchHooks Function({bool complaintId})
        > {
  $$ComplaintSubQuestionsTableTableTableManager(
    _$AppDatabase db,
    $ComplaintSubQuestionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComplaintSubQuestionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ComplaintSubQuestionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ComplaintSubQuestionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> complaintId = const Value.absent(),
                Value<String> questionLabel = const Value.absent(),
                Value<String> optionsJson = const Value.absent(),
                Value<String> sentenceTemplate = const Value.absent(),
                Value<bool> isMultiSelect = const Value.absent(),
                Value<int> sequenceOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComplaintSubQuestionsTableCompanion(
                id: id,
                complaintId: complaintId,
                questionLabel: questionLabel,
                optionsJson: optionsJson,
                sentenceTemplate: sentenceTemplate,
                isMultiSelect: isMultiSelect,
                sequenceOrder: sequenceOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String complaintId,
                required String questionLabel,
                required String optionsJson,
                Value<String> sentenceTemplate = const Value.absent(),
                Value<bool> isMultiSelect = const Value.absent(),
                Value<int> sequenceOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComplaintSubQuestionsTableCompanion.insert(
                id: id,
                complaintId: complaintId,
                questionLabel: questionLabel,
                optionsJson: optionsJson,
                sentenceTemplate: sentenceTemplate,
                isMultiSelect: isMultiSelect,
                sequenceOrder: sequenceOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ComplaintSubQuestionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({complaintId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (complaintId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.complaintId,
                                referencedTable:
                                    $$ComplaintSubQuestionsTableTableReferences
                                        ._complaintIdTable(db),
                                referencedColumn:
                                    $$ComplaintSubQuestionsTableTableReferences
                                        ._complaintIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ComplaintSubQuestionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComplaintSubQuestionsTableTable,
      ComplaintSubQuestionEntry,
      $$ComplaintSubQuestionsTableTableFilterComposer,
      $$ComplaintSubQuestionsTableTableOrderingComposer,
      $$ComplaintSubQuestionsTableTableAnnotationComposer,
      $$ComplaintSubQuestionsTableTableCreateCompanionBuilder,
      $$ComplaintSubQuestionsTableTableUpdateCompanionBuilder,
      (ComplaintSubQuestionEntry, $$ComplaintSubQuestionsTableTableReferences),
      ComplaintSubQuestionEntry,
      PrefetchHooks Function({bool complaintId})
    >;
typedef $$ExaminationSystemsTableTableCreateCompanionBuilder =
    ExaminationSystemsTableCompanion Function({
      required String id,
      required String systemName,
      required String defaultNormalText,
      required String abnormalFindingsJson,
      Value<int> rowid,
    });
typedef $$ExaminationSystemsTableTableUpdateCompanionBuilder =
    ExaminationSystemsTableCompanion Function({
      Value<String> id,
      Value<String> systemName,
      Value<String> defaultNormalText,
      Value<String> abnormalFindingsJson,
      Value<int> rowid,
    });

class $$ExaminationSystemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExaminationSystemsTableTable> {
  $$ExaminationSystemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get systemName => $composableBuilder(
    column: $table.systemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultNormalText => $composableBuilder(
    column: $table.defaultNormalText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abnormalFindingsJson => $composableBuilder(
    column: $table.abnormalFindingsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExaminationSystemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExaminationSystemsTableTable> {
  $$ExaminationSystemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get systemName => $composableBuilder(
    column: $table.systemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultNormalText => $composableBuilder(
    column: $table.defaultNormalText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abnormalFindingsJson => $composableBuilder(
    column: $table.abnormalFindingsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExaminationSystemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExaminationSystemsTableTable> {
  $$ExaminationSystemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get systemName => $composableBuilder(
    column: $table.systemName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultNormalText => $composableBuilder(
    column: $table.defaultNormalText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get abnormalFindingsJson => $composableBuilder(
    column: $table.abnormalFindingsJson,
    builder: (column) => column,
  );
}

class $$ExaminationSystemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExaminationSystemsTableTable,
          ExaminationSystemEntry,
          $$ExaminationSystemsTableTableFilterComposer,
          $$ExaminationSystemsTableTableOrderingComposer,
          $$ExaminationSystemsTableTableAnnotationComposer,
          $$ExaminationSystemsTableTableCreateCompanionBuilder,
          $$ExaminationSystemsTableTableUpdateCompanionBuilder,
          (
            ExaminationSystemEntry,
            BaseReferences<
              _$AppDatabase,
              $ExaminationSystemsTableTable,
              ExaminationSystemEntry
            >,
          ),
          ExaminationSystemEntry,
          PrefetchHooks Function()
        > {
  $$ExaminationSystemsTableTableTableManager(
    _$AppDatabase db,
    $ExaminationSystemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExaminationSystemsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ExaminationSystemsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExaminationSystemsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> systemName = const Value.absent(),
                Value<String> defaultNormalText = const Value.absent(),
                Value<String> abnormalFindingsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExaminationSystemsTableCompanion(
                id: id,
                systemName: systemName,
                defaultNormalText: defaultNormalText,
                abnormalFindingsJson: abnormalFindingsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String systemName,
                required String defaultNormalText,
                required String abnormalFindingsJson,
                Value<int> rowid = const Value.absent(),
              }) => ExaminationSystemsTableCompanion.insert(
                id: id,
                systemName: systemName,
                defaultNormalText: defaultNormalText,
                abnormalFindingsJson: abnormalFindingsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExaminationSystemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExaminationSystemsTableTable,
      ExaminationSystemEntry,
      $$ExaminationSystemsTableTableFilterComposer,
      $$ExaminationSystemsTableTableOrderingComposer,
      $$ExaminationSystemsTableTableAnnotationComposer,
      $$ExaminationSystemsTableTableCreateCompanionBuilder,
      $$ExaminationSystemsTableTableUpdateCompanionBuilder,
      (
        ExaminationSystemEntry,
        BaseReferences<
          _$AppDatabase,
          $ExaminationSystemsTableTable,
          ExaminationSystemEntry
        >,
      ),
      ExaminationSystemEntry,
      PrefetchHooks Function()
    >;
typedef $$DiagnosesTableTableCreateCompanionBuilder =
    DiagnosesTableCompanion Function({
      required String id,
      required String name,
      Value<String?> icd10Code,
      required String linkedComplaintIds,
      Value<int> rowid,
    });
typedef $$DiagnosesTableTableUpdateCompanionBuilder =
    DiagnosesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> icd10Code,
      Value<String> linkedComplaintIds,
      Value<int> rowid,
    });

final class $$DiagnosesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $DiagnosesTableTable, DiagnosisEntry> {
  $$DiagnosesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $PrescriptionProtocolsTableTable,
    List<PrescriptionProtocolEntry>
  >
  _prescriptionProtocolsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.prescriptionProtocolsTable,
        aliasName: $_aliasNameGenerator(
          db.diagnosesTable.id,
          db.prescriptionProtocolsTable.diagnosisId,
        ),
      );

  $$PrescriptionProtocolsTableTableProcessedTableManager
  get prescriptionProtocolsTableRefs {
    final manager = $$PrescriptionProtocolsTableTableTableManager(
      $_db,
      $_db.prescriptionProtocolsTable,
    ).filter((f) => f.diagnosisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _prescriptionProtocolsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DiagnosesTableTableFilterComposer
    extends Composer<_$AppDatabase, $DiagnosesTableTable> {
  $$DiagnosesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icd10Code => $composableBuilder(
    column: $table.icd10Code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedComplaintIds => $composableBuilder(
    column: $table.linkedComplaintIds,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> prescriptionProtocolsTableRefs(
    Expression<bool> Function($$PrescriptionProtocolsTableTableFilterComposer f)
    f,
  ) {
    final $$PrescriptionProtocolsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.prescriptionProtocolsTable,
          getReferencedColumn: (t) => t.diagnosisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PrescriptionProtocolsTableTableFilterComposer(
                $db: $db,
                $table: $db.prescriptionProtocolsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DiagnosesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DiagnosesTableTable> {
  $$DiagnosesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icd10Code => $composableBuilder(
    column: $table.icd10Code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedComplaintIds => $composableBuilder(
    column: $table.linkedComplaintIds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiagnosesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiagnosesTableTable> {
  $$DiagnosesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icd10Code =>
      $composableBuilder(column: $table.icd10Code, builder: (column) => column);

  GeneratedColumn<String> get linkedComplaintIds => $composableBuilder(
    column: $table.linkedComplaintIds,
    builder: (column) => column,
  );

  Expression<T> prescriptionProtocolsTableRefs<T extends Object>(
    Expression<T> Function(
      $$PrescriptionProtocolsTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$PrescriptionProtocolsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.prescriptionProtocolsTable,
          getReferencedColumn: (t) => t.diagnosisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PrescriptionProtocolsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.prescriptionProtocolsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DiagnosesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiagnosesTableTable,
          DiagnosisEntry,
          $$DiagnosesTableTableFilterComposer,
          $$DiagnosesTableTableOrderingComposer,
          $$DiagnosesTableTableAnnotationComposer,
          $$DiagnosesTableTableCreateCompanionBuilder,
          $$DiagnosesTableTableUpdateCompanionBuilder,
          (DiagnosisEntry, $$DiagnosesTableTableReferences),
          DiagnosisEntry,
          PrefetchHooks Function({bool prescriptionProtocolsTableRefs})
        > {
  $$DiagnosesTableTableTableManager(
    _$AppDatabase db,
    $DiagnosesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiagnosesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiagnosesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiagnosesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icd10Code = const Value.absent(),
                Value<String> linkedComplaintIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiagnosesTableCompanion(
                id: id,
                name: name,
                icd10Code: icd10Code,
                linkedComplaintIds: linkedComplaintIds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> icd10Code = const Value.absent(),
                required String linkedComplaintIds,
                Value<int> rowid = const Value.absent(),
              }) => DiagnosesTableCompanion.insert(
                id: id,
                name: name,
                icd10Code: icd10Code,
                linkedComplaintIds: linkedComplaintIds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiagnosesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({prescriptionProtocolsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (prescriptionProtocolsTableRefs)
                  db.prescriptionProtocolsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (prescriptionProtocolsTableRefs)
                    await $_getPrefetchedData<
                      DiagnosisEntry,
                      $DiagnosesTableTable,
                      PrescriptionProtocolEntry
                    >(
                      currentTable: table,
                      referencedTable: $$DiagnosesTableTableReferences
                          ._prescriptionProtocolsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DiagnosesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).prescriptionProtocolsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.diagnosisId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DiagnosesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiagnosesTableTable,
      DiagnosisEntry,
      $$DiagnosesTableTableFilterComposer,
      $$DiagnosesTableTableOrderingComposer,
      $$DiagnosesTableTableAnnotationComposer,
      $$DiagnosesTableTableCreateCompanionBuilder,
      $$DiagnosesTableTableUpdateCompanionBuilder,
      (DiagnosisEntry, $$DiagnosesTableTableReferences),
      DiagnosisEntry,
      PrefetchHooks Function({bool prescriptionProtocolsTableRefs})
    >;
typedef $$DrugsTableTableCreateCompanionBuilder =
    DrugsTableCompanion Function({
      required String id,
      required String genericName,
      required String brandName,
      required String drugClass,
      required String defaultDose,
      required String defaultRoute,
      required String defaultFrequency,
      required String defaultDuration,
      required String defaultInstructions,
      Value<int> rowid,
    });
typedef $$DrugsTableTableUpdateCompanionBuilder =
    DrugsTableCompanion Function({
      Value<String> id,
      Value<String> genericName,
      Value<String> brandName,
      Value<String> drugClass,
      Value<String> defaultDose,
      Value<String> defaultRoute,
      Value<String> defaultFrequency,
      Value<String> defaultDuration,
      Value<String> defaultInstructions,
      Value<int> rowid,
    });

class $$DrugsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DrugsTableTable> {
  $$DrugsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get drugClass => $composableBuilder(
    column: $table.drugClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultDose => $composableBuilder(
    column: $table.defaultDose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultRoute => $composableBuilder(
    column: $table.defaultRoute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultFrequency => $composableBuilder(
    column: $table.defaultFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultDuration => $composableBuilder(
    column: $table.defaultDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultInstructions => $composableBuilder(
    column: $table.defaultInstructions,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DrugsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DrugsTableTable> {
  $$DrugsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get drugClass => $composableBuilder(
    column: $table.drugClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultDose => $composableBuilder(
    column: $table.defaultDose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultRoute => $composableBuilder(
    column: $table.defaultRoute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultFrequency => $composableBuilder(
    column: $table.defaultFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultDuration => $composableBuilder(
    column: $table.defaultDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultInstructions => $composableBuilder(
    column: $table.defaultInstructions,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DrugsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DrugsTableTable> {
  $$DrugsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brandName =>
      $composableBuilder(column: $table.brandName, builder: (column) => column);

  GeneratedColumn<String> get drugClass =>
      $composableBuilder(column: $table.drugClass, builder: (column) => column);

  GeneratedColumn<String> get defaultDose => $composableBuilder(
    column: $table.defaultDose,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultRoute => $composableBuilder(
    column: $table.defaultRoute,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultFrequency => $composableBuilder(
    column: $table.defaultFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultDuration => $composableBuilder(
    column: $table.defaultDuration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultInstructions => $composableBuilder(
    column: $table.defaultInstructions,
    builder: (column) => column,
  );
}

class $$DrugsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DrugsTableTable,
          DrugEntry,
          $$DrugsTableTableFilterComposer,
          $$DrugsTableTableOrderingComposer,
          $$DrugsTableTableAnnotationComposer,
          $$DrugsTableTableCreateCompanionBuilder,
          $$DrugsTableTableUpdateCompanionBuilder,
          (
            DrugEntry,
            BaseReferences<_$AppDatabase, $DrugsTableTable, DrugEntry>,
          ),
          DrugEntry,
          PrefetchHooks Function()
        > {
  $$DrugsTableTableTableManager(_$AppDatabase db, $DrugsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DrugsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DrugsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DrugsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> genericName = const Value.absent(),
                Value<String> brandName = const Value.absent(),
                Value<String> drugClass = const Value.absent(),
                Value<String> defaultDose = const Value.absent(),
                Value<String> defaultRoute = const Value.absent(),
                Value<String> defaultFrequency = const Value.absent(),
                Value<String> defaultDuration = const Value.absent(),
                Value<String> defaultInstructions = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DrugsTableCompanion(
                id: id,
                genericName: genericName,
                brandName: brandName,
                drugClass: drugClass,
                defaultDose: defaultDose,
                defaultRoute: defaultRoute,
                defaultFrequency: defaultFrequency,
                defaultDuration: defaultDuration,
                defaultInstructions: defaultInstructions,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String genericName,
                required String brandName,
                required String drugClass,
                required String defaultDose,
                required String defaultRoute,
                required String defaultFrequency,
                required String defaultDuration,
                required String defaultInstructions,
                Value<int> rowid = const Value.absent(),
              }) => DrugsTableCompanion.insert(
                id: id,
                genericName: genericName,
                brandName: brandName,
                drugClass: drugClass,
                defaultDose: defaultDose,
                defaultRoute: defaultRoute,
                defaultFrequency: defaultFrequency,
                defaultDuration: defaultDuration,
                defaultInstructions: defaultInstructions,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DrugsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DrugsTableTable,
      DrugEntry,
      $$DrugsTableTableFilterComposer,
      $$DrugsTableTableOrderingComposer,
      $$DrugsTableTableAnnotationComposer,
      $$DrugsTableTableCreateCompanionBuilder,
      $$DrugsTableTableUpdateCompanionBuilder,
      (DrugEntry, BaseReferences<_$AppDatabase, $DrugsTableTable, DrugEntry>),
      DrugEntry,
      PrefetchHooks Function()
    >;
typedef $$PrescriptionProtocolsTableTableCreateCompanionBuilder =
    PrescriptionProtocolsTableCompanion Function({
      required String id,
      required String diagnosisId,
      required String protocolItemsJson,
      Value<String> generalAdvice,
      Value<int> rowid,
    });
typedef $$PrescriptionProtocolsTableTableUpdateCompanionBuilder =
    PrescriptionProtocolsTableCompanion Function({
      Value<String> id,
      Value<String> diagnosisId,
      Value<String> protocolItemsJson,
      Value<String> generalAdvice,
      Value<int> rowid,
    });

final class $$PrescriptionProtocolsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PrescriptionProtocolsTableTable,
          PrescriptionProtocolEntry
        > {
  $$PrescriptionProtocolsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DiagnosesTableTable _diagnosisIdTable(_$AppDatabase db) =>
      db.diagnosesTable.createAlias(
        $_aliasNameGenerator(
          db.prescriptionProtocolsTable.diagnosisId,
          db.diagnosesTable.id,
        ),
      );

  $$DiagnosesTableTableProcessedTableManager get diagnosisId {
    final $_column = $_itemColumn<String>('diagnosis_id')!;

    final manager = $$DiagnosesTableTableTableManager(
      $_db,
      $_db.diagnosesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diagnosisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PrescriptionProtocolsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PrescriptionProtocolsTableTable> {
  $$PrescriptionProtocolsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocolItemsJson => $composableBuilder(
    column: $table.protocolItemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get generalAdvice => $composableBuilder(
    column: $table.generalAdvice,
    builder: (column) => ColumnFilters(column),
  );

  $$DiagnosesTableTableFilterComposer get diagnosisId {
    final $$DiagnosesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnosesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableTableFilterComposer(
            $db: $db,
            $table: $db.diagnosesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrescriptionProtocolsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PrescriptionProtocolsTableTable> {
  $$PrescriptionProtocolsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocolItemsJson => $composableBuilder(
    column: $table.protocolItemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generalAdvice => $composableBuilder(
    column: $table.generalAdvice,
    builder: (column) => ColumnOrderings(column),
  );

  $$DiagnosesTableTableOrderingComposer get diagnosisId {
    final $$DiagnosesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnosesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableTableOrderingComposer(
            $db: $db,
            $table: $db.diagnosesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrescriptionProtocolsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrescriptionProtocolsTableTable> {
  $$PrescriptionProtocolsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get protocolItemsJson => $composableBuilder(
    column: $table.protocolItemsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get generalAdvice => $composableBuilder(
    column: $table.generalAdvice,
    builder: (column) => column,
  );

  $$DiagnosesTableTableAnnotationComposer get diagnosisId {
    final $$DiagnosesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnosesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.diagnosesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrescriptionProtocolsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrescriptionProtocolsTableTable,
          PrescriptionProtocolEntry,
          $$PrescriptionProtocolsTableTableFilterComposer,
          $$PrescriptionProtocolsTableTableOrderingComposer,
          $$PrescriptionProtocolsTableTableAnnotationComposer,
          $$PrescriptionProtocolsTableTableCreateCompanionBuilder,
          $$PrescriptionProtocolsTableTableUpdateCompanionBuilder,
          (
            PrescriptionProtocolEntry,
            $$PrescriptionProtocolsTableTableReferences,
          ),
          PrescriptionProtocolEntry,
          PrefetchHooks Function({bool diagnosisId})
        > {
  $$PrescriptionProtocolsTableTableTableManager(
    _$AppDatabase db,
    $PrescriptionProtocolsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrescriptionProtocolsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PrescriptionProtocolsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PrescriptionProtocolsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> diagnosisId = const Value.absent(),
                Value<String> protocolItemsJson = const Value.absent(),
                Value<String> generalAdvice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrescriptionProtocolsTableCompanion(
                id: id,
                diagnosisId: diagnosisId,
                protocolItemsJson: protocolItemsJson,
                generalAdvice: generalAdvice,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String diagnosisId,
                required String protocolItemsJson,
                Value<String> generalAdvice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrescriptionProtocolsTableCompanion.insert(
                id: id,
                diagnosisId: diagnosisId,
                protocolItemsJson: protocolItemsJson,
                generalAdvice: generalAdvice,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PrescriptionProtocolsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diagnosisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (diagnosisId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.diagnosisId,
                                referencedTable:
                                    $$PrescriptionProtocolsTableTableReferences
                                        ._diagnosisIdTable(db),
                                referencedColumn:
                                    $$PrescriptionProtocolsTableTableReferences
                                        ._diagnosisIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PrescriptionProtocolsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrescriptionProtocolsTableTable,
      PrescriptionProtocolEntry,
      $$PrescriptionProtocolsTableTableFilterComposer,
      $$PrescriptionProtocolsTableTableOrderingComposer,
      $$PrescriptionProtocolsTableTableAnnotationComposer,
      $$PrescriptionProtocolsTableTableCreateCompanionBuilder,
      $$PrescriptionProtocolsTableTableUpdateCompanionBuilder,
      (PrescriptionProtocolEntry, $$PrescriptionProtocolsTableTableReferences),
      PrescriptionProtocolEntry,
      PrefetchHooks Function({bool diagnosisId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientQueueTableTableTableManager get patientQueueTable =>
      $$PatientQueueTableTableTableManager(_db, _db.patientQueueTable);
  $$ComorbiditiesTableTableTableManager get comorbiditiesTable =>
      $$ComorbiditiesTableTableTableManager(_db, _db.comorbiditiesTable);
  $$PresentingComplaintsTableTableTableManager get presentingComplaintsTable =>
      $$PresentingComplaintsTableTableTableManager(
        _db,
        _db.presentingComplaintsTable,
      );
  $$ComplaintSubQuestionsTableTableTableManager
  get complaintSubQuestionsTable =>
      $$ComplaintSubQuestionsTableTableTableManager(
        _db,
        _db.complaintSubQuestionsTable,
      );
  $$ExaminationSystemsTableTableTableManager get examinationSystemsTable =>
      $$ExaminationSystemsTableTableTableManager(
        _db,
        _db.examinationSystemsTable,
      );
  $$DiagnosesTableTableTableManager get diagnosesTable =>
      $$DiagnosesTableTableTableManager(_db, _db.diagnosesTable);
  $$DrugsTableTableTableManager get drugsTable =>
      $$DrugsTableTableTableManager(_db, _db.drugsTable);
  $$PrescriptionProtocolsTableTableTableManager
  get prescriptionProtocolsTable =>
      $$PrescriptionProtocolsTableTableTableManager(
        _db,
        _db.prescriptionProtocolsTable,
      );
}
