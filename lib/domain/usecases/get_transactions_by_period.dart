import 'package:dartz/dartz.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/failures/failure.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';

class GetTransactionsByPeriod {
  final TransactionRepository repository;

  GetTransactionsByPeriod(this.repository);

  Future<Either<Failure, List<Transaction>>> call({
    required DateTime startDate,
    required DateTime endDate,
    required bool isIncome,
  }) async {
    final result = await repository.getTransactionsByPeriod(
      1,
      startDate,
      endDate,
    );

    return result.map(
      (list) =>
          list
              .where(
                (transaction) => transaction.category?.isIncome == isIncome,
              )
              .toList(),
    );
  }
}
