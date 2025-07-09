import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';

class GetAccountByIdUseCase {
  final AccountRepository accountRepository;

  GetAccountByIdUseCase({required this.accountRepository});

  Future<AccountResponse> call(int accountId) {
    return accountRepository.getAccountById(accountId);
  }
}
