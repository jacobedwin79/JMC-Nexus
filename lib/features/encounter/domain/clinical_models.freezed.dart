// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clinical_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PatientVitals {

 int? get bpSys; int? get bpDia; int? get pulse; int? get spo2; double? get temp; double? get weight; int? get rbs;// Random Blood Sugar in mg/dL
 bool get tempIsCelsius;
/// Create a copy of PatientVitals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientVitalsCopyWith<PatientVitals> get copyWith => _$PatientVitalsCopyWithImpl<PatientVitals>(this as PatientVitals, _$identity);

  /// Serializes this PatientVitals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientVitals&&(identical(other.bpSys, bpSys) || other.bpSys == bpSys)&&(identical(other.bpDia, bpDia) || other.bpDia == bpDia)&&(identical(other.pulse, pulse) || other.pulse == pulse)&&(identical(other.spo2, spo2) || other.spo2 == spo2)&&(identical(other.temp, temp) || other.temp == temp)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.rbs, rbs) || other.rbs == rbs)&&(identical(other.tempIsCelsius, tempIsCelsius) || other.tempIsCelsius == tempIsCelsius));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bpSys,bpDia,pulse,spo2,temp,weight,rbs,tempIsCelsius);

@override
String toString() {
  return 'PatientVitals(bpSys: $bpSys, bpDia: $bpDia, pulse: $pulse, spo2: $spo2, temp: $temp, weight: $weight, rbs: $rbs, tempIsCelsius: $tempIsCelsius)';
}


}

