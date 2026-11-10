// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_queue_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PatientQueueItem {

 String get id; String? get patientId; int get tokenNumber; String get patientName; int get age; DateTime? get dateOfBirth; String get gender; String? get phone; Map<String, dynamic> get vitals; List<String> get initialComorbIds; List<String> get allergies; String? get lmp; bool get isPregnant; String get status; DateTime get entryTime; DateTime? get consultationStartTime; DateTime? get completionTime; String? get compiledPrescriptionJson; String? get overrideReason; double get consultationFee; bool get isRevisit;
/// Create a copy of PatientQueueItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientQueueItemCopyWith<PatientQueueItem> get copyWith => _$PatientQueueItemCopyWithImpl<PatientQueueItem>(this as PatientQueueItem, _$identity);

  /// Serializes this PatientQueueItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.tokenNumber, tokenNumber) || other.tokenNumber == tokenNumber)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.age, age) || other.age == age)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.phone, phone) || other.phone == phone)&&const DeepCollectionEquality().equals(other.vitals, vitals)&&const DeepCollectionEquality().equals(other.initialComorbIds, initialComorbIds)&&const DeepCollectionEquality().equals(other.allergies, allergies)&&(identical(other.lmp, lmp) || other.lmp == lmp)&&(identical(other.isPregnant, isPregnant) || other.isPregnant == isPregnant)&&(identical(other.status, status) || other.status == status)&&(identical(other.entryTime, entryTime) || other.entryTime == entryTime)&&(identical(other.consultationStartTime, consultationStartTime) || other.consultationStartTime == consultationStartTime)&&(identical(other.completionTime, completionTime) || other.completionTime == completionTime)&&(identical(other.compiledPrescriptionJson, compiledPrescriptionJson) || other.compiledPrescriptionJson == compiledPrescriptionJson)&&(identical(other.overrideReason, overrideReason) || other.overrideReason == overrideReason)&&(identical(other.consultationFee, consultationFee) || other.consultationFee == consultationFee)&&(identical(other.isRevisit, isRevisit) || other.isRevisit == isRevisit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,patientId,tokenNumber,patientName,age,dateOfBirth,gender,phone,const DeepCollectionEquality().hash(vitals),const DeepCollectionEquality().hash(initialComorbIds),const DeepCollectionEquality().hash(allergies),lmp,isPregnant,status,entryTime,consultationStartTime,completionTime,compiledPrescriptionJson,overrideReason,consultationFee,isRevisit]);

@override
String toString() {
  return 'PatientQueueItem(id: $id, patientId: $patientId, tokenNumber: $tokenNumber, patientName: $patientName, age: $age, dateOfBirth: $dateOfBirth, gender: $gender, phone: $phone, vitals: $vitals, initialComorbIds: $initialComorbIds, allergies: $allergies, lmp: $lmp, isPregnant: $isPregnant, status: $status, entryTime: $entryTime, consultationStartTime: $consultationStartTime, completionTime: $completionTime, compiledPrescriptionJson: $compiledPrescriptionJson, overrideReason: $overrideReason, consultationFee: $consultationFee, isRevisit: $isRevisit)';
}


}

