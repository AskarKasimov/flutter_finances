import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_update.freezed.dart';

part 'account_update.g.dart';

@freezed
abstract class AccountUpdateDTO with _$AccountUpdateDTO {
  const factory AccountUpdateDTO({
    required String name,
    required String balance,
    required String currency,
  }) = _AccountUpdateDTO;

  factory AccountUpdateDTO.fromJson(Map<String, dynamic> json) =>
      _$AccountUpdateDTOFromJson(json);
}
