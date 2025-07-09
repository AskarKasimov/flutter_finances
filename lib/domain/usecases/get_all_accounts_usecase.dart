import 'package:flutter_finances/domain/entities/account.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';

class GetAllAccountsUseCase {
  final AccountRepository accountRepository;

  GetAllAccountsUseCase({required this.accountRepository});

  Future<List<Account>> call() {
    return accountRepository.getAllAccounts();
  }
}
