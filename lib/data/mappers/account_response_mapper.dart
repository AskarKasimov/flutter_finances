import 'package:flutter_finances/data/mappers/types/try_parse_datetime.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/models/account_response/account_response.dart';
import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';

extension AccountResponseMapper on AccountResponseDTO {
  AccountResponse toDomain() {
    final parsedBalance = tryParseDouble(balance, 'balance');
    final parsedCreatedAt = tryParseDateTime(createdAt, 'createdAt');
    final parsedUpdatedAt = tryParseDateTime(updatedAt, 'updatedAt');

    return AccountResponse(
      id: id,
      name: name,
      moneyDetails: MoneyDetails(balance: parsedBalance, currency: currency),
      auditInfoTime: AuditInfoTime(
        createdAt: parsedCreatedAt,
        updatedAt: parsedUpdatedAt,
      ),
    );
  }
}
