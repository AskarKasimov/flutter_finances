import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/exceptions/repository_exception.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';

class MockedTransactionRepository implements TransactionRepository {
  final List<Transaction> _transactions = [
    Transaction(
      id: 1,
      accountId: 1,
      categoryId: 1,
      // Зарплата
      comment: 'Зарплата за июнь',
      amount: 120000,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 2,
      accountId: 1,
      categoryId: 2,
      // Подработка
      comment: 'Фриланс проект',
      amount: 25000,
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Transaction(
      id: 3,
      accountId: 1,
      categoryId: 3,
      // Подарок
      comment: 'На день рождения',
      amount: 7000,
      timestamp: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Transaction(
      id: 4,
      accountId: 1,
      categoryId: 4,
      // Пенсия
      comment: 'Пенсия за июль',
      amount: 18000,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: 5,
      accountId: 1,
      categoryId: 5,
      // Аренда
      comment: 'Аренда квартиры',
      amount: 35000,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: 6,
      accountId: 1,
      categoryId: 6,
      // Одежда
      comment: 'Куртка',
      amount: 7000,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Transaction(
      id: 7,
      accountId: 1,
      categoryId: 7,
      // На собачку
      comment: 'Ветклиника и корм',
      amount: 3000,
      timestamp: DateTime.now().subtract(const Duration(days: 6)),
    ),
    Transaction(
      id: 8,
      accountId: 1,
      categoryId: 8,
      // Ремонт
      comment: 'Кран и плитка',
      amount: 15000,
      timestamp: DateTime.now().subtract(const Duration(days: 8)),
    ),
    Transaction(
      id: 9,
      accountId: 1,
      categoryId: 9,
      // Продукты
      comment: 'Магнит + Пятерочка',
      amount: 870.50,
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    ),
    Transaction(
      id: 10,
      accountId: 1,
      categoryId: 10,
      // Спортзал
      comment: 'Абонемент на месяц',
      amount: 2200,
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Transaction(
      id: 11,
      accountId: 1,
      categoryId: 11,
      // Медицина
      comment: 'Аптека',
      amount: 900,
      timestamp: DateTime.now().subtract(const Duration(days: 9)),
    ),
  ];

  int _nextId() {
    final usedIds = _transactions.map((a) => a.id).toSet();
    int id = 1;
    while (usedIds.contains(id)) {
      id++;
    }
    return id;
  }

  @override
  Future<Transaction> createTransaction(TransactionForm form) async {
    final transaction = Transaction(
      id: _nextId(),
      accountId: form.accountId,
      categoryId: form.categoryId,
      comment: form.comment ?? '',
      amount: form.amount,
      timestamp: DateTime.now(),
    );
    _transactions.add(transaction);
    await Future.delayed(
      const Duration(milliseconds: 1000),
    ); // Simulate network delay
    return transaction;
  }

  @override
  Future<Transaction> deleteTransaction(int transactionId) async {
    final transactionIndex = _transactions.indexWhere(
      (t) => t.id == transactionId,
    );

    if (transactionIndex == -1) {
      throw RepositoryException('Транзакция с id $transactionId не найдена');
    }

    final deletedTransaction = _transactions.removeAt(transactionIndex);
    return deletedTransaction;
  }

  @override
  Future<Transaction> getTransactionById(int id) async {
    final transaction = _transactions.where((a) => a.id == id).firstOrNull;
    if (transaction == null) {
      throw RepositoryException('Транзакция с id $id не найдена');
    }
    return transaction;
  }

  @override
  Future<List<Transaction>> getTransactionsByPeriod(
    int accountId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final filtered = _transactions.where((t) {
      final matchesAccount = t.accountId == accountId;
      final matchesStart = startDate == null || t.timestamp.isAfter(startDate);
      final matchesEnd = endDate == null || t.timestamp.isBefore(endDate);
      return matchesAccount && matchesStart && matchesEnd;
    }).toList();

    return filtered;
  }

  @override
  Future<Transaction> updateTransaction(int id, TransactionForm form) async {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw RepositoryException('Транзакция с id $id не найдена');
    }

    final existing = _transactions[index];
    final updated = Transaction(
      id: id,
      accountId: form.accountId,
      categoryId: form.categoryId,
      comment: form.comment ?? existing.comment,
      amount: form.amount,
      timestamp: form.timestamp,
    );

    _transactions[index] = updated;
    return updated;
  }
}
