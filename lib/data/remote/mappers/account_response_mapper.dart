import 'package:flutter_finances/data/remote/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/remote/models/account_response/account_response.dart';
import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';

extension AccountResponseMapper on AccountResponseDTO {
  AccountResponse toDomain() {
    final parsedBalance = tryParseDouble(balance, 'balance');

    return AccountResponse(
      id: id,
      name: name,
      moneyDetails: MoneyDetails(balance: parsedBalance, currency: currency),
    );
  }
}
