// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'encounter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EncounterState {

 PatientQueueItem? get activePatient; List<String> get selectedComorbidityIds; Map<String, SelectedComplaintState> get selectedComplaints; Map<String, ExamSystemState> get examStates; List<String> get selectedDiagnosisIds; List<PrescriptionItemModel> get activePrescription; String get generalAdvice; int? get followUpDays; List<SafetyAlert> get safetyAlerts; bool get isLetterheadMode; bool get isLoading; String? get errorMessage;
/// Create a copy of EncounterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EncounterStateCopyWith<EncounterState> get copyWith => _$EncounterStateCopyWithImpl<EncounterState>(this as EncounterState, _$identity);

  /// Serializes this EncounterState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EncounterState&&(identical(other.activePatient, activePatient) || other.activePatient == activePatient)&&const DeepCollectionEquality().equals(other.selectedComorbidityIds, selectedComorbidityIds)&&const DeepCollectionEquality().equals(other.selectedComplaints, selectedComplaints)&&const DeepCollectionEquality().equals(other.examStates, examStates)&&const DeepCollectionEquality().equals(other.selectedDiagnosisIds, selectedDiagnosisIds)&&const DeepCollectionEquality().equals(other.activePrescription, activePrescription)&&(identical(other.generalAdvice, generalAdvice) || other.generalAdvice == generalAdvice)&&(identical(other.followUpDays, followUpDays) || other.followUpDays == followUpDays)&&const DeepCollectionEquality().equals(other.safetyAlerts, safetyAlerts)&&(identical(other.isLetterheadMode, isLetterheadMode) || other.isLetterheadMode == isLetterheadMode)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activePatient,const DeepCollectionEquality().hash(selectedComorbidityIds),const DeepCollectionEquality().hash(selectedComplaints),const DeepCollectionEquality().hash(examStates),const DeepCollectionEquality().hash(selectedDiagnosisIds),const DeepCollectionEquality().hash(activePrescription),generalAdvice,followUpDays,const DeepCollectionEquality().hash(safetyAlerts),isLetterheadMode,isLoading,errorMessage);

@override
String toString() {
  return 'EncounterState(activePatient: $activePatient, selectedComorbidityIds: $selectedComorbidityIds, selectedComplaints: $selectedComplaints, examStates: $examStates, selectedDiagnosisIds: $selectedDiagnosisIds, activePrescription: $activePrescription, generalAdvice: $generalAdvice, followUpDays: $followUpDays, safetyAlerts: $safetyAlerts, isLetterheadMode: $isLetterheadMode, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $EncounterStateCopyWith<$Res>  {
  factory $EncounterStateCopyWith(EncounterState value, $Res Function(EncounterState) _then) = _$EncounterStateCopyWithImpl;
@useResult
$Res call({
 PatientQueueItem? activePatient, List<String> selectedComorbidityIds, Map<String, SelectedComplaintState> selectedComplaints, Map<String, ExamSystemState> examStates, List<String> selectedDiagnosisIds, List<PrescriptionItemModel> activePrescription, String generalAdvice, int? followUpDays, List<SafetyAlert> safetyAlerts, bool isLetterheadMode, bool isLoading, String? errorMessage
});


$PatientQueueItemCopyWith<$Res>? get activePatient;

}
/// @nodoc
class _$EncounterStateCopyWithImpl<$Res>
    implements $EncounterStateCopyWith<$Res> {
  _$EncounterStateCopyWithImpl(this._self, this._then);

  final EncounterState _self;
  final $Res Function(EncounterState) _then;

/// Create a copy of EncounterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activePatient = freezed,Object? selectedComorbidityIds = null,Object? selectedComplaints = null,Object? examStates = null,Object? selectedDiagnosisIds = null,Object? activePrescription = null,Object? generalAdvice = null,Object? followUpDays = freezed,Object? safetyAlerts = null,Object? isLetterheadMode = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
activePatient: freezed == activePatient ? _self.activePatient : activePatient // ignore: cast_nullable_to_non_nullable
as PatientQueueItem?,selectedComorbidityIds: null == selectedComorbidityIds ? _self.selectedComorbidityIds : selectedComorbidityIds // ignore: cast_nullable_to_non_nullable
as List<String>,selectedComplaints: null == selectedComplaints ? _self.selectedComplaints : selectedComplaints // ignore: cast_nullable_to_non_nullable
as Map<String, SelectedComplaintState>,examStates: null == examStates ? _self.examStates : examStates // ignore: cast_nullable_to_non_nullable
as Map<String, ExamSystemState>,selectedDiagnosisIds: null == selectedDiagnosisIds ? _self.selectedDiagnosisIds : selectedDiagnosisIds // ignore: cast_nullable_to_non_nullable
as List<String>,activePrescription: null == activePrescription ? _self.activePrescription : activePrescription // ignore: cast_nullable_to_non_nullable
as List<PrescriptionItemModel>,generalAdvice: null == generalAdvice ? _self.generalAdvice : generalAdvice // ignore: cast_nullable_to_non_nullable
as String,followUpDays: freezed == followUpDays ? _self.followUpDays : followUpDays // ignore: cast_nullable_to_non_nullable
as int?,safetyAlerts: null == safetyAlerts ? _self.safetyAlerts : safetyAlerts // ignore: cast_nullable_to_non_nullable
as List<SafetyAlert>,isLetterheadMode: null == isLetterheadMode ? _self.isLetterheadMode : isLetterheadMode // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of EncounterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PatientQueueItemCopyWith<$Res>? get activePatient {
    if (_self.activePatient == null) {
    return null;
  }

  return $PatientQueueItemCopyWith<$Res>(_self.activePatient!, (value) {
    return _then(_self.copyWith(activePatient: value));
  });
}
}


