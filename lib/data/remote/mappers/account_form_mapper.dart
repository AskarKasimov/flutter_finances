import 'package:flutter_finances/data/remote/models/account_request/account_request.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';

extension AccountFormCreateMapper on AccountForm {
  AccountRequestDTO toDTO() {
    return AccountRequestDTO(
      name: name,
      balance: moneyDetails.balance.toString(),
      currency: moneyDetails.currency,
    );
  }
}
