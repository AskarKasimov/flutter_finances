import 'package:flutter_finances/domain/entities/account.dart';
import 'package:flutter_finances/domain/entities/category.dart';

class TransactionCreationState {
  final Account? account;
  final Category? category;
  final double amount;
  final DateTime date;
  final String comment;

  String? get validationError {
    if (account == null) return 'Пожалуйста, выберите счёт.';
    if (category == null) return 'Пожалуйста, выберите статью.';
    if (amount <= 0) return 'Сумма должна быть больше нуля.';
    return null;
  }

  bool get isValid => validationError == null;

  TransactionCreationState({
    required this.account,
    required this.category,
    required this.amount,
    required this.date,
    required this.comment,
  });

  factory TransactionCreationState.initial() {
    return TransactionCreationState(
      account: null,
      category: null,
      amount: 0.0,
      date: DateTime.now(),
      comment: '',
    );
  }

  TransactionCreationState copyWith({
    Account? account,
    Category? category,
    double? amount,
    DateTime? date,
    String? comment,
  }) {
    return TransactionCreationState(
      amount: amount ?? this.amount,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      account: account ?? this.account,
      category: category ?? this.category,
    );
  }
}
