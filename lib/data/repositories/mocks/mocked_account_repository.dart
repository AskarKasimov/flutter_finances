import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';
import 'package:flutter_finances/domain/exceptions/repository_exception.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';

class MockedAccountRepository implements AccountRepository {
  final List<AccountResponse> _accounts = [
    AccountResponse(
      id: 1,
      name: 'Mocked AccountResponse',
      moneyDetails: MoneyDetails(balance: 114, currency: '₽'),
    ),
  ];

  @override
  Future<AccountResponse> getAccountById(int id) async {
    final account = _accounts.where((a) => a.id == id).firstOrNull;

    if (account == null) {
      throw RepositoryException('Аккаунт с id $id не найден');
    }

    return AccountResponse(
      id: account.id,
      name: account.name,
      moneyDetails: account.moneyDetails,);
  }

  @override
  Future<List<AccountResponse>> getAllAccounts() async {
    return List.unmodifiable(_accounts);
  }

  @override
  Future<AccountResponse> updateAccount(int id, AccountForm form) async {
    final index = _accounts.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw RepositoryException('Не удалось обновить: аккаунт не найден');
    }

    final updated = AccountResponse(
      id: id,
      name: form.name,
      moneyDetails: form.moneyDetails,
    );

    _accounts[index] = updated;

    return updated;
  }
}