/// Adds pattern-matching-related methods to [EncounterState].
extension EncounterStatePatterns on EncounterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EncounterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EncounterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EncounterState value)  $default,){
final _that = this;
switch (_that) {
case _EncounterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EncounterState value)?  $default,){
final _that = this;
switch (_that) {
case _EncounterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PatientQueueItem? activePatient,  List<String> selectedComorbidityIds,  Map<String, SelectedComplaintState> selectedComplaints,  Map<String, ExamSystemState> examStates,  List<String> selectedDiagnosisIds,  List<PrescriptionItemModel> activePrescription,  String generalAdvice,  int? followUpDays,  List<SafetyAlert> safetyAlerts,  bool isLetterheadMode,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EncounterState() when $default != null:
return $default(_that.activePatient,_that.selectedComorbidityIds,_that.selectedComplaints,_that.examStates,_that.selectedDiagnosisIds,_that.activePrescription,_that.generalAdvice,_that.followUpDays,_that.safetyAlerts,_that.isLetterheadMode,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PatientQueueItem? activePatient,  List<String> selectedComorbidityIds,  Map<String, SelectedComplaintState> selectedComplaints,  Map<String, ExamSystemState> examStates,  List<String> selectedDiagnosisIds,  List<PrescriptionItemModel> activePrescription,  String generalAdvice,  int? followUpDays,  List<SafetyAlert> safetyAlerts,  bool isLetterheadMode,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _EncounterState():
return $default(_that.activePatient,_that.selectedComorbidityIds,_that.selectedComplaints,_that.examStates,_that.selectedDiagnosisIds,_that.activePrescription,_that.generalAdvice,_that.followUpDays,_that.safetyAlerts,_that.isLetterheadMode,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PatientQueueItem? activePatient,  List<String> selectedComorbidityIds,  Map<String, SelectedComplaintState> selectedComplaints,  Map<String, ExamSystemState> examStates,  List<String> selectedDiagnosisIds,  List<PrescriptionItemModel> activePrescription,  String generalAdvice,  int? followUpDays,  List<SafetyAlert> safetyAlerts,  bool isLetterheadMode,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _EncounterState() when $default != null:
return $default(_that.activePatient,_that.selectedComorbidityIds,_that.selectedComplaints,_that.examStates,_that.selectedDiagnosisIds,_that.activePrescription,_that.generalAdvice,_that.followUpDays,_that.safetyAlerts,_that.isLetterheadMode,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EncounterState extends EncounterState {
  const _EncounterState({this.activePatient, final  List<String> selectedComorbidityIds = const [], final  Map<String, SelectedComplaintState> selectedComplaints = const {}, final  Map<String, ExamSystemState> examStates = const {}, final  List<String> selectedDiagnosisIds = const [], final  List<PrescriptionItemModel> activePrescription = const [], this.generalAdvice = '', this.followUpDays, final  List<SafetyAlert> safetyAlerts = const [], this.isLetterheadMode = false, this.isLoading = false, this.errorMessage}): _selectedComorbidityIds = selectedComorbidityIds,_selectedComplaints = selectedComplaints,_examStates = examStates,_selectedDiagnosisIds = selectedDiagnosisIds,_activePrescription = activePrescription,_safetyAlerts = safetyAlerts,super._();
  factory _EncounterState.fromJson(Map<String, dynamic> json) => _$EncounterStateFromJson(json);

@override final  PatientQueueItem? activePatient;
 final  List<String> _selectedComorbidityIds;
@override@JsonKey() List<String> get selectedComorbidityIds {
  if (_selectedComorbidityIds is EqualUnmodifiableListView) return _selectedComorbidityIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedComorbidityIds);
}

 final  Map<String, SelectedComplaintState> _selectedComplaints;
@override@JsonKey() Map<String, SelectedComplaintState> get selectedComplaints {
  if (_selectedComplaints is EqualUnmodifiableMapView) return _selectedComplaints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_selectedComplaints);
}

 final  Map<String, ExamSystemState> _examStates;
@override@JsonKey() Map<String, ExamSystemState> get examStates {
  if (_examStates is EqualUnmodifiableMapView) return _examStates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_examStates);
}

 final  List<String> _selectedDiagnosisIds;
@override@JsonKey() List<String> get selectedDiagnosisIds {
  if (_selectedDiagnosisIds is EqualUnmodifiableListView) return _selectedDiagnosisIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedDiagnosisIds);
}

 final  List<PrescriptionItemModel> _activePrescription;
@override@JsonKey() List<PrescriptionItemModel> get activePrescription {
  if (_activePrescription is EqualUnmodifiableListView) return _activePrescription;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activePrescription);
}

@override@JsonKey() final  String generalAdvice;
@override final  int? followUpDays;
 final  List<SafetyAlert> _safetyAlerts;
@override@JsonKey() List<SafetyAlert> get safetyAlerts {
  if (_safetyAlerts is EqualUnmodifiableListView) return _safetyAlerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_safetyAlerts);
}