/// @nodoc
abstract mixin class $PatientQueueItemCopyWith<$Res>  {
  factory $PatientQueueItemCopyWith(PatientQueueItem value, $Res Function(PatientQueueItem) _then) = _$PatientQueueItemCopyWithImpl;
@useResult
$Res call({
 String id, String? patientId, int tokenNumber, String patientName, int age, DateTime? dateOfBirth, String gender, String? phone, Map<String, dynamic> vitals, List<String> initialComorbIds, List<String> allergies, String? lmp, bool isPregnant, String status, DateTime entryTime, DateTime? consultationStartTime, DateTime? completionTime, String? compiledPrescriptionJson, String? overrideReason, double consultationFee, bool isRevisit
});




}
/// @nodoc
class _$PatientQueueItemCopyWithImpl<$Res>
    implements $PatientQueueItemCopyWith<$Res> {
  _$PatientQueueItemCopyWithImpl(this._self, this._then);

  final PatientQueueItem _self;
  final $Res Function(PatientQueueItem) _then;

/// Create a copy of PatientQueueItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patientId = freezed,Object? tokenNumber = null,Object? patientName = null,Object? age = null,Object? dateOfBirth = freezed,Object? gender = null,Object? phone = freezed,Object? vitals = null,Object? initialComorbIds = null,Object? allergies = null,Object? lmp = freezed,Object? isPregnant = null,Object? status = null,Object? entryTime = null,Object? consultationStartTime = freezed,Object? completionTime = freezed,Object? compiledPrescriptionJson = freezed,Object? overrideReason = freezed,Object? consultationFee = null,Object? isRevisit = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,tokenNumber: null == tokenNumber ? _self.tokenNumber : tokenNumber // ignore: cast_nullable_to_non_nullable
as int,patientName: null == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,vitals: null == vitals ? _self.vitals : vitals // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,initialComorbIds: null == initialComorbIds ? _self.initialComorbIds : initialComorbIds // ignore: cast_nullable_to_non_nullable
as List<String>,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,lmp: freezed == lmp ? _self.lmp : lmp // ignore: cast_nullable_to_non_nullable
as String?,isPregnant: null == isPregnant ? _self.isPregnant : isPregnant // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,entryTime: null == entryTime ? _self.entryTime : entryTime // ignore: cast_nullable_to_non_nullable
as DateTime,consultationStartTime: freezed == consultationStartTime ? _self.consultationStartTime : consultationStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,completionTime: freezed == completionTime ? _self.completionTime : completionTime // ignore: cast_nullable_to_non_nullable
as DateTime?,compiledPrescriptionJson: freezed == compiledPrescriptionJson ? _self.compiledPrescriptionJson : compiledPrescriptionJson // ignore: cast_nullable_to_non_nullable
as String?,overrideReason: freezed == overrideReason ? _self.overrideReason : overrideReason // ignore: cast_nullable_to_non_nullable
as String?,consultationFee: null == consultationFee ? _self.consultationFee : consultationFee // ignore: cast_nullable_to_non_nullable
as double,isRevisit: null == isRevisit ? _self.isRevisit : isRevisit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientQueueItem].
extension PatientQueueItemPatterns on PatientQueueItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientQueueItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientQueueItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientQueueItem value)  $default,){
final _that = this;
switch (_that) {
case _PatientQueueItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientQueueItem value)?  $default,){
final _that = this;
switch (_that) {
case _PatientQueueItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? patientId,  int tokenNumber,  String patientName,  int age,  DateTime? dateOfBirth,  String gender,  String? phone,  Map<String, dynamic> vitals,  List<String> initialComorbIds,  List<String> allergies,  String? lmp,  bool isPregnant,  String status,  DateTime entryTime,  DateTime? consultationStartTime,  DateTime? completionTime,  String? compiledPrescriptionJson,  String? overrideReason,  double consultationFee,  bool isRevisit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientQueueItem() when $default != null:
return $default(_that.id,_that.patientId,_that.tokenNumber,_that.patientName,_that.age,_that.dateOfBirth,_that.gender,_that.phone,_that.vitals,_that.initialComorbIds,_that.allergies,_that.lmp,_that.isPregnant,_that.status,_that.entryTime,_that.consultationStartTime,_that.completionTime,_that.compiledPrescriptionJson,_that.overrideReason,_that.consultationFee,_that.isRevisit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? patientId,  int tokenNumber,  String patientName,  int age,  DateTime? dateOfBirth,  String gender,  String? phone,  Map<String, dynamic> vitals,  List<String> initialComorbIds,  List<String> allergies,  String? lmp,  bool isPregnant,  String status,  DateTime entryTime,  DateTime? consultationStartTime,  DateTime? completionTime,  String? compiledPrescriptionJson,  String? overrideReason,  double consultationFee,  bool isRevisit)  $default,) {final _that = this;
switch (_that) {
case _PatientQueueItem():
return $default(_that.id,_that.patientId,_that.tokenNumber,_that.patientName,_that.age,_that.dateOfBirth,_that.gender,_that.phone,_that.vitals,_that.initialComorbIds,_that.allergies,_that.lmp,_that.isPregnant,_that.status,_that.entryTime,_that.consultationStartTime,_that.completionTime,_that.compiledPrescriptionJson,_that.overrideReason,_that.consultationFee,_that.isRevisit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? patientId,  int tokenNumber,  String patientName,  int age,  DateTime? dateOfBirth,  String gender,  String? phone,  Map<String, dynamic> vitals,  List<String> initialComorbIds,  List<String> allergies,  String? lmp,  bool isPregnant,  String status,  DateTime entryTime,  DateTime? consultationStartTime,  DateTime? completionTime,  String? compiledPrescriptionJson,  String? overrideReason,  double consultationFee,  bool isRevisit)?  $default,) {final _that = this;
switch (_that) {
case _PatientQueueItem() when $default != null:
return $default(_that.id,_that.patientId,_that.tokenNumber,_that.patientName,_that.age,_that.dateOfBirth,_that.gender,_that.phone,_that.vitals,_that.initialComorbIds,_that.allergies,_that.lmp,_that.isPregnant,_that.status,_that.entryTime,_that.consultationStartTime,_that.completionTime,_that.compiledPrescriptionJson,_that.overrideReason,_that.consultationFee,_that.isRevisit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PatientQueueItem extends PatientQueueItem {
  const _PatientQueueItem({required this.id, this.patientId, required this.tokenNumber, required this.patientName, required this.age, this.dateOfBirth, required this.gender, this.phone, final  Map<String, dynamic> vitals = const {}, final  List<String> initialComorbIds = const [], final  List<String> allergies = const [], this.lmp, this.isPregnant = false, this.status = 'WAITING', required this.entryTime, this.consultationStartTime, this.completionTime, this.compiledPrescriptionJson, this.overrideReason, this.consultationFee = 0.0, this.isRevisit = false}): _vitals = vitals,_initialComorbIds = initialComorbIds,_allergies = allergies,super._();
  factory _PatientQueueItem.fromJson(Map<String, dynamic> json) => _$PatientQueueItemFromJson(json);

@override final  String id;
@override final  String? patientId;
@override final  int tokenNumber;
@override final  String patientName;
@override final  int age;
@override final  DateTime? dateOfBirth;
@override final  String gender;
@override final  String? phone;
 final  Map<String, dynamic> _vitals;
@override@JsonKey() Map<String, dynamic> get vitals {
  if (_vitals is EqualUnmodifiableMapView) return _vitals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_vitals);
}

 final  List<String> _initialComorbIds;
@override@JsonKey() List<String> get initialComorbIds {
  if (_initialComorbIds is EqualUnmodifiableListView) return _initialComorbIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_initialComorbIds);
}

 final  List<String> _allergies;
@override@JsonKey() List<String> get allergies {
  if (_allergies is EqualUnmodifiableListView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergies);
}

@override final  String? lmp;
@override@JsonKey() final  bool isPregnant;
@override@JsonKey() final  String status;
@override final  DateTime entryTime;
@override final  DateTime? consultationStartTime;
@override final  DateTime? completionTime;
@override final  String? compiledPrescriptionJson;
@override final  String? overrideReason;
@override@JsonKey() final  double consultationFee;
@override@JsonKey() final  bool isRevisit;

/// Create a copy of PatientQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientQueueItemCopyWith<_PatientQueueItem> get copyWith => __$PatientQueueItemCopyWithImpl<_PatientQueueItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientQueueItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.tokenNumber, tokenNumber) || other.tokenNumber == tokenNumber)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.age, age) || other.age == age)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.phone, phone) || other.phone == phone)&&const DeepCollectionEquality().equals(other._vitals, _vitals)&&const DeepCollectionEquality().equals(other._initialComorbIds, _initialComorbIds)&&const DeepCollectionEquality().equals(other._allergies, _allergies)&&(identical(other.lmp, lmp) || other.lmp == lmp)&&(identical(other.isPregnant, isPregnant) || other.isPregnant == isPregnant)&&(identical(other.status, status) || other.status == status)&&(identical(other.entryTime, entryTime) || other.entryTime == entryTime)&&(identical(other.consultationStartTime, consultationStartTime) || other.consultationStartTime == consultationStartTime)&&(identical(other.completionTime, completionTime) || other.completionTime == completionTime)&&(identical(other.compiledPrescriptionJson, compiledPrescriptionJson) || other.compiledPrescriptionJson == compiledPrescriptionJson)&&(identical(other.overrideReason, overrideReason) || other.overrideReason == overrideReason)&&(identical(other.consultationFee, consultationFee) || other.consultationFee == consultationFee)&&(identical(other.isRevisit, isRevisit) || other.isRevisit == isRevisit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,patientId,tokenNumber,patientName,age,dateOfBirth,gender,phone,const DeepCollectionEquality().hash(_vitals),const DeepCollectionEquality().hash(_initialComorbIds),const DeepCollectionEquality().hash(_allergies),lmp,isPregnant,status,entryTime,consultationStartTime,completionTime,compiledPrescriptionJson,overrideReason,consultationFee,isRevisit]);

@override
String toString() {
  return 'PatientQueueItem(id: $id, patientId: $patientId, tokenNumber: $tokenNumber, patientName: $patientName, age: $age, dateOfBirth: $dateOfBirth, gender: $gender, phone: $phone, vitals: $vitals, initialComorbIds: $initialComorbIds, allergies: $allergies, lmp: $lmp, isPregnant: $isPregnant, status: $status, entryTime: $entryTime, consultationStartTime: $consultationStartTime, completionTime: $completionTime, compiledPrescriptionJson: $compiledPrescriptionJson, overrideReason: $overrideReason, consultationFee: $consultationFee, isRevisit: $isRevisit)';
}


}

/// @nodoc
abstract mixin class _$PatientQueueItemCopyWith<$Res> implements $PatientQueueItemCopyWith<$Res> {
  factory _$PatientQueueItemCopyWith(_PatientQueueItem value, $Res Function(_PatientQueueItem) _then) = __$PatientQueueItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String? patientId, int tokenNumber, String patientName, int age, DateTime? dateOfBirth, String gender, String? phone, Map<String, dynamic> vitals, List<String> initialComorbIds, List<String> allergies, String? lmp, bool isPregnant, String status, DateTime entryTime, DateTime? consultationStartTime, DateTime? completionTime, String? compiledPrescriptionJson, String? overrideReason, double consultationFee, bool isRevisit
});




}
/// @nodoc
class __$PatientQueueItemCopyWithImpl<$Res>
    implements _$PatientQueueItemCopyWith<$Res> {
  __$PatientQueueItemCopyWithImpl(this._self, this._then);

  final _PatientQueueItem _self;
  final $Res Function(_PatientQueueItem) _then;

/// Create a copy of PatientQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patientId = freezed,Object? tokenNumber = null,Object? patientName = null,Object? age = null,Object? dateOfBirth = freezed,Object? gender = null,Object? phone = freezed,Object? vitals = null,Object? initialComorbIds = null,Object? allergies = null,Object? lmp = freezed,Object? isPregnant = null,Object? status = null,Object? entryTime = null,Object? consultationStartTime = freezed,Object? completionTime = freezed,Object? compiledPrescriptionJson = freezed,Object? overrideReason = freezed,Object? consultationFee = null,Object? isRevisit = null,}) {
  return _then(_PatientQueueItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,tokenNumber: null == tokenNumber ? _self.tokenNumber : tokenNumber // ignore: cast_nullable_to_non_nullable
as int,patientName: null == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,vitals: null == vitals ? _self._vitals : vitals // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,initialComorbIds: null == initialComorbIds ? _self._initialComorbIds : initialComorbIds // ignore: cast_nullable_to_non_nullable
as List<String>,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,lmp: freezed == lmp ? _self.lmp : lmp // ignore: cast_nullable_to_non_nullable
as String?,isPregnant: null == isPregnant ? _self.isPregnant : isPregnant // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,entryTime: null == entryTime ? _self.entryTime : entryTime // ignore: cast_nullable_to_non_nullable
as DateTime,consultationStartTime: freezed == consultationStartTime ? _self.consultationStartTime : consultationStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,completionTime: freezed == completionTime ? _self.completionTime : completionTime // ignore: cast_nullable_to_non_nullable
as DateTime?,compiledPrescriptionJson: freezed == compiledPrescriptionJson ? _self.compiledPrescriptionJson : compiledPrescriptionJson // ignore: cast_nullable_to_non_nullable
as String?,overrideReason: freezed == overrideReason ? _self.overrideReason : overrideReason // ignore: cast_nullable_to_non_nullable
as String?,consultationFee: null == consultationFee ? _self.consultationFee : consultationFee // ignore: cast_nullable_to_non_nullable
as double,isRevisit: null == isRevisit ? _self.isRevisit : isRevisit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
