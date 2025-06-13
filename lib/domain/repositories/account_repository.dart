import 'package:flutter_finances/domain/entities/account.dart';
import 'package:flutter_finances/domain/entities/account_history.dart';
import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';

abstract interface class AccountRepository {
  Future<List<Account>> getAllAccounts();

  Future<Account> createAccount(AccountForm account);

  Future<AccountResponse> getAccountById(int id);

  Future<AccountForm> updateAccount(int id, AccountForm account);

  Future<AccountHistory> getAccountHistory(int id);
}
