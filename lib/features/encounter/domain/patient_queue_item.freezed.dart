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

 String get id; int get tokenNumber; String get patientName; int get age; String get gender; String? get phone; Map<String, dynamic> get vitals; List<String> get initialComorbIds; String get status; DateTime get entryTime; DateTime? get consultationStartTime; DateTime? get completionTime; String? get compiledPrescriptionJson;
/// Create a copy of PatientQueueItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientQueueItemCopyWith<PatientQueueItem> get copyWith => _$PatientQueueItemCopyWithImpl<PatientQueueItem>(this as PatientQueueItem, _$identity);

  /// Serializes this PatientQueueItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.tokenNumber, tokenNumber) || other.tokenNumber == tokenNumber)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.phone, phone) || other.phone == phone)&&const DeepCollectionEquality().equals(other.vitals, vitals)&&const DeepCollectionEquality().equals(other.initialComorbIds, initialComorbIds)&&(identical(other.status, status) || other.status == status)&&(identical(other.entryTime, entryTime) || other.entryTime == entryTime)&&(identical(other.consultationStartTime, consultationStartTime) || other.consultationStartTime == consultationStartTime)&&(identical(other.completionTime, completionTime) || other.completionTime == completionTime)&&(identical(other.compiledPrescriptionJson, compiledPrescriptionJson) || other.compiledPrescriptionJson == compiledPrescriptionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tokenNumber,patientName,age,gender,phone,const DeepCollectionEquality().hash(vitals),const DeepCollectionEquality().hash(initialComorbIds),status,entryTime,consultationStartTime,completionTime,compiledPrescriptionJson);

@override
String toString() {
  return 'PatientQueueItem(id: $id, tokenNumber: $tokenNumber, patientName: $patientName, age: $age, gender: $gender, phone: $phone, vitals: $vitals, initialComorbIds: $initialComorbIds, status: $status, entryTime: $entryTime, consultationStartTime: $consultationStartTime, completionTime: $completionTime, compiledPrescriptionJson: $compiledPrescriptionJson)';
}


}

