import 'package:flutter_finances/data/remote/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/remote/models/accout_state/account_state.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';

extension AccountStateMapper on AccountStateDTO {
  AccountState toDomain() {
    final parsedBalance = tryParseDouble(balance, 'balance');

    return AccountState(
      id: id,
      name: name,
      moneyDetails: MoneyDetails(balance: parsedBalance, currency: currency),
    );
  }
}
