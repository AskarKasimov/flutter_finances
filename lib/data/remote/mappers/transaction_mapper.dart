import 'package:flutter_finances/data/remote/mappers/types/try_parse_datetime.dart';
import 'package:flutter_finances/data/remote/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/remote/models/transaction/transaction.dart';
import 'package:flutter_finances/data/remote/models/transaction_response/transaction_response.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';

extension TransactionMapper on TransactionDTO {
  Transaction toDomain() {
    final parsedAmount = tryParseDouble(amount, 'amount');
    final parsedTransactionDate = tryParseDateTime(
      transactionDate,
      'transactionDate',
    );
    final parsedCreatedAt = tryParseDateTime(createdAt, 'createdAt');
    final parsedUpdatedAt = tryParseDateTime(updatedAt, 'updatedAt');

    return Transaction(
      id: id,
      accountId: accountId,
      categoryId: categoryId,
      amount: parsedAmount,
      timestamp: parsedTransactionDate,
      comment: comment,
      auditInfoTime: AuditInfoTime(
        createdAt: parsedCreatedAt,
        updatedAt: parsedUpdatedAt,
      ),
    );
  }
}

extension TransactionResponseMapper on TransactionResponseDTO {
  Transaction toDomain() {
    final parsedAmount = tryParseDouble(amount, 'amount');
    final parsedDate = tryParseDateTime(transactionDate, 'transactionDate');
    final accountId = account.id;
    final parsedCreatedAt = tryParseDateTime(createdAt, 'createdAt');
    final parsedUpdatedAt = tryParseDateTime(updatedAt, 'updatedAt');
    final categoryId = category.id;

    return Transaction(
      id: id,
      accountId: accountId,
      categoryId: categoryId,
      amount: parsedAmount,
      timestamp: parsedDate,
      comment: comment,
      auditInfoTime: AuditInfoTime(
        createdAt: parsedCreatedAt,
        updatedAt: parsedUpdatedAt,
      ),
    );
  }
}
