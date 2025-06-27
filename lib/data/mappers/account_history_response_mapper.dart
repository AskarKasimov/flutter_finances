import 'package:flutter_finances/data/mappers/account_history_mapper.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/models/account_history_response/account_history_response.dart';
import 'package:flutter_finances/domain/entities/account_history.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';

extension AccountHistoryResponseMapper on AccountHistoryResponseDTO {
  AccountHistory toDomain() {
    final parsedBalance = tryParseDouble(currentBalance, 'currentBalance');

    final parsedHistory = history.map((item) => item.toDomain()).toList();

    return AccountHistory(
      accountId: accountId,
      accountName: accountName,
      moneyDetails: MoneyDetails(balance: parsedBalance, currency: currency),
      history: parsedHistory,
    );
  }
}
