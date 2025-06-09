// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountUpdateDTO {

 String get name; String get balance; String get currency;
/// Create a copy of AccountUpdateDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountUpdateDTOCopyWith<AccountUpdateDTO> get copyWith => _$AccountUpdateDTOCopyWithImpl<AccountUpdateDTO>(this as AccountUpdateDTO, _$identity);

  /// Serializes this AccountUpdateDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountUpdateDTO&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,balance,currency);

@override
String toString() {
  return 'AccountUpdateDTO(name: $name, balance: $balance, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $AccountUpdateDTOCopyWith<$Res>  {
  factory $AccountUpdateDTOCopyWith(AccountUpdateDTO value, $Res Function(AccountUpdateDTO) _then) = _$AccountUpdateDTOCopyWithImpl;
@useResult
$Res call({
 String name, String balance, String currency
});




}
/// @nodoc
class _$AccountUpdateDTOCopyWithImpl<$Res>
    implements $AccountUpdateDTOCopyWith<$Res> {
  _$AccountUpdateDTOCopyWithImpl(this._self, this._then);

  final AccountUpdateDTO _self;
  final $Res Function(AccountUpdateDTO) _then;

/// Create a copy of AccountUpdateDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? balance = null,Object? currency = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AccountUpdateDTO implements AccountUpdateDTO {
  const _AccountUpdateDTO({required this.name, required this.balance, required this.currency});
  factory _AccountUpdateDTO.fromJson(Map<String, dynamic> json) => _$AccountUpdateDTOFromJson(json);

@override final  String name;
@override final  String balance;
@override final  String currency;

/// Create a copy of AccountUpdateDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountUpdateDTOCopyWith<_AccountUpdateDTO> get copyWith => __$AccountUpdateDTOCopyWithImpl<_AccountUpdateDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountUpdateDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountUpdateDTO&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,balance,currency);

@override
String toString() {
  return 'AccountUpdateDTO(name: $name, balance: $balance, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$AccountUpdateDTOCopyWith<$Res> implements $AccountUpdateDTOCopyWith<$Res> {
  factory _$AccountUpdateDTOCopyWith(_AccountUpdateDTO value, $Res Function(_AccountUpdateDTO) _then) = __$AccountUpdateDTOCopyWithImpl;
@override @useResult
$Res call({
 String name, String balance, String currency
});




}
/// @nodoc
class __$AccountUpdateDTOCopyWithImpl<$Res>
    implements _$AccountUpdateDTOCopyWith<$Res> {
  __$AccountUpdateDTOCopyWithImpl(this._self, this._then);

  final _AccountUpdateDTO _self;
  final $Res Function(_AccountUpdateDTO) _then;

/// Create a copy of AccountUpdateDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? balance = null,Object? currency = null,}) {
  return _then(_AccountUpdateDTO(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
