import 'package:dartz/dartz.dart';
import 'package:flutter_finances/data/mappers/stat_item_mapper.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_datetime.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_nested_list_mapper.dart';
import 'package:flutter_finances/data/models/account_response/account_response.dart';
import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';
import 'package:flutter_finances/domain/failures/failure.dart';

extension AccountResponseMapper on AccountResponseDTO {
  Either<Failure, AccountResponse> toDomain() {
    final balanceOrFailure = tryParseDouble(balance, 'balance');
    final incomeStatsOrFailure = tryParseNestedList(
      incomeStats.map((el) => el.toDomain()),
    );
    final expenseStatsOrFailure = tryParseNestedList(
      expenseStats.map((el) => el.toDomain()),
    );
    final createdAtOrFailure = tryParseDateTime(createdAt, 'createdAt');
    final updatedAtOrFailure = tryParseDateTime(updatedAt, 'updatedAt');

    return balanceOrFailure.flatMap(
      (parsedBalance) => incomeStatsOrFailure.flatMap(
        (parsedIncomeStats) => expenseStatsOrFailure.flatMap(
          (parsedExpenseStats) => createdAtOrFailure.flatMap(
            (parsedCreatedAt) => updatedAtOrFailure.map(
              (parsedUpdatedAt) => AccountResponse(
                id: this.id,
                name: name,
                moneyDetails: MoneyDetails(
                  balance: parsedBalance,
                  currency: currency,
                ),
                incomeStats: parsedIncomeStats,
                expenseStats: parsedExpenseStats,
                timeInterval: AuditInfoTime(
                  createdAt: parsedCreatedAt,
                  updatedAt: parsedUpdatedAt,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