/// @nodoc
abstract mixin class $PatientQueueItemCopyWith<$Res>  {
  factory $PatientQueueItemCopyWith(PatientQueueItem value, $Res Function(PatientQueueItem) _then) = _$PatientQueueItemCopyWithImpl;
@useResult
$Res call({
 String id, int tokenNumber, String patientName, int age, String gender, String? phone, Map<String, dynamic> vitals, List<String> initialComorbIds, String status, DateTime entryTime, DateTime? consultationStartTime, DateTime? completionTime, String? compiledPrescriptionJson
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tokenNumber = null,Object? patientName = null,Object? age = null,Object? gender = null,Object? phone = freezed,Object? vitals = null,Object? initialComorbIds = null,Object? status = null,Object? entryTime = null,Object? consultationStartTime = freezed,Object? completionTime = freezed,Object? compiledPrescriptionJson = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tokenNumber: null == tokenNumber ? _self.tokenNumber : tokenNumber // ignore: cast_nullable_to_non_nullable
as int,patientName: null == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,vitals: null == vitals ? _self.vitals : vitals // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,initialComorbIds: null == initialComorbIds ? _self.initialComorbIds : initialComorbIds // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,entryTime: null == entryTime ? _self.entryTime : entryTime // ignore: cast_nullable_to_non_nullable
as DateTime,consultationStartTime: freezed == consultationStartTime ? _self.consultationStartTime : consultationStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,completionTime: freezed == completionTime ? _self.completionTime : completionTime // ignore: cast_nullable_to_non_nullable
as DateTime?,compiledPrescriptionJson: freezed == compiledPrescriptionJson ? _self.compiledPrescriptionJson : compiledPrescriptionJson // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int tokenNumber,  String patientName,  int age,  String gender,  String? phone,  Map<String, dynamic> vitals,  List<String> initialComorbIds,  String status,  DateTime entryTime,  DateTime? consultationStartTime,  DateTime? completionTime,  String? compiledPrescriptionJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientQueueItem() when $default != null:
return $default(_that.id,_that.tokenNumber,_that.patientName,_that.age,_that.gender,_that.phone,_that.vitals,_that.initialComorbIds,_that.status,_that.entryTime,_that.consultationStartTime,_that.completionTime,_that.compiledPrescriptionJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int tokenNumber,  String patientName,  int age,  String gender,  String? phone,  Map<String, dynamic> vitals,  List<String> initialComorbIds,  String status,  DateTime entryTime,  DateTime? consultationStartTime,  DateTime? completionTime,  String? compiledPrescriptionJson)  $default,) {final _that = this;
switch (_that) {
case _PatientQueueItem():
return $default(_that.id,_that.tokenNumber,_that.patientName,_that.age,_that.gender,_that.phone,_that.vitals,_that.initialComorbIds,_that.status,_that.entryTime,_that.consultationStartTime,_that.completionTime,_that.compiledPrescriptionJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int tokenNumber,  String patientName,  int age,  String gender,  String? phone,  Map<String, dynamic> vitals,  List<String> initialComorbIds,  String status,  DateTime entryTime,  DateTime? consultationStartTime,  DateTime? completionTime,  String? compiledPrescriptionJson)?  $default,) {final _that = this;
switch (_that) {
case _PatientQueueItem() when $default != null:
return $default(_that.id,_that.tokenNumber,_that.patientName,_that.age,_that.gender,_that.phone,_that.vitals,_that.initialComorbIds,_that.status,_that.entryTime,_that.consultationStartTime,_that.completionTime,_that.compiledPrescriptionJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PatientQueueItem extends PatientQueueItem {
  const _PatientQueueItem({required this.id, required this.tokenNumber, required this.patientName, required this.age, required this.gender, this.phone, final  Map<String, dynamic> vitals = const {}, final  List<String> initialComorbIds = const [], this.status = 'WAITING', required this.entryTime, this.consultationStartTime, this.completionTime, this.compiledPrescriptionJson}): _vitals = vitals,_initialComorbIds = initialComorbIds,super._();
  factory _PatientQueueItem.fromJson(Map<String, dynamic> json) => _$PatientQueueItemFromJson(json);

@override final  String id;
@override final  int tokenNumber;
@override final  String patientName;
@override final  int age;
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

@override@JsonKey() final  String status;
@override final  DateTime entryTime;
@override final  DateTime? consultationStartTime;
@override final  DateTime? completionTime;
@override final  String? compiledPrescriptionJson;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.tokenNumber, tokenNumber) || other.tokenNumber == tokenNumber)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.phone, phone) || other.phone == phone)&&const DeepCollectionEquality().equals(other._vitals, _vitals)&&const DeepCollectionEquality().equals(other._initialComorbIds, _initialComorbIds)&&(identical(other.status, status) || other.status == status)&&(identical(other.entryTime, entryTime) || other.entryTime == entryTime)&&(identical(other.consultationStartTime, consultationStartTime) || other.consultationStartTime == consultationStartTime)&&(identical(other.completionTime, completionTime) || other.completionTime == completionTime)&&(identical(other.compiledPrescriptionJson, compiledPrescriptionJson) || other.compiledPrescriptionJson == compiledPrescriptionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tokenNumber,patientName,age,gender,phone,const DeepCollectionEquality().hash(_vitals),const DeepCollectionEquality().hash(_initialComorbIds),status,entryTime,consultationStartTime,completionTime,compiledPrescriptionJson);

@override
String toString() {
  return 'PatientQueueItem(id: $id, tokenNumber: $tokenNumber, patientName: $patientName, age: $age, gender: $gender, phone: $phone, vitals: $vitals, initialComorbIds: $initialComorbIds, status: $status, entryTime: $entryTime, consultationStartTime: $consultationStartTime, completionTime: $completionTime, compiledPrescriptionJson: $compiledPrescriptionJson)';
}


}

/// @nodoc
abstract mixin class _$PatientQueueItemCopyWith<$Res> implements $PatientQueueItemCopyWith<$Res> {
  factory _$PatientQueueItemCopyWith(_PatientQueueItem value, $Res Function(_PatientQueueItem) _then) = __$PatientQueueItemCopyWithImpl;
@override @useResult
$Res call({
 String id, int tokenNumber, String patientName, int age, String gender, String? phone, Map<String, dynamic> vitals, List<String> initialComorbIds, String status, DateTime entryTime, DateTime? consultationStartTime, DateTime? completionTime, String? compiledPrescriptionJson
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tokenNumber = null,Object? patientName = null,Object? age = null,Object? gender = null,Object? phone = freezed,Object? vitals = null,Object? initialComorbIds = null,Object? status = null,Object? entryTime = null,Object? consultationStartTime = freezed,Object? completionTime = freezed,Object? compiledPrescriptionJson = freezed,}) {
  return _then(_PatientQueueItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tokenNumber: null == tokenNumber ? _self.tokenNumber : tokenNumber // ignore: cast_nullable_to_non_nullable
as int,patientName: null == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,vitals: null == vitals ? _self._vitals : vitals // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,initialComorbIds: null == initialComorbIds ? _self._initialComorbIds : initialComorbIds // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,entryTime: null == entryTime ? _self.entryTime : entryTime // ignore: cast_nullable_to_non_nullable
as DateTime,consultationStartTime: freezed == consultationStartTime ? _self.consultationStartTime : consultationStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,completionTime: freezed == completionTime ? _self.completionTime : completionTime // ignore: cast_nullable_to_non_nullable
as DateTime?,compiledPrescriptionJson: freezed == compiledPrescriptionJson ? _self.compiledPrescriptionJson : compiledPrescriptionJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
