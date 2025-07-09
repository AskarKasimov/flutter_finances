import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';

sealed class TransactionCreationState {}

class TransactionDataState extends TransactionCreationState {
  final AccountState? accountState;
  final Category? category;
  final double amount;
  final DateTime date;
  final String comment;

  TransactionDataState({
    required this.accountState,
    required this.category,
    required this.amount,
    required this.date,
    required this.comment,
  });

  factory TransactionDataState.initial() => TransactionDataState(
    accountState: null,
    category: null,
    amount: 0,
    date: DateTime.now(),
    comment: '',
  );

  TransactionDataState copyWith({
    AccountState? accountState,
    Category? category,
    double? amount,
    DateTime? date,
    String? comment,
  }) {
    return TransactionDataState(
      accountState: accountState ?? this.accountState,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      comment: comment ?? this.comment,
    );
  }

  String? get validationError {
    if (accountState == null) return 'Пожалуйста, выберите счёт.';
    if (category == null) return 'Пожалуйста, выберите статью.';
    if (amount <= 0) return 'Сумма должна быть больше нуля.';
    return null;
  }

  bool get isValid => validationError == null;
}

class TransactionProcessing extends TransactionCreationState {}

class TransactionError extends TransactionCreationState {
  final String message;

  TransactionError({required this.message});
}

class TransactionCreatedSuccessfully extends TransactionCreationState {
  final TransactionDataState data;
  final Transaction createdTransaction;

  TransactionCreatedSuccessfully(this.createdTransaction, this.data);
}

class TransactionDeletedSuccessfully extends TransactionCreationState {
  final TransactionDataState data;
  final Transaction deletedTransaction;

  TransactionDeletedSuccessfully(this.deletedTransaction, this.data);
}

class TransactionUpdatedSuccessfully extends TransactionCreationState {
  final TransactionDataState data;
  final Transaction updatedTransaction;

  TransactionUpdatedSuccessfully(this.updatedTransaction, this.data);
}
