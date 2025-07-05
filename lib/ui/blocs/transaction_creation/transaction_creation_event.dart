import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/category.dart';

sealed class TransactionCreationEvent {}

class TransactionAccountChanged extends TransactionCreationEvent {
  final AccountState account;

  TransactionAccountChanged(this.account);
}

class TransactionCategoryChanged extends TransactionCreationEvent {
  final Category category;

  TransactionCategoryChanged(this.category);
}

class TransactionAmountChanged extends TransactionCreationEvent {
  final double amount;

  TransactionAmountChanged(this.amount);
}

class TransactionDateChanged extends TransactionCreationEvent {
  final DateTime date;

  TransactionDateChanged(this.date);
}

class TransactionCommentChanged extends TransactionCreationEvent {
  final String comment;

  TransactionCommentChanged(this.comment);
}

class CreateTransactionSubmitted extends TransactionCreationEvent {
  CreateTransactionSubmitted();
}

class UpdateTransactionSubmitted extends TransactionCreationEvent {
  final int transactionId;

  UpdateTransactionSubmitted({required this.transactionId});
}

class TransactionFormReset extends TransactionCreationEvent {}

class InitializeForEditing extends TransactionCreationEvent {
  final int transactionId;

  InitializeForEditing({required this.transactionId});
}
