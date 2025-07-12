import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';

abstract interface class AccountRepository {
  Future<List<AccountResponse>> getAllAccounts();

  Future<AccountResponse> getAccountById(int id);

  Future<AccountResponse> updateAccount(int id, AccountForm account);
}
