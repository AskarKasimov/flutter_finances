import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';
import 'package:flutter_finances/domain/exceptions/RepositoryException.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';

class MockedTransactionRepository implements TransactionRepository {
  final List<Transaction> _transactions = [
    Transaction(
      id: 1,
      accountId: 1,
      categoryId: 1,
      comment: 'Магнит',
      amount: 870.50,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      auditInfoTime: AuditInfoTime(
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
    ),
    Transaction(
      id: 2,
      accountId: 1,
      categoryId: 2,
      comment: 'Аванс',
      amount: 25000.00,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      auditInfoTime: AuditInfoTime(
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ),
    Transaction(
      id: 3,
      accountId: 1,
      categoryId: 3,
      comment: 'Пиццерия',
      amount: 1250.00,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      auditInfoTime: AuditInfoTime(
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ),
    Transaction(
      id: 4,
      accountId: 1,
      categoryId: 4,
      comment: 'Steam',
      amount: 1900.99,
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      auditInfoTime: AuditInfoTime(
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ),
    Transaction(
      id: 5,
      accountId: 1,
      categoryId: 5,
      comment: 'От мамы',
      amount: 3000.00,
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      auditInfoTime: AuditInfoTime(
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
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
      accountId: form.accountId!,
      categoryId: form.categoryId!,
      comment: form.comment ?? '',
      amount: form.amount ?? 0.0,
      timestamp: DateTime.now(),
      auditInfoTime: AuditInfoTime(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    _transactions.add(transaction);
    return transaction;
  }

  @override
  Future<bool> deleteTransaction(int id) async {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw RepositoryException('Транзакция с id $id не найдена');
    }
    _transactions.removeAt(index);
    return true;
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
      accountId: form.accountId ?? existing.accountId,
      categoryId: form.categoryId ?? existing.categoryId,
      comment: form.comment ?? existing.comment,
      amount: form.amount ?? existing.amount,
      timestamp: form.timestamp ?? existing.timestamp,
      auditInfoTime: AuditInfoTime(
        createdAt: existing.auditInfoTime.createdAt,
        updatedAt: DateTime.now(),
      ),
    );

    _transactions[index] = updated;
    return updated;
  }
}
