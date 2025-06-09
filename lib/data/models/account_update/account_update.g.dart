// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountUpdateDTO _$AccountUpdateDTOFromJson(Map<String, dynamic> json) =>
    _AccountUpdateDTO(
      name: json['name'] as String,
      balance: json['balance'] as String,
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$AccountUpdateDTOToJson(_AccountUpdateDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'balance': instance.balance,
      'currency': instance.currency,
    };
