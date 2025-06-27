import 'package:flutter_finances/data/mappers/types/try_parse_datetime.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/models/account/account.dart';
import 'package:flutter_finances/domain/entities/account.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';

extension AccountMapper on AccountDTO {
  Account toDomain() {
    final parsedBalance = tryParseDouble(balance, 'balance');
    final parsedCreatedAt = tryParseDateTime(createdAt, 'createdAt');
    final parsedUpdatedAt = tryParseDateTime(updatedAt, 'updatedAt');

    return Account(
      id: id,
      userId: userId,
      name: name,
      moneyDetails: MoneyDetails(balance: parsedBalance, currency: currency),
      auditInfoTime: AuditInfoTime(
        createdAt: parsedCreatedAt,
        updatedAt: parsedUpdatedAt,
      ),
    );
  }
}
