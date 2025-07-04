import 'package:flutter_finances/domain/entities/account.dart';
import 'package:flutter_finances/domain/entities/category.dart';

sealed class TransactionCreationEvent {}

class TransactionAccountChanged extends TransactionCreationEvent {
  final Account account;

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

class TransactionSubmitted extends TransactionCreationEvent {}

class TransactionFormReset extends TransactionCreationEvent {}
