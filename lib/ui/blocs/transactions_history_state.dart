import 'package:flutter_finances/domain/entities/transaction.dart';

sealed class TransactionHistoryState {
  final DateTime startDate;
  final DateTime endDate;

  TransactionHistoryState({required this.startDate, required this.endDate});
}

class TransactionHistoryLoading extends TransactionHistoryState {
  TransactionHistoryLoading({required super.startDate, required super.endDate});
}

class TransactionHistoryLoaded extends TransactionHistoryState {
  final List<Transaction> transactions;

  TransactionHistoryLoaded({
    required this.transactions,
    required super.startDate,
    required super.endDate,
  });
}

class TransactionHistoryError extends TransactionHistoryState {
  final String message;

  TransactionHistoryError({
    required this.message,
    required super.startDate,
    required super.endDate,
  });
}
