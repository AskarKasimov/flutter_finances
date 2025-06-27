import 'package:flutter_finances/data/mappers/stat_item_mapper.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_datetime.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/models/account_response/account_response.dart';
import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';

extension AccountResponseMapper on AccountResponseDTO {
  AccountResponse toDomain() {
    final parsedBalance = tryParseDouble(balance, 'balance');
    final parsedIncomeStats = incomeStats.map((el) => el.toDomain()).toList();
    final parsedExpenseStats = expenseStats.map((el) => el.toDomain()).toList();
    final parsedCreatedAt = tryParseDateTime(createdAt, 'createdAt');
    final parsedUpdatedAt = tryParseDateTime(updatedAt, 'updatedAt');

    return AccountResponse(
      id: this.id,
      name: name,
      moneyDetails: MoneyDetails(balance: parsedBalance, currency: currency),
      incomeStats: parsedIncomeStats,
      expenseStats: parsedExpenseStats,
      auditInfoTime: AuditInfoTime(
        createdAt: parsedCreatedAt,
        updatedAt: parsedUpdatedAt,
      ),
    );
  }
}
