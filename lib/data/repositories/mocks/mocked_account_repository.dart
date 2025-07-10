import 'package:flutter_finances/domain/entities/account.dart';
import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';
import 'package:flutter_finances/domain/exceptions/repository_exception.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';

class MockedAccountRepository implements AccountRepository {
  final List<Account> _accounts = [
    Account(
      id: 1,
      userId: 1,
      name: 'Mocked Account',
      moneyDetails: MoneyDetails(balance: 114, currency: '₽'),
      auditInfoTime: AuditInfoTime(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ),
  ];

  int _nextId() {
    final usedIds = _accounts.map((a) => a.id).toSet();
    int id = 1;
    while (usedIds.contains(id)) {
      id++;
    }
    return id;
  }

  @override
  Future<Account> createAccount(AccountForm form) async {
    final account = Account(
      id: _nextId(),
      userId: 1,
      name: form.name ?? 'Mocked Account',
      moneyDetails:
          form.moneyDetails ?? MoneyDetails(balance: 0, currency: '₽'),
      auditInfoTime: AuditInfoTime(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    _accounts.add(account);
    return account;
  }

  @override
  Future<AccountResponse> getAccountById(int id) async {
    final account = _accounts.where((a) => a.id == id).firstOrNull;

    if (account == null) {
      throw RepositoryException('Аккаунт с id $id не найден');
    }

    return AccountResponse(
      id: account.id,
      name: account.name,
      moneyDetails: account.moneyDetails,
      auditInfoTime: account.auditInfoTime,
    );
  }

  @override
  Future<List<Account>> getAllAccounts() async {
    return List.unmodifiable(_accounts);
  }

  @override
  Future<Account> updateAccount(int id, AccountForm form) async {
    final index = _accounts.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw RepositoryException('Не удалось обновить: аккаунт не найден');
    }

    final updated = Account(
      id: id,
      userId: _accounts[index].userId,
      name: form.name ?? _accounts[index].name,
      moneyDetails: form.moneyDetails ?? _accounts[index].moneyDetails,
      auditInfoTime: AuditInfoTime(
        createdAt: _accounts[index].auditInfoTime.createdAt,
        updatedAt: DateTime.now(),
      ),
    );

    _accounts[index] = updated;

    return updated;
  }
}
