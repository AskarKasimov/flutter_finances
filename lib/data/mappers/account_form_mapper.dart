import 'package:flutter_finances/data/models/account_create/account_request.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';

extension AccountFormCreateMapper on AccountForm {
  AccountRequestDTO toCreateDTO() {
    return AccountRequestDTO(
      name: name,
      balance: moneyDetails?.balance.toString(),
      currency: moneyDetails?.currency,
    );
  }
}
