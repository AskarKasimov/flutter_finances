import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_response.freezed.dart';
part 'account_response.g.dart';

@freezed
abstract class AccountResponseDTO with _$AccountResponseDTO {
  const factory AccountResponseDTO({
    required int id,
    required String name,
    required String balance,
    required String currency,
    required String createdAt,
    required String updatedAt,
  }) = _AccountResponseDTO;

  factory AccountResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$AccountResponseDTOFromJson(json);
}
