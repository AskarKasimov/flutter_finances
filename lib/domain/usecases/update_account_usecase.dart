import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';

class UpdateAccountUseCase {
  final AccountRepository accountRepository;

  UpdateAccountUseCase({required this.accountRepository});

  Future<AccountResponse> call(int accountId, AccountForm accountForm) {
    return accountRepository.updateAccount(accountId, accountForm);
  }
}