/// @nodoc
abstract mixin class $PatientVitalsCopyWith<$Res>  {
  factory $PatientVitalsCopyWith(PatientVitals value, $Res Function(PatientVitals) _then) = _$PatientVitalsCopyWithImpl;
@useResult
$Res call({
 int? bpSys, int? bpDia, int? pulse, int? spo2, double? temp, double? weight, int? rbs, bool tempIsCelsius
});




}
/// @nodoc
class _$PatientVitalsCopyWithImpl<$Res>
    implements $PatientVitalsCopyWith<$Res> {
  _$PatientVitalsCopyWithImpl(this._self, this._then);

  final PatientVitals _self;
  final $Res Function(PatientVitals) _then;

/// Create a copy of PatientVitals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bpSys = freezed,Object? bpDia = freezed,Object? pulse = freezed,Object? spo2 = freezed,Object? temp = freezed,Object? weight = freezed,Object? rbs = freezed,Object? tempIsCelsius = null,}) {
  return _then(_self.copyWith(
bpSys: freezed == bpSys ? _self.bpSys : bpSys // ignore: cast_nullable_to_non_nullable
as int?,bpDia: freezed == bpDia ? _self.bpDia : bpDia // ignore: cast_nullable_to_non_nullable
as int?,pulse: freezed == pulse ? _self.pulse : pulse // ignore: cast_nullable_to_non_nullable
as int?,spo2: freezed == spo2 ? _self.spo2 : spo2 // ignore: cast_nullable_to_non_nullable
as int?,temp: freezed == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,rbs: freezed == rbs ? _self.rbs : rbs // ignore: cast_nullable_to_non_nullable
as int?,tempIsCelsius: null == tempIsCelsius ? _self.tempIsCelsius : tempIsCelsius // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientVitals].
extension PatientVitalsPatterns on PatientVitals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientVitals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientVitals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientVitals value)  $default,){
final _that = this;
switch (_that) {
case _PatientVitals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientVitals value)?  $default,){
final _that = this;
switch (_that) {
case _PatientVitals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? bpSys,  int? bpDia,  int? pulse,  int? spo2,  double? temp,  double? weight,  int? rbs,  bool tempIsCelsius)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientVitals() when $default != null:
return $default(_that.bpSys,_that.bpDia,_that.pulse,_that.spo2,_that.temp,_that.weight,_that.rbs,_that.tempIsCelsius);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? bpSys,  int? bpDia,  int? pulse,  int? spo2,  double? temp,  double? weight,  int? rbs,  bool tempIsCelsius)  $default,) {final _that = this;
switch (_that) {
case _PatientVitals():
return $default(_that.bpSys,_that.bpDia,_that.pulse,_that.spo2,_that.temp,_that.weight,_that.rbs,_that.tempIsCelsius);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? bpSys,  int? bpDia,  int? pulse,  int? spo2,  double? temp,  double? weight,  int? rbs,  bool tempIsCelsius)?  $default,) {final _that = this;
switch (_that) {
case _PatientVitals() when $default != null:
return $default(_that.bpSys,_that.bpDia,_that.pulse,_that.spo2,_that.temp,_that.weight,_that.rbs,_that.tempIsCelsius);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PatientVitals extends PatientVitals {
  const _PatientVitals({this.bpSys, this.bpDia, this.pulse, this.spo2, this.temp, this.weight, this.rbs, this.tempIsCelsius = false}): super._();
  factory _PatientVitals.fromJson(Map<String, dynamic> json) => _$PatientVitalsFromJson(json);

@override final  int? bpSys;
@override final  int? bpDia;
@override final  int? pulse;
@override final  int? spo2;
@override final  double? temp;
@override final  double? weight;
@override final  int? rbs;
// Random Blood Sugar in mg/dL
@override@JsonKey() final  bool tempIsCelsius;

/// Create a copy of PatientVitals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientVitalsCopyWith<_PatientVitals> get copyWith => __$PatientVitalsCopyWithImpl<_PatientVitals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientVitalsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientVitals&&(identical(other.bpSys, bpSys) || other.bpSys == bpSys)&&(identical(other.bpDia, bpDia) || other.bpDia == bpDia)&&(identical(other.pulse, pulse) || other.pulse == pulse)&&(identical(other.spo2, spo2) || other.spo2 == spo2)&&(identical(other.temp, temp) || other.temp == temp)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.rbs, rbs) || other.rbs == rbs)&&(identical(other.tempIsCelsius, tempIsCelsius) || other.tempIsCelsius == tempIsCelsius));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bpSys,bpDia,pulse,spo2,temp,weight,rbs,tempIsCelsius);

@override
String toString() {
  return 'PatientVitals(bpSys: $bpSys, bpDia: $bpDia, pulse: $pulse, spo2: $spo2, temp: $temp, weight: $weight, rbs: $rbs, tempIsCelsius: $tempIsCelsius)';
}


}

/// @nodoc
abstract mixin class _$PatientVitalsCopyWith<$Res> implements $PatientVitalsCopyWith<$Res> {
  factory _$PatientVitalsCopyWith(_PatientVitals value, $Res Function(_PatientVitals) _then) = __$PatientVitalsCopyWithImpl;
@override @useResult
$Res call({
 int? bpSys, int? bpDia, int? pulse, int? spo2, double? temp, double? weight, int? rbs, bool tempIsCelsius
});




}
/// @nodoc
class __$PatientVitalsCopyWithImpl<$Res>
    implements _$PatientVitalsCopyWith<$Res> {
  __$PatientVitalsCopyWithImpl(this._self, this._then);

  final _PatientVitals _self;
  final $Res Function(_PatientVitals) _then;

/// Create a copy of PatientVitals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bpSys = freezed,Object? bpDia = freezed,Object? pulse = freezed,Object? spo2 = freezed,Object? temp = freezed,Object? weight = freezed,Object? rbs = freezed,Object? tempIsCelsius = null,}) {
  return _then(_PatientVitals(
bpSys: freezed == bpSys ? _self.bpSys : bpSys // ignore: cast_nullable_to_non_nullable
as int?,bpDia: freezed == bpDia ? _self.bpDia : bpDia // ignore: cast_nullable_to_non_nullable
as int?,pulse: freezed == pulse ? _self.pulse : pulse // ignore: cast_nullable_to_non_nullable
as int?,spo2: freezed == spo2 ? _self.spo2 : spo2 // ignore: cast_nullable_to_non_nullable
as int?,temp: freezed == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,rbs: freezed == rbs ? _self.rbs : rbs // ignore: cast_nullable_to_non_nullable
as int?,tempIsCelsius: null == tempIsCelsius ? _self.tempIsCelsius : tempIsCelsius // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ComorbidityModel {

 String get id; String get name; List<String> get contraindicatedDrugClasses;
/// Create a copy of ComorbidityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComorbidityModelCopyWith<ComorbidityModel> get copyWith => _$ComorbidityModelCopyWithImpl<ComorbidityModel>(this as ComorbidityModel, _$identity);

  /// Serializes this ComorbidityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComorbidityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.contraindicatedDrugClasses, contraindicatedDrugClasses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(contraindicatedDrugClasses));

@override
String toString() {
  return 'ComorbidityModel(id: $id, name: $name, contraindicatedDrugClasses: $contraindicatedDrugClasses)';
}


}

/// @nodoc
abstract mixin class $ComorbidityModelCopyWith<$Res>  {
  factory $ComorbidityModelCopyWith(ComorbidityModel value, $Res Function(ComorbidityModel) _then) = _$ComorbidityModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> contraindicatedDrugClasses
});




}
/// @nodoc
class _$ComorbidityModelCopyWithImpl<$Res>
    implements $ComorbidityModelCopyWith<$Res> {
  _$ComorbidityModelCopyWithImpl(this._self, this._then);

  final ComorbidityModel _self;
  final $Res Function(ComorbidityModel) _then;

/// Create a copy of ComorbidityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? contraindicatedDrugClasses = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contraindicatedDrugClasses: null == contraindicatedDrugClasses ? _self.contraindicatedDrugClasses : contraindicatedDrugClasses // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ComorbidityModel].
extension ComorbidityModelPatterns on ComorbidityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComorbidityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComorbidityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComorbidityModel value)  $default,){
final _that = this;
switch (_that) {
case _ComorbidityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComorbidityModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComorbidityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> contraindicatedDrugClasses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComorbidityModel() when $default != null:
return $default(_that.id,_that.name,_that.contraindicatedDrugClasses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> contraindicatedDrugClasses)  $default,) {final _that = this;
switch (_that) {
case _ComorbidityModel():
return $default(_that.id,_that.name,_that.contraindicatedDrugClasses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> contraindicatedDrugClasses)?  $default,) {final _that = this;
switch (_that) {
case _ComorbidityModel() when $default != null:
return $default(_that.id,_that.name,_that.contraindicatedDrugClasses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComorbidityModel implements ComorbidityModel {
  const _ComorbidityModel({required this.id, required this.name, final  List<String> contraindicatedDrugClasses = const []}): _contraindicatedDrugClasses = contraindicatedDrugClasses;
  factory _ComorbidityModel.fromJson(Map<String, dynamic> json) => _$ComorbidityModelFromJson(json);

@override final  String id;
@override final  String name;
 final  List<String> _contraindicatedDrugClasses;
@override@JsonKey() List<String> get contraindicatedDrugClasses {
  if (_contraindicatedDrugClasses is EqualUnmodifiableListView) return _contraindicatedDrugClasses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contraindicatedDrugClasses);
}


/// Create a copy of ComorbidityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComorbidityModelCopyWith<_ComorbidityModel> get copyWith => __$ComorbidityModelCopyWithImpl<_ComorbidityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComorbidityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComorbidityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._contraindicatedDrugClasses, _contraindicatedDrugClasses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_contraindicatedDrugClasses));

@override
String toString() {
  return 'ComorbidityModel(id: $id, name: $name, contraindicatedDrugClasses: $contraindicatedDrugClasses)';
}


}

/// @nodoc
abstract mixin class _$ComorbidityModelCopyWith<$Res> implements $ComorbidityModelCopyWith<$Res> {
  factory _$ComorbidityModelCopyWith(_ComorbidityModel value, $Res Function(_ComorbidityModel) _then) = __$ComorbidityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> contraindicatedDrugClasses
});




}
/// @nodoc
class __$ComorbidityModelCopyWithImpl<$Res>
    implements _$ComorbidityModelCopyWith<$Res> {
  __$ComorbidityModelCopyWithImpl(this._self, this._then);

  final _ComorbidityModel _self;
  final $Res Function(_ComorbidityModel) _then;

/// Create a copy of ComorbidityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? contraindicatedDrugClasses = null,}) {
  return _then(_ComorbidityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contraindicatedDrugClasses: null == contraindicatedDrugClasses ? _self._contraindicatedDrugClasses : contraindicatedDrugClasses // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ComplaintSubQuestionModel {

 String get id; String get complaintId; String get questionLabel; List<String> get options; String get sentenceTemplate; bool get isMultiSelect; int get sequenceOrder;
/// Create a copy of ComplaintSubQuestionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintSubQuestionModelCopyWith<ComplaintSubQuestionModel> get copyWith => _$ComplaintSubQuestionModelCopyWithImpl<ComplaintSubQuestionModel>(this as ComplaintSubQuestionModel, _$identity);

  /// Serializes this ComplaintSubQuestionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintSubQuestionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.complaintId, complaintId) || other.complaintId == complaintId)&&(identical(other.questionLabel, questionLabel) || other.questionLabel == questionLabel)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.sentenceTemplate, sentenceTemplate) || other.sentenceTemplate == sentenceTemplate)&&(identical(other.isMultiSelect, isMultiSelect) || other.isMultiSelect == isMultiSelect)&&(identical(other.sequenceOrder, sequenceOrder) || other.sequenceOrder == sequenceOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,complaintId,questionLabel,const DeepCollectionEquality().hash(options),sentenceTemplate,isMultiSelect,sequenceOrder);

@override
String toString() {
  return 'ComplaintSubQuestionModel(id: $id, complaintId: $complaintId, questionLabel: $questionLabel, options: $options, sentenceTemplate: $sentenceTemplate, isMultiSelect: $isMultiSelect, sequenceOrder: $sequenceOrder)';
}


}

/// @nodoc
abstract mixin class $ComplaintSubQuestionModelCopyWith<$Res>  {
  factory $ComplaintSubQuestionModelCopyWith(ComplaintSubQuestionModel value, $Res Function(ComplaintSubQuestionModel) _then) = _$ComplaintSubQuestionModelCopyWithImpl;
@useResult
$Res call({
 String id, String complaintId, String questionLabel, List<String> options, String sentenceTemplate, bool isMultiSelect, int sequenceOrder
});




}
/// @nodoc
class _$ComplaintSubQuestionModelCopyWithImpl<$Res>
    implements $ComplaintSubQuestionModelCopyWith<$Res> {
  _$ComplaintSubQuestionModelCopyWithImpl(this._self, this._then);

  final ComplaintSubQuestionModel _self;
  final $Res Function(ComplaintSubQuestionModel) _then;

/// Create a copy of ComplaintSubQuestionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? complaintId = null,Object? questionLabel = null,Object? options = null,Object? sentenceTemplate = null,Object? isMultiSelect = null,Object? sequenceOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,complaintId: null == complaintId ? _self.complaintId : complaintId // ignore: cast_nullable_to_non_nullable
as String,questionLabel: null == questionLabel ? _self.questionLabel : questionLabel // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,sentenceTemplate: null == sentenceTemplate ? _self.sentenceTemplate : sentenceTemplate // ignore: cast_nullable_to_non_nullable
as String,isMultiSelect: null == isMultiSelect ? _self.isMultiSelect : isMultiSelect // ignore: cast_nullable_to_non_nullable
as bool,sequenceOrder: null == sequenceOrder ? _self.sequenceOrder : sequenceOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplaintSubQuestionModel].
extension ComplaintSubQuestionModelPatterns on ComplaintSubQuestionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintSubQuestionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintSubQuestionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintSubQuestionModel value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintSubQuestionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintSubQuestionModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintSubQuestionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String complaintId,  String questionLabel,  List<String> options,  String sentenceTemplate,  bool isMultiSelect,  int sequenceOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintSubQuestionModel() when $default != null:
return $default(_that.id,_that.complaintId,_that.questionLabel,_that.options,_that.sentenceTemplate,_that.isMultiSelect,_that.sequenceOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String complaintId,  String questionLabel,  List<String> options,  String sentenceTemplate,  bool isMultiSelect,  int sequenceOrder)  $default,) {final _that = this;
switch (_that) {
case _ComplaintSubQuestionModel():
return $default(_that.id,_that.complaintId,_that.questionLabel,_that.options,_that.sentenceTemplate,_that.isMultiSelect,_that.sequenceOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String complaintId,  String questionLabel,  List<String> options,  String sentenceTemplate,  bool isMultiSelect,  int sequenceOrder)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintSubQuestionModel() when $default != null:
return $default(_that.id,_that.complaintId,_that.questionLabel,_that.options,_that.sentenceTemplate,_that.isMultiSelect,_that.sequenceOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplaintSubQuestionModel implements ComplaintSubQuestionModel {
  const _ComplaintSubQuestionModel({required this.id, required this.complaintId, required this.questionLabel, final  List<String> options = const [], this.sentenceTemplate = '', this.isMultiSelect = false, this.sequenceOrder = 0}): _options = options;
  factory _ComplaintSubQuestionModel.fromJson(Map<String, dynamic> json) => _$ComplaintSubQuestionModelFromJson(json);

@override final  String id;
@override final  String complaintId;
@override final  String questionLabel;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override@JsonKey() final  String sentenceTemplate;
@override@JsonKey() final  bool isMultiSelect;
@override@JsonKey() final  int sequenceOrder;

/// Create a copy of ComplaintSubQuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintSubQuestionModelCopyWith<_ComplaintSubQuestionModel> get copyWith => __$ComplaintSubQuestionModelCopyWithImpl<_ComplaintSubQuestionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintSubQuestionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintSubQuestionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.complaintId, complaintId) || other.complaintId == complaintId)&&(identical(other.questionLabel, questionLabel) || other.questionLabel == questionLabel)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.sentenceTemplate, sentenceTemplate) || other.sentenceTemplate == sentenceTemplate)&&(identical(other.isMultiSelect, isMultiSelect) || other.isMultiSelect == isMultiSelect)&&(identical(other.sequenceOrder, sequenceOrder) || other.sequenceOrder == sequenceOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,complaintId,questionLabel,const DeepCollectionEquality().hash(_options),sentenceTemplate,isMultiSelect,sequenceOrder);

@override
String toString() {
  return 'ComplaintSubQuestionModel(id: $id, complaintId: $complaintId, questionLabel: $questionLabel, options: $options, sentenceTemplate: $sentenceTemplate, isMultiSelect: $isMultiSelect, sequenceOrder: $sequenceOrder)';
}


}

/// @nodoc
abstract mixin class _$ComplaintSubQuestionModelCopyWith<$Res> implements $ComplaintSubQuestionModelCopyWith<$Res> {
  factory _$ComplaintSubQuestionModelCopyWith(_ComplaintSubQuestionModel value, $Res Function(_ComplaintSubQuestionModel) _then) = __$ComplaintSubQuestionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String complaintId, String questionLabel, List<String> options, String sentenceTemplate, bool isMultiSelect, int sequenceOrder
});




}
/// @nodoc
class __$ComplaintSubQuestionModelCopyWithImpl<$Res>
    implements _$ComplaintSubQuestionModelCopyWith<$Res> {
  __$ComplaintSubQuestionModelCopyWithImpl(this._self, this._then);

  final _ComplaintSubQuestionModel _self;
  final $Res Function(_ComplaintSubQuestionModel) _then;

/// Create a copy of ComplaintSubQuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? complaintId = null,Object? questionLabel = null,Object? options = null,Object? sentenceTemplate = null,Object? isMultiSelect = null,Object? sequenceOrder = null,}) {
  return _then(_ComplaintSubQuestionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,complaintId: null == complaintId ? _self.complaintId : complaintId // ignore: cast_nullable_to_non_nullable
as String,questionLabel: null == questionLabel ? _self.questionLabel : questionLabel // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,sentenceTemplate: null == sentenceTemplate ? _self.sentenceTemplate : sentenceTemplate // ignore: cast_nullable_to_non_nullable
as String,isMultiSelect: null == isMultiSelect ? _self.isMultiSelect : isMultiSelect // ignore: cast_nullable_to_non_nullable
as bool,sequenceOrder: null == sequenceOrder ? _self.sequenceOrder : sequenceOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PresentingComplaintModel {

 String get id; String get name; String get category; int get displayOrder; List<ComplaintSubQuestionModel> get subQuestions;
/// Create a copy of PresentingComplaintModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresentingComplaintModelCopyWith<PresentingComplaintModel> get copyWith => _$PresentingComplaintModelCopyWithImpl<PresentingComplaintModel>(this as PresentingComplaintModel, _$identity);

  /// Serializes this PresentingComplaintModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresentingComplaintModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&const DeepCollectionEquality().equals(other.subQuestions, subQuestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,displayOrder,const DeepCollectionEquality().hash(subQuestions));

@override
String toString() {
  return 'PresentingComplaintModel(id: $id, name: $name, category: $category, displayOrder: $displayOrder, subQuestions: $subQuestions)';
}


}

/// @nodoc
abstract mixin class $PresentingComplaintModelCopyWith<$Res>  {
  factory $PresentingComplaintModelCopyWith(PresentingComplaintModel value, $Res Function(PresentingComplaintModel) _then) = _$PresentingComplaintModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String category, int displayOrder, List<ComplaintSubQuestionModel> subQuestions
});




}
/// @nodoc
class _$PresentingComplaintModelCopyWithImpl<$Res>
    implements $PresentingComplaintModelCopyWith<$Res> {
  _$PresentingComplaintModelCopyWithImpl(this._self, this._then);

  final PresentingComplaintModel _self;
  final $Res Function(PresentingComplaintModel) _then;

/// Create a copy of PresentingComplaintModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? displayOrder = null,Object? subQuestions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,subQuestions: null == subQuestions ? _self.subQuestions : subQuestions // ignore: cast_nullable_to_non_nullable
as List<ComplaintSubQuestionModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PresentingComplaintModel].
extension PresentingComplaintModelPatterns on PresentingComplaintModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresentingComplaintModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresentingComplaintModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresentingComplaintModel value)  $default,){
final _that = this;
switch (_that) {
case _PresentingComplaintModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresentingComplaintModel value)?  $default,){
final _that = this;
switch (_that) {
case _PresentingComplaintModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String category,  int displayOrder,  List<ComplaintSubQuestionModel> subQuestions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresentingComplaintModel() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.displayOrder,_that.subQuestions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String category,  int displayOrder,  List<ComplaintSubQuestionModel> subQuestions)  $default,) {final _that = this;
switch (_that) {
case _PresentingComplaintModel():
return $default(_that.id,_that.name,_that.category,_that.displayOrder,_that.subQuestions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String category,  int displayOrder,  List<ComplaintSubQuestionModel> subQuestions)?  $default,) {final _that = this;
switch (_that) {
case _PresentingComplaintModel() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.displayOrder,_that.subQuestions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PresentingComplaintModel implements PresentingComplaintModel {
  const _PresentingComplaintModel({required this.id, required this.name, required this.category, this.displayOrder = 0, final  List<ComplaintSubQuestionModel> subQuestions = const []}): _subQuestions = subQuestions;
  factory _PresentingComplaintModel.fromJson(Map<String, dynamic> json) => _$PresentingComplaintModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String category;
@override@JsonKey() final  int displayOrder;
 final  List<ComplaintSubQuestionModel> _subQuestions;
@override@JsonKey() List<ComplaintSubQuestionModel> get subQuestions {
  if (_subQuestions is EqualUnmodifiableListView) return _subQuestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subQuestions);
}


/// Create a copy of PresentingComplaintModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresentingComplaintModelCopyWith<_PresentingComplaintModel> get copyWith => __$PresentingComplaintModelCopyWithImpl<_PresentingComplaintModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PresentingComplaintModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresentingComplaintModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&const DeepCollectionEquality().equals(other._subQuestions, _subQuestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,displayOrder,const DeepCollectionEquality().hash(_subQuestions));

@override
String toString() {
  return 'PresentingComplaintModel(id: $id, name: $name, category: $category, displayOrder: $displayOrder, subQuestions: $subQuestions)';
}


}

/// @nodoc
abstract mixin class _$PresentingComplaintModelCopyWith<$Res> implements $PresentingComplaintModelCopyWith<$Res> {
  factory _$PresentingComplaintModelCopyWith(_PresentingComplaintModel value, $Res Function(_PresentingComplaintModel) _then) = __$PresentingComplaintModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String category, int displayOrder, List<ComplaintSubQuestionModel> subQuestions
});




}
/// @nodoc
class __$PresentingComplaintModelCopyWithImpl<$Res>
    implements _$PresentingComplaintModelCopyWith<$Res> {
  __$PresentingComplaintModelCopyWithImpl(this._self, this._then);

  final _PresentingComplaintModel _self;
  final $Res Function(_PresentingComplaintModel) _then;

/// Create a copy of PresentingComplaintModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? displayOrder = null,Object? subQuestions = null,}) {
  return _then(_PresentingComplaintModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,subQuestions: null == subQuestions ? _self._subQuestions : subQuestions // ignore: cast_nullable_to_non_nullable
as List<ComplaintSubQuestionModel>,
  ));
}


}


