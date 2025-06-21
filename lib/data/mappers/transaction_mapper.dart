import 'package:dartz/dartz.dart';
import 'package:flutter_finances/data/mappers/category_mapper.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_datetime.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/models/transaction/transaction.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';
import 'package:flutter_finances/domain/failures/failure.dart';

import '../models/transaction_response/transaction_response.dart';

extension TransactionMapper on TransactionDTO {
  Either<Failure, Transaction> toDomain() {
    final amountOrFailure = tryParseDouble(amount, 'amount');
    final transactionDateOrFailure = tryParseDateTime(
      transactionDate,
      'transactionDate',
    );
    final createdAtOrFailure = tryParseDateTime(createdAt, 'createdAt');
    final updatedAtOrFailure = tryParseDateTime(updatedAt, 'updatedAt');

    return amountOrFailure.flatMap(
      (parsedAmount) => transactionDateOrFailure.flatMap(
        (parsedTransactionDate) => createdAtOrFailure.flatMap(
          (parsedCreatedAt) => updatedAtOrFailure.map(
            (parsedUpdatedAt) => Transaction(
              id: this.id,
              accountId: accountId,
              categoryId: categoryId,
              category: null,
              amount: parsedAmount,
              timestamp: parsedTransactionDate,
              comment: comment,
              timeInterval: AuditInfoTime(
                createdAt: parsedCreatedAt,
                updatedAt: parsedUpdatedAt,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension TransactionResponseMapper on TransactionResponseDTO {
  Either<Failure, Transaction> toDomain() {
    final amountOrFailure = tryParseDouble(amount, 'amount');
    final transactionDateOrFailure = tryParseDateTime(
      transactionDate,
      'transactionDate',
    );
    final accountId = account.id;
    final createdAtOrFailure = tryParseDateTime(createdAt, 'createdAt');
    final updatedAtOrFailure = tryParseDateTime(updatedAt, 'updatedAt');
    final categoryId = category.id;
    final categoryOrFailure = category.toDomain();

    return amountOrFailure.flatMap((parsedAmount) {
      return transactionDateOrFailure.flatMap((parsedDate) {
        return createdAtOrFailure.flatMap((createdAt) {
          return updatedAtOrFailure.flatMap((updatedAt) {
            return categoryOrFailure.map((parsedCategory) {
              return Transaction(
                id: this.id,
                accountId: accountId,
                categoryId: categoryId,
                category: parsedCategory,
                amount: parsedAmount,
                timestamp: parsedDate,
                comment: comment,
                timeInterval: AuditInfoTime(
                  createdAt: createdAt,
                  updatedAt: updatedAt,
                ),
              );
            });
          });
        });
      });
    });
  }
}
