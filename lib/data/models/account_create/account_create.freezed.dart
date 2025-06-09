// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountCreateDTO {

 String get name; String get balance; String get currency;
/// Create a copy of AccountCreateDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountCreateDTOCopyWith<AccountCreateDTO> get copyWith => _$AccountCreateDTOCopyWithImpl<AccountCreateDTO>(this as AccountCreateDTO, _$identity);

  /// Serializes this AccountCreateDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountCreateDTO&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,balance,currency);

@override
String toString() {
  return 'AccountCreateDTO(name: $name, balance: $balance, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $AccountCreateDTOCopyWith<$Res>  {
  factory $AccountCreateDTOCopyWith(AccountCreateDTO value, $Res Function(AccountCreateDTO) _then) = _$AccountCreateDTOCopyWithImpl;
@useResult
$Res call({
 String name, String balance, String currency
});




}
/// @nodoc
class _$AccountCreateDTOCopyWithImpl<$Res>
    implements $AccountCreateDTOCopyWith<$Res> {
  _$AccountCreateDTOCopyWithImpl(this._self, this._then);

  final AccountCreateDTO _self;
  final $Res Function(AccountCreateDTO) _then;

/// Create a copy of AccountCreateDTO
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

class _AccountCreateDTO implements AccountCreateDTO {
  const _AccountCreateDTO({required this.name, required this.balance, required this.currency});
  factory _AccountCreateDTO.fromJson(Map<String, dynamic> json) => _$AccountCreateDTOFromJson(json);

@override final  String name;
@override final  String balance;
@override final  String currency;

/// Create a copy of AccountCreateDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountCreateDTOCopyWith<_AccountCreateDTO> get copyWith => __$AccountCreateDTOCopyWithImpl<_AccountCreateDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountCreateDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountCreateDTO&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,balance,currency);

@override
String toString() {
  return 'AccountCreateDTO(name: $name, balance: $balance, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$AccountCreateDTOCopyWith<$Res> implements $AccountCreateDTOCopyWith<$Res> {
  factory _$AccountCreateDTOCopyWith(_AccountCreateDTO value, $Res Function(_AccountCreateDTO) _then) = __$AccountCreateDTOCopyWithImpl;
@override @useResult
$Res call({
 String name, String balance, String currency
});




}
/// @nodoc
class __$AccountCreateDTOCopyWithImpl<$Res>
    implements _$AccountCreateDTOCopyWith<$Res> {
  __$AccountCreateDTOCopyWithImpl(this._self, this._then);

  final _AccountCreateDTO _self;
  final $Res Function(_AccountCreateDTO) _then;

/// Create a copy of AccountCreateDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? balance = null,Object? currency = null,}) {
  return _then(_AccountCreateDTO(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