@override@JsonKey() final  bool isLetterheadMode;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of EncounterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EncounterStateCopyWith<_EncounterState> get copyWith => __$EncounterStateCopyWithImpl<_EncounterState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EncounterStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EncounterState&&(identical(other.activePatient, activePatient) || other.activePatient == activePatient)&&const DeepCollectionEquality().equals(other._selectedComorbidityIds, _selectedComorbidityIds)&&const DeepCollectionEquality().equals(other._selectedComplaints, _selectedComplaints)&&const DeepCollectionEquality().equals(other._examStates, _examStates)&&const DeepCollectionEquality().equals(other._selectedDiagnosisIds, _selectedDiagnosisIds)&&const DeepCollectionEquality().equals(other._activePrescription, _activePrescription)&&(identical(other.generalAdvice, generalAdvice) || other.generalAdvice == generalAdvice)&&(identical(other.followUpDays, followUpDays) || other.followUpDays == followUpDays)&&const DeepCollectionEquality().equals(other._safetyAlerts, _safetyAlerts)&&(identical(other.isLetterheadMode, isLetterheadMode) || other.isLetterheadMode == isLetterheadMode)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activePatient,const DeepCollectionEquality().hash(_selectedComorbidityIds),const DeepCollectionEquality().hash(_selectedComplaints),const DeepCollectionEquality().hash(_examStates),const DeepCollectionEquality().hash(_selectedDiagnosisIds),const DeepCollectionEquality().hash(_activePrescription),generalAdvice,followUpDays,const DeepCollectionEquality().hash(_safetyAlerts),isLetterheadMode,isLoading,errorMessage);

