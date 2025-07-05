import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';

class TransactionCreationState {
  final AccountState? accountState;
  final Category? category;
  final double amount;
  final DateTime date;
  final String comment;

  String? get validationError {
    if (accountState == null) return 'Пожалуйста, выберите счёт.';
    if (category == null) return 'Пожалуйста, выберите статью.';
    if (amount <= 0) return 'Сумма должна быть больше нуля.';
    return null;
  }

  bool get isValid => validationError == null;

  TransactionCreationState({
    required this.accountState,
    required this.category,
    required this.amount,
    required this.date,
    required this.comment,
  });

  factory TransactionCreationState.initial() {
    return TransactionCreationState(
      accountState: null,
      category: null,
      amount: 0.0,
      date: DateTime.now(),
      comment: '',
    );
  }

  TransactionCreationState copyWith({
    AccountState? accountState,
    Category? category,
    double? amount,
    DateTime? date,
    String? comment,
  }) {
    return TransactionCreationState(
      amount: amount ?? this.amount,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      accountState: accountState ?? this.accountState,
      category: category ?? this.category,
    );
  }
}

class TransactionSubmittedSuccessfully extends TransactionCreationState {
  final Transaction createdTransaction;

  TransactionSubmittedSuccessfully(
    this.createdTransaction,
    TransactionCreationState previous,
  ) : super(
        accountState: previous.accountState,
        category: previous.category,
        amount: previous.amount,
        date: previous.date,
        comment: previous.comment,
      );
}
