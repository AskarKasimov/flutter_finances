import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';

abstract interface class TransactionRepository {
  Future<Transaction> createTransaction(TransactionForm transaction);

  Future<Transaction> getTransactionById(int id);

  Future<Transaction> updateTransaction(int id, TransactionForm transaction);

  Future<void> deleteTransaction(int id);

  Future<List<Transaction>> getTransactionsByPeriod(
    int accountId,
    DateTime startDate,
    DateTime endDate,
  );
}
