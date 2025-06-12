import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_create.freezed.dart';
part 'account_create.g.dart';

@freezed
abstract class AccountCreateDTO with _$AccountCreateDTO {
  const factory AccountCreateDTO({
    required String name,
    required String balance,
    required String currency,
  }) = _AccountCreateDTO;

  factory AccountCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$AccountCreateDTOFromJson(json);
}