@override
String toString() {
  return 'EncounterState(activePatient: $activePatient, selectedComorbidityIds: $selectedComorbidityIds, selectedComplaints: $selectedComplaints, examStates: $examStates, selectedDiagnosisIds: $selectedDiagnosisIds, activePrescription: $activePrescription, generalAdvice: $generalAdvice, followUpDays: $followUpDays, safetyAlerts: $safetyAlerts, isLetterheadMode: $isLetterheadMode, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$EncounterStateCopyWith<$Res> implements $EncounterStateCopyWith<$Res> {
  factory _$EncounterStateCopyWith(_EncounterState value, $Res Function(_EncounterState) _then) = __$EncounterStateCopyWithImpl;
@override @useResult
$Res call({
 PatientQueueItem? activePatient, List<String> selectedComorbidityIds, Map<String, SelectedComplaintState> selectedComplaints, Map<String, ExamSystemState> examStates, List<String> selectedDiagnosisIds, List<PrescriptionItemModel> activePrescription, String generalAdvice, int? followUpDays, List<SafetyAlert> safetyAlerts, bool isLetterheadMode, bool isLoading, String? errorMessage
});


@override $PatientQueueItemCopyWith<$Res>? get activePatient;

}
/// @nodoc
class __$EncounterStateCopyWithImpl<$Res>
    implements _$EncounterStateCopyWith<$Res> {
  __$EncounterStateCopyWithImpl(this._self, this._then);

  final _EncounterState _self;
  final $Res Function(_EncounterState) _then;

/// Create a copy of EncounterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activePatient = freezed,Object? selectedComorbidityIds = null,Object? selectedComplaints = null,Object? examStates = null,Object? selectedDiagnosisIds = null,Object? activePrescription = null,Object? generalAdvice = null,Object? followUpDays = freezed,Object? safetyAlerts = null,Object? isLetterheadMode = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_EncounterState(
activePatient: freezed == activePatient ? _self.activePatient : activePatient // ignore: cast_nullable_to_non_nullable
as PatientQueueItem?,selectedComorbidityIds: null == selectedComorbidityIds ? _self._selectedComorbidityIds : selectedComorbidityIds // ignore: cast_nullable_to_non_nullable
as List<String>,selectedComplaints: null == selectedComplaints ? _self._selectedComplaints : selectedComplaints // ignore: cast_nullable_to_non_nullable
as Map<String, SelectedComplaintState>,examStates: null == examStates ? _self._examStates : examStates // ignore: cast_nullable_to_non_nullable
as Map<String, ExamSystemState>,selectedDiagnosisIds: null == selectedDiagnosisIds ? _self._selectedDiagnosisIds : selectedDiagnosisIds // ignore: cast_nullable_to_non_nullable
as List<String>,activePrescription: null == activePrescription ? _self._activePrescription : activePrescription // ignore: cast_nullable_to_non_nullable
as List<PrescriptionItemModel>,generalAdvice: null == generalAdvice ? _self.generalAdvice : generalAdvice // ignore: cast_nullable_to_non_nullable
as String,followUpDays: freezed == followUpDays ? _self.followUpDays : followUpDays // ignore: cast_nullable_to_non_nullable
as int?,safetyAlerts: null == safetyAlerts ? _self._safetyAlerts : safetyAlerts // ignore: cast_nullable_to_non_nullable
as List<SafetyAlert>,isLetterheadMode: null == isLetterheadMode ? _self.isLetterheadMode : isLetterheadMode // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of EncounterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PatientQueueItemCopyWith<$Res>? get activePatient {
    if (_self.activePatient == null) {
    return null;
  }

  return $PatientQueueItemCopyWith<$Res>(_self.activePatient!, (value) {
    return _then(_self.copyWith(activePatient: value));
  });
}
}

// dart format on
