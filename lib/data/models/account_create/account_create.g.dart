// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountCreateDTO _$AccountCreateDTOFromJson(Map<String, dynamic> json) =>
    _AccountCreateDTO(
      name: json['name'] as String,
      balance: json['balance'] as String,
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$AccountCreateDTOToJson(_AccountCreateDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'balance': instance.balance,
      'currency': instance.currency,
    };
