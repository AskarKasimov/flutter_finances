import 'package:dartz/dartz.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/models/accout_state/account_state.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/failures/failure.dart';

import '../../domain/entities/value_objects/money_details.dart';

extension AccountStateMapper on AccountStateDTO {
  Either<Failure, AccountState> toDomain() {
    final balanceOrFailure = tryParseDouble(balance, 'balance');

    return balanceOrFailure.map(
      (parsedBalance) => AccountState(
        id: this.id,
        name: name,
        moneyDetails: MoneyDetails(balance: parsedBalance, currency: currency),
      ),
    );
  }
}
