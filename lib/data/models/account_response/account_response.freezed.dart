// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountResponseDTO {

 int get id; String get name; String get balance; String get currency; String get createdAt; String get updatedAt;
/// Create a copy of AccountResponseDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountResponseDTOCopyWith<AccountResponseDTO> get copyWith => _$AccountResponseDTOCopyWithImpl<AccountResponseDTO>(this as AccountResponseDTO, _$identity);

  /// Serializes this AccountResponseDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountResponseDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,balance,currency,createdAt,updatedAt);

@override
String toString() {
  return 'AccountResponseDTO(id: $id, name: $name, balance: $balance, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AccountResponseDTOCopyWith<$Res>  {
  factory $AccountResponseDTOCopyWith(AccountResponseDTO value, $Res Function(AccountResponseDTO) _then) = _$AccountResponseDTOCopyWithImpl;
@useResult
$Res call({
 int id, String name, String balance, String currency, String createdAt, String updatedAt
});




}
/// @nodoc
class _$AccountResponseDTOCopyWithImpl<$Res>
    implements $AccountResponseDTOCopyWith<$Res> {
  _$AccountResponseDTOCopyWithImpl(this._self, this._then);

  final AccountResponseDTO _self;
  final $Res Function(AccountResponseDTO) _then;

/// Create a copy of AccountResponseDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? balance = null,Object? currency = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AccountResponseDTO implements AccountResponseDTO {
  const _AccountResponseDTO({required this.id, required this.name, required this.balance, required this.currency, required this.createdAt, required this.updatedAt});
  factory _AccountResponseDTO.fromJson(Map<String, dynamic> json) => _$AccountResponseDTOFromJson(json);

@override final  int id;
@override final  String name;
@override final  String balance;
@override final  String currency;
@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of AccountResponseDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountResponseDTOCopyWith<_AccountResponseDTO> get copyWith => __$AccountResponseDTOCopyWithImpl<_AccountResponseDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountResponseDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountResponseDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,balance,currency,createdAt,updatedAt);

@override
String toString() {
  return 'AccountResponseDTO(id: $id, name: $name, balance: $balance, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AccountResponseDTOCopyWith<$Res> implements $AccountResponseDTOCopyWith<$Res> {
  factory _$AccountResponseDTOCopyWith(_AccountResponseDTO value, $Res Function(_AccountResponseDTO) _then) = __$AccountResponseDTOCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String balance, String currency, String createdAt, String updatedAt
});




}
/// @nodoc
class __$AccountResponseDTOCopyWithImpl<$Res>
    implements _$AccountResponseDTOCopyWith<$Res> {
  __$AccountResponseDTOCopyWithImpl(this._self, this._then);

  final _AccountResponseDTO _self;
  final $Res Function(_AccountResponseDTO) _then;

/// Create a copy of AccountResponseDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? balance = null,Object? currency = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AccountResponseDTO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
