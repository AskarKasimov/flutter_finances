import 'package:drift/drift.dart';
import 'package:flutter_finances/data/local_data/database/app_database.dart'
    as db;
import 'package:flutter_finances/domain/entities/account.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';

extension AccountDataMapper on db.Account {
  Account toDomain() => Account(
    id: id,
    userId: userId,
    name: name,
    moneyDetails: MoneyDetails(balance: balance, currency: currency),
    auditInfoTime: AuditInfoTime(createdAt: createdAt, updatedAt: updatedAt),
  );
}

extension AccountMapper on Account {
  db.Account toCompanion() => db.Account(
    id: id,
    userId: userId,
    name: name,
    balance: moneyDetails.balance,
    currency: moneyDetails.currency,
    createdAt: auditInfoTime.createdAt,
    updatedAt: auditInfoTime.updatedAt,
  );
}

extension CategoryDataMapper on db.Category {
  Category toDomain() =>
      Category(id: id, name: name, emoji: emoji, isIncome: isIncome);
}

extension CategoryMapper on Category {
  db.CategoriesCompanion toCompanion() => db.CategoriesCompanion.insert(
    name: name,
    emoji: emoji,
    isIncome: isIncome,
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
    auditInfoTime: AuditInfoTime(createdAt: createdAt, updatedAt: updatedAt),
  );
}

extension TransactionMapper on Transaction {
  db.TransactionsCompanion toCompanion() => db.TransactionsCompanion.insert(
    accountId: accountId,
    categoryId: categoryId,
    amount: amount,
    timestamp: timestamp,
    comment: Value(comment),
    createdAt: auditInfoTime.createdAt,
    updatedAt: auditInfoTime.updatedAt,
  );
}
