import 'package:drift/drift.dart';
import 'package:flutter_finances/data/local_data/database/app_database.dart'
    as db;
import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';
import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';

extension AccountDataMapper on db.Account {
  AccountResponse toDomain() => AccountResponse(
    id: id,
    name: name,
    moneyDetails: MoneyDetails(balance: balance, currency: currency),
  );
}

extension AccountMapper on AccountResponse {
  db.AccountsCompanion toCompanion() => db.AccountsCompanion(
    id: Value(id),
    name: Value(name),
    balance: Value(moneyDetails.balance),
    currency: Value(moneyDetails.currency),
  );
}

extension CategoryDataMapper on db.Category {
  Category toDomain() =>
      Category(id: id, name: name, emoji: emoji, isIncome: isIncome);
}

extension CategoryMapper on Category {
  db.CategoriesCompanion toCompanion() => db.CategoriesCompanion(
    id: Value(id),
    name: Value(name),
    emoji: Value(emoji),
    isIncome: Value(isIncome),
  );
}

extension TransactionDataMapper on db.Transaction {
  Transaction toDomain() => Transaction(
    id: id,
    accountId: accountId,
    categoryId: categoryId,
    amount: amount,
    timestamp: timestamp,
    comment: comment,
  );
}

extension TransactionMapper on Transaction {
  db.TransactionsCompanion toCompanion({bool forUpdate = false}) {
    final companion = db.TransactionsCompanion(
      id: forUpdate ? Value(id) : const Value.absent(),
      accountId: Value(accountId),
      categoryId: Value(categoryId),
      amount: Value(amount),
      timestamp: Value(timestamp),
      comment: Value(comment),
    );
    return companion;
  }
}

extension TransactionFormMapper on TransactionForm {
  db.TransactionsCompanion toCompanion() {
    return db.TransactionsCompanion(
      accountId: Value(accountId),
      categoryId: Value(categoryId),
      amount: Value(amount),
      timestamp: Value(timestamp),
      comment: comment == null ? const Value.absent() : Value(comment!),
    );
  }
}

extension AccountFormExtension on AccountForm {
  db.AccountsCompanion toCompanion({Value<int>? id}) {
    return db.AccountsCompanion(
      id: id ?? const Value.absent(),
      name: Value(name),
      currency: Value(moneyDetails.currency),
    );
  }
}