/// @nodoc
mixin _$SelectedComplaintState {

 String get complaintId; String get complaintName; Map<String, List<String>> get selectedOptions;// subQuestionId -> options
 String get compiledProse;
/// Create a copy of SelectedComplaintState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedComplaintStateCopyWith<SelectedComplaintState> get copyWith => _$SelectedComplaintStateCopyWithImpl<SelectedComplaintState>(this as SelectedComplaintState, _$identity);

  /// Serializes this SelectedComplaintState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedComplaintState&&(identical(other.complaintId, complaintId) || other.complaintId == complaintId)&&(identical(other.complaintName, complaintName) || other.complaintName == complaintName)&&const DeepCollectionEquality().equals(other.selectedOptions, selectedOptions)&&(identical(other.compiledProse, compiledProse) || other.compiledProse == compiledProse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,complaintId,complaintName,const DeepCollectionEquality().hash(selectedOptions),compiledProse);

@override
String toString() {
  return 'SelectedComplaintState(complaintId: $complaintId, complaintName: $complaintName, selectedOptions: $selectedOptions, compiledProse: $compiledProse)';
}


}

/// @nodoc
abstract mixin class $SelectedComplaintStateCopyWith<$Res>  {
  factory $SelectedComplaintStateCopyWith(SelectedComplaintState value, $Res Function(SelectedComplaintState) _then) = _$SelectedComplaintStateCopyWithImpl;
@useResult
$Res call({
 String complaintId, String complaintName, Map<String, List<String>> selectedOptions, String compiledProse
});




}
/// @nodoc
class _$SelectedComplaintStateCopyWithImpl<$Res>
    implements $SelectedComplaintStateCopyWith<$Res> {
  _$SelectedComplaintStateCopyWithImpl(this._self, this._then);

  final SelectedComplaintState _self;
  final $Res Function(SelectedComplaintState) _then;

/// Create a copy of SelectedComplaintState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? complaintId = null,Object? complaintName = null,Object? selectedOptions = null,Object? compiledProse = null,}) {
  return _then(_self.copyWith(
complaintId: null == complaintId ? _self.complaintId : complaintId // ignore: cast_nullable_to_non_nullable
as String,complaintName: null == complaintName ? _self.complaintName : complaintName // ignore: cast_nullable_to_non_nullable
as String,selectedOptions: null == selectedOptions ? _self.selectedOptions : selectedOptions // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,compiledProse: null == compiledProse ? _self.compiledProse : compiledProse // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectedComplaintState].
extension SelectedComplaintStatePatterns on SelectedComplaintState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectedComplaintState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedComplaintState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectedComplaintState value)  $default,){
final _that = this;
switch (_that) {
case _SelectedComplaintState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectedComplaintState value)?  $default,){
final _that = this;
switch (_that) {
case _SelectedComplaintState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String complaintId,  String complaintName,  Map<String, List<String>> selectedOptions,  String compiledProse)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedComplaintState() when $default != null:
return $default(_that.complaintId,_that.complaintName,_that.selectedOptions,_that.compiledProse);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String complaintId,  String complaintName,  Map<String, List<String>> selectedOptions,  String compiledProse)  $default,) {final _that = this;
switch (_that) {
case _SelectedComplaintState():
return $default(_that.complaintId,_that.complaintName,_that.selectedOptions,_that.compiledProse);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String complaintId,  String complaintName,  Map<String, List<String>> selectedOptions,  String compiledProse)?  $default,) {final _that = this;
switch (_that) {
case _SelectedComplaintState() when $default != null:
return $default(_that.complaintId,_that.complaintName,_that.selectedOptions,_that.compiledProse);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SelectedComplaintState implements SelectedComplaintState {
  const _SelectedComplaintState({required this.complaintId, required this.complaintName, final  Map<String, List<String>> selectedOptions = const {}, this.compiledProse = ''}): _selectedOptions = selectedOptions;
  factory _SelectedComplaintState.fromJson(Map<String, dynamic> json) => _$SelectedComplaintStateFromJson(json);

@override final  String complaintId;
@override final  String complaintName;
 final  Map<String, List<String>> _selectedOptions;
@override@JsonKey() Map<String, List<String>> get selectedOptions {
  if (_selectedOptions is EqualUnmodifiableMapView) return _selectedOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_selectedOptions);
}

// subQuestionId -> options
@override@JsonKey() final  String compiledProse;

/// Create a copy of SelectedComplaintState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedComplaintStateCopyWith<_SelectedComplaintState> get copyWith => __$SelectedComplaintStateCopyWithImpl<_SelectedComplaintState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SelectedComplaintStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedComplaintState&&(identical(other.complaintId, complaintId) || other.complaintId == complaintId)&&(identical(other.complaintName, complaintName) || other.complaintName == complaintName)&&const DeepCollectionEquality().equals(other._selectedOptions, _selectedOptions)&&(identical(other.compiledProse, compiledProse) || other.compiledProse == compiledProse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,complaintId,complaintName,const DeepCollectionEquality().hash(_selectedOptions),compiledProse);

@override
String toString() {
  return 'SelectedComplaintState(complaintId: $complaintId, complaintName: $complaintName, selectedOptions: $selectedOptions, compiledProse: $compiledProse)';
}


}

/// @nodoc
abstract mixin class _$SelectedComplaintStateCopyWith<$Res> implements $SelectedComplaintStateCopyWith<$Res> {
  factory _$SelectedComplaintStateCopyWith(_SelectedComplaintState value, $Res Function(_SelectedComplaintState) _then) = __$SelectedComplaintStateCopyWithImpl;
@override @useResult
$Res call({
 String complaintId, String complaintName, Map<String, List<String>> selectedOptions, String compiledProse
});




}
/// @nodoc
class __$SelectedComplaintStateCopyWithImpl<$Res>
    implements _$SelectedComplaintStateCopyWith<$Res> {
  __$SelectedComplaintStateCopyWithImpl(this._self, this._then);

  final _SelectedComplaintState _self;
  final $Res Function(_SelectedComplaintState) _then;

/// Create a copy of SelectedComplaintState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? complaintId = null,Object? complaintName = null,Object? selectedOptions = null,Object? compiledProse = null,}) {
  return _then(_SelectedComplaintState(
complaintId: null == complaintId ? _self.complaintId : complaintId // ignore: cast_nullable_to_non_nullable
as String,complaintName: null == complaintName ? _self.complaintName : complaintName // ignore: cast_nullable_to_non_nullable
as String,selectedOptions: null == selectedOptions ? _self._selectedOptions : selectedOptions // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,compiledProse: null == compiledProse ? _self.compiledProse : compiledProse // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ExamSystemModel {

 String get id; String get systemName; String get defaultNormalText; List<String> get abnormalFindings;
/// Create a copy of ExamSystemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamSystemModelCopyWith<ExamSystemModel> get copyWith => _$ExamSystemModelCopyWithImpl<ExamSystemModel>(this as ExamSystemModel, _$identity);

  /// Serializes this ExamSystemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamSystemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.systemName, systemName) || other.systemName == systemName)&&(identical(other.defaultNormalText, defaultNormalText) || other.defaultNormalText == defaultNormalText)&&const DeepCollectionEquality().equals(other.abnormalFindings, abnormalFindings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,systemName,defaultNormalText,const DeepCollectionEquality().hash(abnormalFindings));

@override
String toString() {
  return 'ExamSystemModel(id: $id, systemName: $systemName, defaultNormalText: $defaultNormalText, abnormalFindings: $abnormalFindings)';
}


}

/// @nodoc
abstract mixin class $ExamSystemModelCopyWith<$Res>  {
  factory $ExamSystemModelCopyWith(ExamSystemModel value, $Res Function(ExamSystemModel) _then) = _$ExamSystemModelCopyWithImpl;
@useResult
$Res call({
 String id, String systemName, String defaultNormalText, List<String> abnormalFindings
});




}
/// @nodoc
class _$ExamSystemModelCopyWithImpl<$Res>
    implements $ExamSystemModelCopyWith<$Res> {
  _$ExamSystemModelCopyWithImpl(this._self, this._then);

  final ExamSystemModel _self;
  final $Res Function(ExamSystemModel) _then;

/// Create a copy of ExamSystemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? systemName = null,Object? defaultNormalText = null,Object? abnormalFindings = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,systemName: null == systemName ? _self.systemName : systemName // ignore: cast_nullable_to_non_nullable
as String,defaultNormalText: null == defaultNormalText ? _self.defaultNormalText : defaultNormalText // ignore: cast_nullable_to_non_nullable
as String,abnormalFindings: null == abnormalFindings ? _self.abnormalFindings : abnormalFindings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamSystemModel].
extension ExamSystemModelPatterns on ExamSystemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamSystemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamSystemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamSystemModel value)  $default,){
final _that = this;
switch (_that) {
case _ExamSystemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamSystemModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExamSystemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String systemName,  String defaultNormalText,  List<String> abnormalFindings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamSystemModel() when $default != null:
return $default(_that.id,_that.systemName,_that.defaultNormalText,_that.abnormalFindings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String systemName,  String defaultNormalText,  List<String> abnormalFindings)  $default,) {final _that = this;
switch (_that) {
case _ExamSystemModel():
return $default(_that.id,_that.systemName,_that.defaultNormalText,_that.abnormalFindings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String systemName,  String defaultNormalText,  List<String> abnormalFindings)?  $default,) {final _that = this;
switch (_that) {
case _ExamSystemModel() when $default != null:
return $default(_that.id,_that.systemName,_that.defaultNormalText,_that.abnormalFindings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamSystemModel implements ExamSystemModel {
  const _ExamSystemModel({required this.id, required this.systemName, required this.defaultNormalText, final  List<String> abnormalFindings = const []}): _abnormalFindings = abnormalFindings;
  factory _ExamSystemModel.fromJson(Map<String, dynamic> json) => _$ExamSystemModelFromJson(json);

@override final  String id;
@override final  String systemName;
@override final  String defaultNormalText;
 final  List<String> _abnormalFindings;
@override@JsonKey() List<String> get abnormalFindings {
  if (_abnormalFindings is EqualUnmodifiableListView) return _abnormalFindings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_abnormalFindings);
}


/// Create a copy of ExamSystemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamSystemModelCopyWith<_ExamSystemModel> get copyWith => __$ExamSystemModelCopyWithImpl<_ExamSystemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamSystemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamSystemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.systemName, systemName) || other.systemName == systemName)&&(identical(other.defaultNormalText, defaultNormalText) || other.defaultNormalText == defaultNormalText)&&const DeepCollectionEquality().equals(other._abnormalFindings, _abnormalFindings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,systemName,defaultNormalText,const DeepCollectionEquality().hash(_abnormalFindings));

@override
String toString() {
  return 'ExamSystemModel(id: $id, systemName: $systemName, defaultNormalText: $defaultNormalText, abnormalFindings: $abnormalFindings)';
}


}

/// @nodoc
abstract mixin class _$ExamSystemModelCopyWith<$Res> implements $ExamSystemModelCopyWith<$Res> {
  factory _$ExamSystemModelCopyWith(_ExamSystemModel value, $Res Function(_ExamSystemModel) _then) = __$ExamSystemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String systemName, String defaultNormalText, List<String> abnormalFindings
});




}
/// @nodoc
class __$ExamSystemModelCopyWithImpl<$Res>
    implements _$ExamSystemModelCopyWith<$Res> {
  __$ExamSystemModelCopyWithImpl(this._self, this._then);

  final _ExamSystemModel _self;
  final $Res Function(_ExamSystemModel) _then;

/// Create a copy of ExamSystemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? systemName = null,Object? defaultNormalText = null,Object? abnormalFindings = null,}) {
  return _then(_ExamSystemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,systemName: null == systemName ? _self.systemName : systemName // ignore: cast_nullable_to_non_nullable
as String,defaultNormalText: null == defaultNormalText ? _self.defaultNormalText : defaultNormalText // ignore: cast_nullable_to_non_nullable
as String,abnormalFindings: null == abnormalFindings ? _self._abnormalFindings : abnormalFindings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ExamSystemState {

 String get systemId; String get systemName; bool get isNormal; List<String> get selectedAbnormals; String? get customNotes; String get compiledText;
/// Create a copy of ExamSystemState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamSystemStateCopyWith<ExamSystemState> get copyWith => _$ExamSystemStateCopyWithImpl<ExamSystemState>(this as ExamSystemState, _$identity);

  /// Serializes this ExamSystemState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamSystemState&&(identical(other.systemId, systemId) || other.systemId == systemId)&&(identical(other.systemName, systemName) || other.systemName == systemName)&&(identical(other.isNormal, isNormal) || other.isNormal == isNormal)&&const DeepCollectionEquality().equals(other.selectedAbnormals, selectedAbnormals)&&(identical(other.customNotes, customNotes) || other.customNotes == customNotes)&&(identical(other.compiledText, compiledText) || other.compiledText == compiledText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,systemId,systemName,isNormal,const DeepCollectionEquality().hash(selectedAbnormals),customNotes,compiledText);

@override
String toString() {
  return 'ExamSystemState(systemId: $systemId, systemName: $systemName, isNormal: $isNormal, selectedAbnormals: $selectedAbnormals, customNotes: $customNotes, compiledText: $compiledText)';
}


}

/// @nodoc
abstract mixin class $ExamSystemStateCopyWith<$Res>  {
  factory $ExamSystemStateCopyWith(ExamSystemState value, $Res Function(ExamSystemState) _then) = _$ExamSystemStateCopyWithImpl;
@useResult
$Res call({
 String systemId, String systemName, bool isNormal, List<String> selectedAbnormals, String? customNotes, String compiledText
});




}
/// @nodoc
class _$ExamSystemStateCopyWithImpl<$Res>
    implements $ExamSystemStateCopyWith<$Res> {
  _$ExamSystemStateCopyWithImpl(this._self, this._then);

  final ExamSystemState _self;
  final $Res Function(ExamSystemState) _then;

/// Create a copy of ExamSystemState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? systemId = null,Object? systemName = null,Object? isNormal = null,Object? selectedAbnormals = null,Object? customNotes = freezed,Object? compiledText = null,}) {
  return _then(_self.copyWith(
systemId: null == systemId ? _self.systemId : systemId // ignore: cast_nullable_to_non_nullable
as String,systemName: null == systemName ? _self.systemName : systemName // ignore: cast_nullable_to_non_nullable
as String,isNormal: null == isNormal ? _self.isNormal : isNormal // ignore: cast_nullable_to_non_nullable
as bool,selectedAbnormals: null == selectedAbnormals ? _self.selectedAbnormals : selectedAbnormals // ignore: cast_nullable_to_non_nullable
as List<String>,customNotes: freezed == customNotes ? _self.customNotes : customNotes // ignore: cast_nullable_to_non_nullable
as String?,compiledText: null == compiledText ? _self.compiledText : compiledText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamSystemState].
extension ExamSystemStatePatterns on ExamSystemState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamSystemState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamSystemState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamSystemState value)  $default,){
final _that = this;
switch (_that) {
case _ExamSystemState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamSystemState value)?  $default,){
final _that = this;
switch (_that) {
case _ExamSystemState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String systemId,  String systemName,  bool isNormal,  List<String> selectedAbnormals,  String? customNotes,  String compiledText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamSystemState() when $default != null:
return $default(_that.systemId,_that.systemName,_that.isNormal,_that.selectedAbnormals,_that.customNotes,_that.compiledText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String systemId,  String systemName,  bool isNormal,  List<String> selectedAbnormals,  String? customNotes,  String compiledText)  $default,) {final _that = this;
switch (_that) {
case _ExamSystemState():
return $default(_that.systemId,_that.systemName,_that.isNormal,_that.selectedAbnormals,_that.customNotes,_that.compiledText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String systemId,  String systemName,  bool isNormal,  List<String> selectedAbnormals,  String? customNotes,  String compiledText)?  $default,) {final _that = this;
switch (_that) {
case _ExamSystemState() when $default != null:
return $default(_that.systemId,_that.systemName,_that.isNormal,_that.selectedAbnormals,_that.customNotes,_that.compiledText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamSystemState implements ExamSystemState {
  const _ExamSystemState({required this.systemId, required this.systemName, this.isNormal = true, final  List<String> selectedAbnormals = const [], this.customNotes, this.compiledText = ''}): _selectedAbnormals = selectedAbnormals;
  factory _ExamSystemState.fromJson(Map<String, dynamic> json) => _$ExamSystemStateFromJson(json);

@override final  String systemId;
@override final  String systemName;
@override@JsonKey() final  bool isNormal;
 final  List<String> _selectedAbnormals;
@override@JsonKey() List<String> get selectedAbnormals {
  if (_selectedAbnormals is EqualUnmodifiableListView) return _selectedAbnormals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedAbnormals);
}

@override final  String? customNotes;
@override@JsonKey() final  String compiledText;

/// Create a copy of ExamSystemState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamSystemStateCopyWith<_ExamSystemState> get copyWith => __$ExamSystemStateCopyWithImpl<_ExamSystemState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamSystemStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamSystemState&&(identical(other.systemId, systemId) || other.systemId == systemId)&&(identical(other.systemName, systemName) || other.systemName == systemName)&&(identical(other.isNormal, isNormal) || other.isNormal == isNormal)&&const DeepCollectionEquality().equals(other._selectedAbnormals, _selectedAbnormals)&&(identical(other.customNotes, customNotes) || other.customNotes == customNotes)&&(identical(other.compiledText, compiledText) || other.compiledText == compiledText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,systemId,systemName,isNormal,const DeepCollectionEquality().hash(_selectedAbnormals),customNotes,compiledText);

@override
String toString() {
  return 'ExamSystemState(systemId: $systemId, systemName: $systemName, isNormal: $isNormal, selectedAbnormals: $selectedAbnormals, customNotes: $customNotes, compiledText: $compiledText)';
}


}

/// @nodoc
abstract mixin class _$ExamSystemStateCopyWith<$Res> implements $ExamSystemStateCopyWith<$Res> {
  factory _$ExamSystemStateCopyWith(_ExamSystemState value, $Res Function(_ExamSystemState) _then) = __$ExamSystemStateCopyWithImpl;
@override @useResult
$Res call({
 String systemId, String systemName, bool isNormal, List<String> selectedAbnormals, String? customNotes, String compiledText
});




}
/// @nodoc
class __$ExamSystemStateCopyWithImpl<$Res>
    implements _$ExamSystemStateCopyWith<$Res> {
  __$ExamSystemStateCopyWithImpl(this._self, this._then);

  final _ExamSystemState _self;
  final $Res Function(_ExamSystemState) _then;

/// Create a copy of ExamSystemState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? systemId = null,Object? systemName = null,Object? isNormal = null,Object? selectedAbnormals = null,Object? customNotes = freezed,Object? compiledText = null,}) {
  return _then(_ExamSystemState(
systemId: null == systemId ? _self.systemId : systemId // ignore: cast_nullable_to_non_nullable
as String,systemName: null == systemName ? _self.systemName : systemName // ignore: cast_nullable_to_non_nullable
as String,isNormal: null == isNormal ? _self.isNormal : isNormal // ignore: cast_nullable_to_non_nullable
as bool,selectedAbnormals: null == selectedAbnormals ? _self._selectedAbnormals : selectedAbnormals // ignore: cast_nullable_to_non_nullable
as List<String>,customNotes: freezed == customNotes ? _self.customNotes : customNotes // ignore: cast_nullable_to_non_nullable
as String?,compiledText: null == compiledText ? _self.compiledText : compiledText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DiagnosisModel {

 String get id; String get name; String? get icd10Code; List<String> get linkedComplaintIds;
/// Create a copy of DiagnosisModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiagnosisModelCopyWith<DiagnosisModel> get copyWith => _$DiagnosisModelCopyWithImpl<DiagnosisModel>(this as DiagnosisModel, _$identity);

  /// Serializes this DiagnosisModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiagnosisModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icd10Code, icd10Code) || other.icd10Code == icd10Code)&&const DeepCollectionEquality().equals(other.linkedComplaintIds, linkedComplaintIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icd10Code,const DeepCollectionEquality().hash(linkedComplaintIds));

@override
String toString() {
  return 'DiagnosisModel(id: $id, name: $name, icd10Code: $icd10Code, linkedComplaintIds: $linkedComplaintIds)';
}


}

/// @nodoc
abstract mixin class $DiagnosisModelCopyWith<$Res>  {
  factory $DiagnosisModelCopyWith(DiagnosisModel value, $Res Function(DiagnosisModel) _then) = _$DiagnosisModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? icd10Code, List<String> linkedComplaintIds
});




}
/// @nodoc
class _$DiagnosisModelCopyWithImpl<$Res>
    implements $DiagnosisModelCopyWith<$Res> {
  _$DiagnosisModelCopyWithImpl(this._self, this._then);

  final DiagnosisModel _self;
  final $Res Function(DiagnosisModel) _then;

/// Create a copy of DiagnosisModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? icd10Code = freezed,Object? linkedComplaintIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icd10Code: freezed == icd10Code ? _self.icd10Code : icd10Code // ignore: cast_nullable_to_non_nullable
as String?,linkedComplaintIds: null == linkedComplaintIds ? _self.linkedComplaintIds : linkedComplaintIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DiagnosisModel].
extension DiagnosisModelPatterns on DiagnosisModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiagnosisModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiagnosisModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiagnosisModel value)  $default,){
final _that = this;
switch (_that) {
case _DiagnosisModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiagnosisModel value)?  $default,){
final _that = this;
switch (_that) {
case _DiagnosisModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? icd10Code,  List<String> linkedComplaintIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiagnosisModel() when $default != null:
return $default(_that.id,_that.name,_that.icd10Code,_that.linkedComplaintIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? icd10Code,  List<String> linkedComplaintIds)  $default,) {final _that = this;
switch (_that) {
case _DiagnosisModel():
return $default(_that.id,_that.name,_that.icd10Code,_that.linkedComplaintIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? icd10Code,  List<String> linkedComplaintIds)?  $default,) {final _that = this;
switch (_that) {
case _DiagnosisModel() when $default != null:
return $default(_that.id,_that.name,_that.icd10Code,_that.linkedComplaintIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiagnosisModel implements DiagnosisModel {
  const _DiagnosisModel({required this.id, required this.name, this.icd10Code, final  List<String> linkedComplaintIds = const []}): _linkedComplaintIds = linkedComplaintIds;
  factory _DiagnosisModel.fromJson(Map<String, dynamic> json) => _$DiagnosisModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? icd10Code;
 final  List<String> _linkedComplaintIds;
@override@JsonKey() List<String> get linkedComplaintIds {
  if (_linkedComplaintIds is EqualUnmodifiableListView) return _linkedComplaintIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_linkedComplaintIds);
}


/// Create a copy of DiagnosisModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiagnosisModelCopyWith<_DiagnosisModel> get copyWith => __$DiagnosisModelCopyWithImpl<_DiagnosisModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiagnosisModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiagnosisModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icd10Code, icd10Code) || other.icd10Code == icd10Code)&&const DeepCollectionEquality().equals(other._linkedComplaintIds, _linkedComplaintIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icd10Code,const DeepCollectionEquality().hash(_linkedComplaintIds));

@override
String toString() {
  return 'DiagnosisModel(id: $id, name: $name, icd10Code: $icd10Code, linkedComplaintIds: $linkedComplaintIds)';
}


}

/// @nodoc
abstract mixin class _$DiagnosisModelCopyWith<$Res> implements $DiagnosisModelCopyWith<$Res> {
  factory _$DiagnosisModelCopyWith(_DiagnosisModel value, $Res Function(_DiagnosisModel) _then) = __$DiagnosisModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? icd10Code, List<String> linkedComplaintIds
});




}
/// @nodoc
class __$DiagnosisModelCopyWithImpl<$Res>
    implements _$DiagnosisModelCopyWith<$Res> {
  __$DiagnosisModelCopyWithImpl(this._self, this._then);

  final _DiagnosisModel _self;
  final $Res Function(_DiagnosisModel) _then;

/// Create a copy of DiagnosisModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? icd10Code = freezed,Object? linkedComplaintIds = null,}) {
  return _then(_DiagnosisModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icd10Code: freezed == icd10Code ? _self.icd10Code : icd10Code // ignore: cast_nullable_to_non_nullable
as String?,linkedComplaintIds: null == linkedComplaintIds ? _self._linkedComplaintIds : linkedComplaintIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$DrugModel {

 String get id; String get genericName; String get brandName; String get drugClass; String get defaultDose; String get defaultRoute; String get defaultFrequency; String get defaultDuration; String get defaultInstructions;
/// Create a copy of DrugModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrugModelCopyWith<DrugModel> get copyWith => _$DrugModelCopyWithImpl<DrugModel>(this as DrugModel, _$identity);

  /// Serializes this DrugModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrugModel&&(identical(other.id, id) || other.id == id)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.drugClass, drugClass) || other.drugClass == drugClass)&&(identical(other.defaultDose, defaultDose) || other.defaultDose == defaultDose)&&(identical(other.defaultRoute, defaultRoute) || other.defaultRoute == defaultRoute)&&(identical(other.defaultFrequency, defaultFrequency) || other.defaultFrequency == defaultFrequency)&&(identical(other.defaultDuration, defaultDuration) || other.defaultDuration == defaultDuration)&&(identical(other.defaultInstructions, defaultInstructions) || other.defaultInstructions == defaultInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,genericName,brandName,drugClass,defaultDose,defaultRoute,defaultFrequency,defaultDuration,defaultInstructions);

@override
String toString() {
  return 'DrugModel(id: $id, genericName: $genericName, brandName: $brandName, drugClass: $drugClass, defaultDose: $defaultDose, defaultRoute: $defaultRoute, defaultFrequency: $defaultFrequency, defaultDuration: $defaultDuration, defaultInstructions: $defaultInstructions)';
}


}

/// @nodoc
abstract mixin class $DrugModelCopyWith<$Res>  {
  factory $DrugModelCopyWith(DrugModel value, $Res Function(DrugModel) _then) = _$DrugModelCopyWithImpl;
@useResult
$Res call({
 String id, String genericName, String brandName, String drugClass, String defaultDose, String defaultRoute, String defaultFrequency, String defaultDuration, String defaultInstructions
});




}
/// @nodoc
class _$DrugModelCopyWithImpl<$Res>
    implements $DrugModelCopyWith<$Res> {
  _$DrugModelCopyWithImpl(this._self, this._then);

  final DrugModel _self;
  final $Res Function(DrugModel) _then;

/// Create a copy of DrugModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? genericName = null,Object? brandName = null,Object? drugClass = null,Object? defaultDose = null,Object? defaultRoute = null,Object? defaultFrequency = null,Object? defaultDuration = null,Object? defaultInstructions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,genericName: null == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,drugClass: null == drugClass ? _self.drugClass : drugClass // ignore: cast_nullable_to_non_nullable
as String,defaultDose: null == defaultDose ? _self.defaultDose : defaultDose // ignore: cast_nullable_to_non_nullable
as String,defaultRoute: null == defaultRoute ? _self.defaultRoute : defaultRoute // ignore: cast_nullable_to_non_nullable
as String,defaultFrequency: null == defaultFrequency ? _self.defaultFrequency : defaultFrequency // ignore: cast_nullable_to_non_nullable
as String,defaultDuration: null == defaultDuration ? _self.defaultDuration : defaultDuration // ignore: cast_nullable_to_non_nullable
as String,defaultInstructions: null == defaultInstructions ? _self.defaultInstructions : defaultInstructions // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DrugModel].
extension DrugModelPatterns on DrugModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrugModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrugModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrugModel value)  $default,){
final _that = this;
switch (_that) {
case _DrugModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrugModel value)?  $default,){
final _that = this;
switch (_that) {
case _DrugModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String genericName,  String brandName,  String drugClass,  String defaultDose,  String defaultRoute,  String defaultFrequency,  String defaultDuration,  String defaultInstructions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrugModel() when $default != null:
return $default(_that.id,_that.genericName,_that.brandName,_that.drugClass,_that.defaultDose,_that.defaultRoute,_that.defaultFrequency,_that.defaultDuration,_that.defaultInstructions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String genericName,  String brandName,  String drugClass,  String defaultDose,  String defaultRoute,  String defaultFrequency,  String defaultDuration,  String defaultInstructions)  $default,) {final _that = this;
switch (_that) {
case _DrugModel():
return $default(_that.id,_that.genericName,_that.brandName,_that.drugClass,_that.defaultDose,_that.defaultRoute,_that.defaultFrequency,_that.defaultDuration,_that.defaultInstructions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String genericName,  String brandName,  String drugClass,  String defaultDose,  String defaultRoute,  String defaultFrequency,  String defaultDuration,  String defaultInstructions)?  $default,) {final _that = this;
switch (_that) {
case _DrugModel() when $default != null:
return $default(_that.id,_that.genericName,_that.brandName,_that.drugClass,_that.defaultDose,_that.defaultRoute,_that.defaultFrequency,_that.defaultDuration,_that.defaultInstructions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrugModel implements DrugModel {
  const _DrugModel({required this.id, required this.genericName, required this.brandName, required this.drugClass, required this.defaultDose, required this.defaultRoute, required this.defaultFrequency, required this.defaultDuration, required this.defaultInstructions});
  factory _DrugModel.fromJson(Map<String, dynamic> json) => _$DrugModelFromJson(json);

@override final  String id;
@override final  String genericName;
@override final  String brandName;
@override final  String drugClass;
@override final  String defaultDose;
@override final  String defaultRoute;
@override final  String defaultFrequency;
@override final  String defaultDuration;
@override final  String defaultInstructions;

/// Create a copy of DrugModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrugModelCopyWith<_DrugModel> get copyWith => __$DrugModelCopyWithImpl<_DrugModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrugModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrugModel&&(identical(other.id, id) || other.id == id)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.drugClass, drugClass) || other.drugClass == drugClass)&&(identical(other.defaultDose, defaultDose) || other.defaultDose == defaultDose)&&(identical(other.defaultRoute, defaultRoute) || other.defaultRoute == defaultRoute)&&(identical(other.defaultFrequency, defaultFrequency) || other.defaultFrequency == defaultFrequency)&&(identical(other.defaultDuration, defaultDuration) || other.defaultDuration == defaultDuration)&&(identical(other.defaultInstructions, defaultInstructions) || other.defaultInstructions == defaultInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,genericName,brandName,drugClass,defaultDose,defaultRoute,defaultFrequency,defaultDuration,defaultInstructions);

@override
String toString() {
  return 'DrugModel(id: $id, genericName: $genericName, brandName: $brandName, drugClass: $drugClass, defaultDose: $defaultDose, defaultRoute: $defaultRoute, defaultFrequency: $defaultFrequency, defaultDuration: $defaultDuration, defaultInstructions: $defaultInstructions)';
}


}

/// @nodoc
abstract mixin class _$DrugModelCopyWith<$Res> implements $DrugModelCopyWith<$Res> {
  factory _$DrugModelCopyWith(_DrugModel value, $Res Function(_DrugModel) _then) = __$DrugModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String genericName, String brandName, String drugClass, String defaultDose, String defaultRoute, String defaultFrequency, String defaultDuration, String defaultInstructions
});




}
/// @nodoc
class __$DrugModelCopyWithImpl<$Res>
    implements _$DrugModelCopyWith<$Res> {
  __$DrugModelCopyWithImpl(this._self, this._then);

  final _DrugModel _self;
  final $Res Function(_DrugModel) _then;

/// Create a copy of DrugModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? genericName = null,Object? brandName = null,Object? drugClass = null,Object? defaultDose = null,Object? defaultRoute = null,Object? defaultFrequency = null,Object? defaultDuration = null,Object? defaultInstructions = null,}) {
  return _then(_DrugModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,genericName: null == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,drugClass: null == drugClass ? _self.drugClass : drugClass // ignore: cast_nullable_to_non_nullable
as String,defaultDose: null == defaultDose ? _self.defaultDose : defaultDose // ignore: cast_nullable_to_non_nullable
as String,defaultRoute: null == defaultRoute ? _self.defaultRoute : defaultRoute // ignore: cast_nullable_to_non_nullable
as String,defaultFrequency: null == defaultFrequency ? _self.defaultFrequency : defaultFrequency // ignore: cast_nullable_to_non_nullable
as String,defaultDuration: null == defaultDuration ? _self.defaultDuration : defaultDuration // ignore: cast_nullable_to_non_nullable
as String,defaultInstructions: null == defaultInstructions ? _self.defaultInstructions : defaultInstructions // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PrescriptionItemModel {

 String get drugId; String get genericName; String get brandName; String get drugClass; String get dose; String get route; String get frequency; String get duration; String get instructions; bool get isCustom;
/// Create a copy of PrescriptionItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrescriptionItemModelCopyWith<PrescriptionItemModel> get copyWith => _$PrescriptionItemModelCopyWithImpl<PrescriptionItemModel>(this as PrescriptionItemModel, _$identity);

  /// Serializes this PrescriptionItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrescriptionItemModel&&(identical(other.drugId, drugId) || other.drugId == drugId)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.drugClass, drugClass) || other.drugClass == drugClass)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.route, route) || other.route == route)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,drugId,genericName,brandName,drugClass,dose,route,frequency,duration,instructions,isCustom);

@override
String toString() {
  return 'PrescriptionItemModel(drugId: $drugId, genericName: $genericName, brandName: $brandName, drugClass: $drugClass, dose: $dose, route: $route, frequency: $frequency, duration: $duration, instructions: $instructions, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class $PrescriptionItemModelCopyWith<$Res>  {
  factory $PrescriptionItemModelCopyWith(PrescriptionItemModel value, $Res Function(PrescriptionItemModel) _then) = _$PrescriptionItemModelCopyWithImpl;
@useResult
$Res call({
 String drugId, String genericName, String brandName, String drugClass, String dose, String route, String frequency, String duration, String instructions, bool isCustom
});




}
/// @nodoc
class _$PrescriptionItemModelCopyWithImpl<$Res>
    implements $PrescriptionItemModelCopyWith<$Res> {
  _$PrescriptionItemModelCopyWithImpl(this._self, this._then);

  final PrescriptionItemModel _self;
  final $Res Function(PrescriptionItemModel) _then;

/// Create a copy of PrescriptionItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drugId = null,Object? genericName = null,Object? brandName = null,Object? drugClass = null,Object? dose = null,Object? route = null,Object? frequency = null,Object? duration = null,Object? instructions = null,Object? isCustom = null,}) {
  return _then(_self.copyWith(
drugId: null == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String,genericName: null == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,drugClass: null == drugClass ? _self.drugClass : drugClass // ignore: cast_nullable_to_non_nullable
as String,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PrescriptionItemModel].
extension PrescriptionItemModelPatterns on PrescriptionItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrescriptionItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrescriptionItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrescriptionItemModel value)  $default,){
final _that = this;
switch (_that) {
case _PrescriptionItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrescriptionItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _PrescriptionItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String drugId,  String genericName,  String brandName,  String drugClass,  String dose,  String route,  String frequency,  String duration,  String instructions,  bool isCustom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrescriptionItemModel() when $default != null:
return $default(_that.drugId,_that.genericName,_that.brandName,_that.drugClass,_that.dose,_that.route,_that.frequency,_that.duration,_that.instructions,_that.isCustom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String drugId,  String genericName,  String brandName,  String drugClass,  String dose,  String route,  String frequency,  String duration,  String instructions,  bool isCustom)  $default,) {final _that = this;
switch (_that) {
case _PrescriptionItemModel():
return $default(_that.drugId,_that.genericName,_that.brandName,_that.drugClass,_that.dose,_that.route,_that.frequency,_that.duration,_that.instructions,_that.isCustom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String drugId,  String genericName,  String brandName,  String drugClass,  String dose,  String route,  String frequency,  String duration,  String instructions,  bool isCustom)?  $default,) {final _that = this;
switch (_that) {
case _PrescriptionItemModel() when $default != null:
return $default(_that.drugId,_that.genericName,_that.brandName,_that.drugClass,_that.dose,_that.route,_that.frequency,_that.duration,_that.instructions,_that.isCustom);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrescriptionItemModel implements PrescriptionItemModel {
  const _PrescriptionItemModel({required this.drugId, required this.genericName, required this.brandName, required this.drugClass, required this.dose, required this.route, required this.frequency, required this.duration, required this.instructions, this.isCustom = false});
  factory _PrescriptionItemModel.fromJson(Map<String, dynamic> json) => _$PrescriptionItemModelFromJson(json);

@override final  String drugId;
@override final  String genericName;
@override final  String brandName;
@override final  String drugClass;
@override final  String dose;
@override final  String route;
@override final  String frequency;
@override final  String duration;
@override final  String instructions;
@override@JsonKey() final  bool isCustom;

/// Create a copy of PrescriptionItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrescriptionItemModelCopyWith<_PrescriptionItemModel> get copyWith => __$PrescriptionItemModelCopyWithImpl<_PrescriptionItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrescriptionItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrescriptionItemModel&&(identical(other.drugId, drugId) || other.drugId == drugId)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.drugClass, drugClass) || other.drugClass == drugClass)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.route, route) || other.route == route)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,drugId,genericName,brandName,drugClass,dose,route,frequency,duration,instructions,isCustom);

@override
String toString() {
  return 'PrescriptionItemModel(drugId: $drugId, genericName: $genericName, brandName: $brandName, drugClass: $drugClass, dose: $dose, route: $route, frequency: $frequency, duration: $duration, instructions: $instructions, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class _$PrescriptionItemModelCopyWith<$Res> implements $PrescriptionItemModelCopyWith<$Res> {
  factory _$PrescriptionItemModelCopyWith(_PrescriptionItemModel value, $Res Function(_PrescriptionItemModel) _then) = __$PrescriptionItemModelCopyWithImpl;
@override @useResult
$Res call({
 String drugId, String genericName, String brandName, String drugClass, String dose, String route, String frequency, String duration, String instructions, bool isCustom
});




}
/// @nodoc
class __$PrescriptionItemModelCopyWithImpl<$Res>
    implements _$PrescriptionItemModelCopyWith<$Res> {
  __$PrescriptionItemModelCopyWithImpl(this._self, this._then);

  final _PrescriptionItemModel _self;
  final $Res Function(_PrescriptionItemModel) _then;

/// Create a copy of PrescriptionItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drugId = null,Object? genericName = null,Object? brandName = null,Object? drugClass = null,Object? dose = null,Object? route = null,Object? frequency = null,Object? duration = null,Object? instructions = null,Object? isCustom = null,}) {
  return _then(_PrescriptionItemModel(
drugId: null == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String,genericName: null == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,drugClass: null == drugClass ? _self.drugClass : drugClass // ignore: cast_nullable_to_non_nullable
as String,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProtocolItemEntry {

 String get drugId; String? get doseOverride; String? get frequencyOverride; String? get durationOverride; String? get instructionsOverride;
/// Create a copy of ProtocolItemEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProtocolItemEntryCopyWith<ProtocolItemEntry> get copyWith => _$ProtocolItemEntryCopyWithImpl<ProtocolItemEntry>(this as ProtocolItemEntry, _$identity);

  /// Serializes this ProtocolItemEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolItemEntry&&(identical(other.drugId, drugId) || other.drugId == drugId)&&(identical(other.doseOverride, doseOverride) || other.doseOverride == doseOverride)&&(identical(other.frequencyOverride, frequencyOverride) || other.frequencyOverride == frequencyOverride)&&(identical(other.durationOverride, durationOverride) || other.durationOverride == durationOverride)&&(identical(other.instructionsOverride, instructionsOverride) || other.instructionsOverride == instructionsOverride));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,drugId,doseOverride,frequencyOverride,durationOverride,instructionsOverride);

@override
String toString() {
  return 'ProtocolItemEntry(drugId: $drugId, doseOverride: $doseOverride, frequencyOverride: $frequencyOverride, durationOverride: $durationOverride, instructionsOverride: $instructionsOverride)';
}


}

/// @nodoc
abstract mixin class $ProtocolItemEntryCopyWith<$Res>  {
  factory $ProtocolItemEntryCopyWith(ProtocolItemEntry value, $Res Function(ProtocolItemEntry) _then) = _$ProtocolItemEntryCopyWithImpl;
@useResult
$Res call({
 String drugId, String? doseOverride, String? frequencyOverride, String? durationOverride, String? instructionsOverride
});




}
/// @nodoc
class _$ProtocolItemEntryCopyWithImpl<$Res>
    implements $ProtocolItemEntryCopyWith<$Res> {
  _$ProtocolItemEntryCopyWithImpl(this._self, this._then);

  final ProtocolItemEntry _self;
  final $Res Function(ProtocolItemEntry) _then;

/// Create a copy of ProtocolItemEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drugId = null,Object? doseOverride = freezed,Object? frequencyOverride = freezed,Object? durationOverride = freezed,Object? instructionsOverride = freezed,}) {
  return _then(_self.copyWith(
drugId: null == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String,doseOverride: freezed == doseOverride ? _self.doseOverride : doseOverride // ignore: cast_nullable_to_non_nullable
as String?,frequencyOverride: freezed == frequencyOverride ? _self.frequencyOverride : frequencyOverride // ignore: cast_nullable_to_non_nullable
as String?,durationOverride: freezed == durationOverride ? _self.durationOverride : durationOverride // ignore: cast_nullable_to_non_nullable
as String?,instructionsOverride: freezed == instructionsOverride ? _self.instructionsOverride : instructionsOverride // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProtocolItemEntry].
extension ProtocolItemEntryPatterns on ProtocolItemEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProtocolItemEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProtocolItemEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProtocolItemEntry value)  $default,){
final _that = this;
switch (_that) {
case _ProtocolItemEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProtocolItemEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ProtocolItemEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String drugId,  String? doseOverride,  String? frequencyOverride,  String? durationOverride,  String? instructionsOverride)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProtocolItemEntry() when $default != null:
return $default(_that.drugId,_that.doseOverride,_that.frequencyOverride,_that.durationOverride,_that.instructionsOverride);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String drugId,  String? doseOverride,  String? frequencyOverride,  String? durationOverride,  String? instructionsOverride)  $default,) {final _that = this;
switch (_that) {
case _ProtocolItemEntry():
return $default(_that.drugId,_that.doseOverride,_that.frequencyOverride,_that.durationOverride,_that.instructionsOverride);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String drugId,  String? doseOverride,  String? frequencyOverride,  String? durationOverride,  String? instructionsOverride)?  $default,) {final _that = this;
switch (_that) {
case _ProtocolItemEntry() when $default != null:
return $default(_that.drugId,_that.doseOverride,_that.frequencyOverride,_that.durationOverride,_that.instructionsOverride);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProtocolItemEntry implements ProtocolItemEntry {
  const _ProtocolItemEntry({required this.drugId, this.doseOverride, this.frequencyOverride, this.durationOverride, this.instructionsOverride});
  factory _ProtocolItemEntry.fromJson(Map<String, dynamic> json) => _$ProtocolItemEntryFromJson(json);

@override final  String drugId;
@override final  String? doseOverride;
@override final  String? frequencyOverride;
@override final  String? durationOverride;
@override final  String? instructionsOverride;

/// Create a copy of ProtocolItemEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProtocolItemEntryCopyWith<_ProtocolItemEntry> get copyWith => __$ProtocolItemEntryCopyWithImpl<_ProtocolItemEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProtocolItemEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProtocolItemEntry&&(identical(other.drugId, drugId) || other.drugId == drugId)&&(identical(other.doseOverride, doseOverride) || other.doseOverride == doseOverride)&&(identical(other.frequencyOverride, frequencyOverride) || other.frequencyOverride == frequencyOverride)&&(identical(other.durationOverride, durationOverride) || other.durationOverride == durationOverride)&&(identical(other.instructionsOverride, instructionsOverride) || other.instructionsOverride == instructionsOverride));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,drugId,doseOverride,frequencyOverride,durationOverride,instructionsOverride);

@override
String toString() {
  return 'ProtocolItemEntry(drugId: $drugId, doseOverride: $doseOverride, frequencyOverride: $frequencyOverride, durationOverride: $durationOverride, instructionsOverride: $instructionsOverride)';
}


}

/// @nodoc
abstract mixin class _$ProtocolItemEntryCopyWith<$Res> implements $ProtocolItemEntryCopyWith<$Res> {
  factory _$ProtocolItemEntryCopyWith(_ProtocolItemEntry value, $Res Function(_ProtocolItemEntry) _then) = __$ProtocolItemEntryCopyWithImpl;
@override @useResult
$Res call({
 String drugId, String? doseOverride, String? frequencyOverride, String? durationOverride, String? instructionsOverride
});




}
/// @nodoc
class __$ProtocolItemEntryCopyWithImpl<$Res>
    implements _$ProtocolItemEntryCopyWith<$Res> {
  __$ProtocolItemEntryCopyWithImpl(this._self, this._then);

  final _ProtocolItemEntry _self;
  final $Res Function(_ProtocolItemEntry) _then;

/// Create a copy of ProtocolItemEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drugId = null,Object? doseOverride = freezed,Object? frequencyOverride = freezed,Object? durationOverride = freezed,Object? instructionsOverride = freezed,}) {
  return _then(_ProtocolItemEntry(
drugId: null == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String,doseOverride: freezed == doseOverride ? _self.doseOverride : doseOverride // ignore: cast_nullable_to_non_nullable
as String?,frequencyOverride: freezed == frequencyOverride ? _self.frequencyOverride : frequencyOverride // ignore: cast_nullable_to_non_nullable
as String?,durationOverride: freezed == durationOverride ? _self.durationOverride : durationOverride // ignore: cast_nullable_to_non_nullable
as String?,instructionsOverride: freezed == instructionsOverride ? _self.instructionsOverride : instructionsOverride // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PrescriptionProtocolModel {

 String get id; String get diagnosisId; List<ProtocolItemEntry> get protocolItems; String get generalAdvice;
/// Create a copy of PrescriptionProtocolModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrescriptionProtocolModelCopyWith<PrescriptionProtocolModel> get copyWith => _$PrescriptionProtocolModelCopyWithImpl<PrescriptionProtocolModel>(this as PrescriptionProtocolModel, _$identity);

  /// Serializes this PrescriptionProtocolModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrescriptionProtocolModel&&(identical(other.id, id) || other.id == id)&&(identical(other.diagnosisId, diagnosisId) || other.diagnosisId == diagnosisId)&&const DeepCollectionEquality().equals(other.protocolItems, protocolItems)&&(identical(other.generalAdvice, generalAdvice) || other.generalAdvice == generalAdvice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,diagnosisId,const DeepCollectionEquality().hash(protocolItems),generalAdvice);

@override
String toString() {
  return 'PrescriptionProtocolModel(id: $id, diagnosisId: $diagnosisId, protocolItems: $protocolItems, generalAdvice: $generalAdvice)';
}


}

/// @nodoc
abstract mixin class $PrescriptionProtocolModelCopyWith<$Res>  {
  factory $PrescriptionProtocolModelCopyWith(PrescriptionProtocolModel value, $Res Function(PrescriptionProtocolModel) _then) = _$PrescriptionProtocolModelCopyWithImpl;
@useResult
$Res call({
 String id, String diagnosisId, List<ProtocolItemEntry> protocolItems, String generalAdvice
});




}
/// @nodoc
class _$PrescriptionProtocolModelCopyWithImpl<$Res>
    implements $PrescriptionProtocolModelCopyWith<$Res> {
  _$PrescriptionProtocolModelCopyWithImpl(this._self, this._then);

  final PrescriptionProtocolModel _self;
  final $Res Function(PrescriptionProtocolModel) _then;

/// Create a copy of PrescriptionProtocolModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? diagnosisId = null,Object? protocolItems = null,Object? generalAdvice = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,diagnosisId: null == diagnosisId ? _self.diagnosisId : diagnosisId // ignore: cast_nullable_to_non_nullable
as String,protocolItems: null == protocolItems ? _self.protocolItems : protocolItems // ignore: cast_nullable_to_non_nullable
as List<ProtocolItemEntry>,generalAdvice: null == generalAdvice ? _self.generalAdvice : generalAdvice // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PrescriptionProtocolModel].
extension PrescriptionProtocolModelPatterns on PrescriptionProtocolModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrescriptionProtocolModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrescriptionProtocolModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrescriptionProtocolModel value)  $default,){
final _that = this;
switch (_that) {
case _PrescriptionProtocolModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrescriptionProtocolModel value)?  $default,){
final _that = this;
switch (_that) {
case _PrescriptionProtocolModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String diagnosisId,  List<ProtocolItemEntry> protocolItems,  String generalAdvice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrescriptionProtocolModel() when $default != null:
return $default(_that.id,_that.diagnosisId,_that.protocolItems,_that.generalAdvice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String diagnosisId,  List<ProtocolItemEntry> protocolItems,  String generalAdvice)  $default,) {final _that = this;
switch (_that) {
case _PrescriptionProtocolModel():
return $default(_that.id,_that.diagnosisId,_that.protocolItems,_that.generalAdvice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String diagnosisId,  List<ProtocolItemEntry> protocolItems,  String generalAdvice)?  $default,) {final _that = this;
switch (_that) {
case _PrescriptionProtocolModel() when $default != null:
return $default(_that.id,_that.diagnosisId,_that.protocolItems,_that.generalAdvice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrescriptionProtocolModel implements PrescriptionProtocolModel {
  const _PrescriptionProtocolModel({required this.id, required this.diagnosisId, final  List<ProtocolItemEntry> protocolItems = const [], this.generalAdvice = ''}): _protocolItems = protocolItems;
  factory _PrescriptionProtocolModel.fromJson(Map<String, dynamic> json) => _$PrescriptionProtocolModelFromJson(json);

@override final  String id;
@override final  String diagnosisId;
 final  List<ProtocolItemEntry> _protocolItems;
@override@JsonKey() List<ProtocolItemEntry> get protocolItems {
  if (_protocolItems is EqualUnmodifiableListView) return _protocolItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_protocolItems);
}

@override@JsonKey() final  String generalAdvice;

/// Create a copy of PrescriptionProtocolModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrescriptionProtocolModelCopyWith<_PrescriptionProtocolModel> get copyWith => __$PrescriptionProtocolModelCopyWithImpl<_PrescriptionProtocolModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrescriptionProtocolModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrescriptionProtocolModel&&(identical(other.id, id) || other.id == id)&&(identical(other.diagnosisId, diagnosisId) || other.diagnosisId == diagnosisId)&&const DeepCollectionEquality().equals(other._protocolItems, _protocolItems)&&(identical(other.generalAdvice, generalAdvice) || other.generalAdvice == generalAdvice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,diagnosisId,const DeepCollectionEquality().hash(_protocolItems),generalAdvice);

@override
String toString() {
  return 'PrescriptionProtocolModel(id: $id, diagnosisId: $diagnosisId, protocolItems: $protocolItems, generalAdvice: $generalAdvice)';
}


}

/// @nodoc
abstract mixin class _$PrescriptionProtocolModelCopyWith<$Res> implements $PrescriptionProtocolModelCopyWith<$Res> {
  factory _$PrescriptionProtocolModelCopyWith(_PrescriptionProtocolModel value, $Res Function(_PrescriptionProtocolModel) _then) = __$PrescriptionProtocolModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String diagnosisId, List<ProtocolItemEntry> protocolItems, String generalAdvice
});




}
/// @nodoc
class __$PrescriptionProtocolModelCopyWithImpl<$Res>
    implements _$PrescriptionProtocolModelCopyWith<$Res> {
  __$PrescriptionProtocolModelCopyWithImpl(this._self, this._then);

  final _PrescriptionProtocolModel _self;
  final $Res Function(_PrescriptionProtocolModel) _then;

/// Create a copy of PrescriptionProtocolModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? diagnosisId = null,Object? protocolItems = null,Object? generalAdvice = null,}) {
  return _then(_PrescriptionProtocolModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,diagnosisId: null == diagnosisId ? _self.diagnosisId : diagnosisId // ignore: cast_nullable_to_non_nullable
as String,protocolItems: null == protocolItems ? _self._protocolItems : protocolItems // ignore: cast_nullable_to_non_nullable
as List<ProtocolItemEntry>,generalAdvice: null == generalAdvice ? _self.generalAdvice : generalAdvice // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SafetyAlert {

 String get drugName; String get drugClass; String get comorbidityName; String get message; AlertSeverity get severity;
/// Create a copy of SafetyAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SafetyAlertCopyWith<SafetyAlert> get copyWith => _$SafetyAlertCopyWithImpl<SafetyAlert>(this as SafetyAlert, _$identity);

  /// Serializes this SafetyAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SafetyAlert&&(identical(other.drugName, drugName) || other.drugName == drugName)&&(identical(other.drugClass, drugClass) || other.drugClass == drugClass)&&(identical(other.comorbidityName, comorbidityName) || other.comorbidityName == comorbidityName)&&(identical(other.message, message) || other.message == message)&&(identical(other.severity, severity) || other.severity == severity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,drugName,drugClass,comorbidityName,message,severity);

@override
String toString() {
  return 'SafetyAlert(drugName: $drugName, drugClass: $drugClass, comorbidityName: $comorbidityName, message: $message, severity: $severity)';
}


}

/// @nodoc
abstract mixin class $SafetyAlertCopyWith<$Res>  {
  factory $SafetyAlertCopyWith(SafetyAlert value, $Res Function(SafetyAlert) _then) = _$SafetyAlertCopyWithImpl;
@useResult
$Res call({
 String drugName, String drugClass, String comorbidityName, String message, AlertSeverity severity
});




}
/// @nodoc
class _$SafetyAlertCopyWithImpl<$Res>
    implements $SafetyAlertCopyWith<$Res> {
  _$SafetyAlertCopyWithImpl(this._self, this._then);

  final SafetyAlert _self;
  final $Res Function(SafetyAlert) _then;

/// Create a copy of SafetyAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drugName = null,Object? drugClass = null,Object? comorbidityName = null,Object? message = null,Object? severity = null,}) {
  return _then(_self.copyWith(
drugName: null == drugName ? _self.drugName : drugName // ignore: cast_nullable_to_non_nullable
as String,drugClass: null == drugClass ? _self.drugClass : drugClass // ignore: cast_nullable_to_non_nullable
as String,comorbidityName: null == comorbidityName ? _self.comorbidityName : comorbidityName // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,
  ));
}

}


/// Adds pattern-matching-related methods to [SafetyAlert].
extension SafetyAlertPatterns on SafetyAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SafetyAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SafetyAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SafetyAlert value)  $default,){
final _that = this;
switch (_that) {
case _SafetyAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SafetyAlert value)?  $default,){
final _that = this;
switch (_that) {
case _SafetyAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String drugName,  String drugClass,  String comorbidityName,  String message,  AlertSeverity severity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SafetyAlert() when $default != null:
return $default(_that.drugName,_that.drugClass,_that.comorbidityName,_that.message,_that.severity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String drugName,  String drugClass,  String comorbidityName,  String message,  AlertSeverity severity)  $default,) {final _that = this;
switch (_that) {
case _SafetyAlert():
return $default(_that.drugName,_that.drugClass,_that.comorbidityName,_that.message,_that.severity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String drugName,  String drugClass,  String comorbidityName,  String message,  AlertSeverity severity)?  $default,) {final _that = this;
switch (_that) {
case _SafetyAlert() when $default != null:
return $default(_that.drugName,_that.drugClass,_that.comorbidityName,_that.message,_that.severity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SafetyAlert implements SafetyAlert {
  const _SafetyAlert({required this.drugName, required this.drugClass, required this.comorbidityName, required this.message, this.severity = AlertSeverity.critical});
  factory _SafetyAlert.fromJson(Map<String, dynamic> json) => _$SafetyAlertFromJson(json);

@override final  String drugName;
@override final  String drugClass;
@override final  String comorbidityName;
@override final  String message;
@override@JsonKey() final  AlertSeverity severity;

/// Create a copy of SafetyAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SafetyAlertCopyWith<_SafetyAlert> get copyWith => __$SafetyAlertCopyWithImpl<_SafetyAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SafetyAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SafetyAlert&&(identical(other.drugName, drugName) || other.drugName == drugName)&&(identical(other.drugClass, drugClass) || other.drugClass == drugClass)&&(identical(other.comorbidityName, comorbidityName) || other.comorbidityName == comorbidityName)&&(identical(other.message, message) || other.message == message)&&(identical(other.severity, severity) || other.severity == severity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,drugName,drugClass,comorbidityName,message,severity);

@override
String toString() {
  return 'SafetyAlert(drugName: $drugName, drugClass: $drugClass, comorbidityName: $comorbidityName, message: $message, severity: $severity)';
}


}

/// @nodoc
abstract mixin class _$SafetyAlertCopyWith<$Res> implements $SafetyAlertCopyWith<$Res> {
  factory _$SafetyAlertCopyWith(_SafetyAlert value, $Res Function(_SafetyAlert) _then) = __$SafetyAlertCopyWithImpl;
@override @useResult
$Res call({
 String drugName, String drugClass, String comorbidityName, String message, AlertSeverity severity
});




}
/// @nodoc
class __$SafetyAlertCopyWithImpl<$Res>
    implements _$SafetyAlertCopyWith<$Res> {
  __$SafetyAlertCopyWithImpl(this._self, this._then);

  final _SafetyAlert _self;
  final $Res Function(_SafetyAlert) _then;

/// Create a copy of SafetyAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drugName = null,Object? drugClass = null,Object? comorbidityName = null,Object? message = null,Object? severity = null,}) {
  return _then(_SafetyAlert(
drugName: null == drugName ? _self.drugName : drugName // ignore: cast_nullable_to_non_nullable
as String,drugClass: null == drugClass ? _self.drugClass : drugClass // ignore: cast_nullable_to_non_nullable
as String,comorbidityName: null == comorbidityName ? _self.comorbidityName : comorbidityName // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,
  ));
}


}

// dart format on
