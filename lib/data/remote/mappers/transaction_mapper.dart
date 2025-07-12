import 'package:flutter_finances/data/remote/mappers/types/try_parse_datetime.dart';
import 'package:flutter_finances/data/remote/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/remote/models/transaction/transaction.dart';
import 'package:flutter_finances/data/remote/models/transaction_response/transaction_response.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';

extension TransactionMapper on TransactionDTO {
  Transaction toDomain() {
    final parsedAmount = tryParseDouble(amount, 'amount');
    final parsedTransactionDate = tryParseDateTime(
      transactionDate,
      'transactionDate',
    );

    return Transaction(
      id: id,
      accountId: accountId,
      categoryId: categoryId,
      amount: parsedAmount,
      timestamp: parsedTransactionDate,
      comment: comment,
    );
  }
}

extension TransactionResponseMapper on TransactionResponseDTO {
  Transaction toDomain() {
    final parsedAmount = tryParseDouble(amount, 'amount');
    final parsedDate = tryParseDateTime(transactionDate, 'transactionDate');
    final accountId = account.id;
    final categoryId = category.id;

    return Transaction(
      id: id,
      accountId: accountId,
      categoryId: categoryId,
      amount: parsedAmount,
      timestamp: parsedDate,
      comment: comment,
    );
  }
}
