import 'package:flutter_finances/domain/entities/transaction.dart';

sealed class TransactionHistoryEvent {}

class LoadTransactionHistory extends TransactionHistoryEvent {
  final DateTime startDate;
  final DateTime endDate;
  final bool isIncome;

  LoadTransactionHistory({
    required this.startDate,
    required this.endDate,
    required this.isIncome,
  });
}

class AddSingleTransaction extends TransactionHistoryEvent {
  final Transaction transaction;

  AddSingleTransaction(this.transaction);
}

class ChangeTransactionFilter extends TransactionHistoryEvent {
  final bool isIncome;

  ChangeTransactionFilter(this.isIncome);
}

class ChangeTransactionPeriod extends TransactionHistoryEvent {
  final DateTime startDate;
  final DateTime endDate;

  ChangeTransactionPeriod({required this.startDate, required this.endDate});
}

class RemoveSingleTransaction extends TransactionHistoryEvent {
  final int transactionId;

  RemoveSingleTransaction(this.transactionId);
}

class UpdateTransactionInHistory extends TransactionHistoryEvent {
  final Transaction updatedTransaction;

  UpdateTransactionInHistory(this.updatedTransaction);
}