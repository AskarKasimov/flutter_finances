import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';

class GetAllAccountsUseCase {
  final AccountRepository accountRepository;

  GetAllAccountsUseCase({required this.accountRepository});

  Future<List<AccountResponse>> call() {
    return accountRepository.getAllAccounts();
  }
}
