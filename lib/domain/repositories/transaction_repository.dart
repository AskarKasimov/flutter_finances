import 'package:dartz/dartz.dart';
import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/failures/failure.dart';

abstract interface class TransactionRepository {
  Future<Either<Failure, Transaction>> createTransaction(
    TransactionForm transaction,
  );

  Future<Either<Failure, Transaction>> getTransactionById(int id);

  Future<Either<Failure, Transaction>> updateTransaction(
    int id,
    TransactionForm transaction,
  );

  Future<Either<Failure, Unit>> deleteTransaction(int id);

  Future<Either<Failure, List<Transaction>>> getTransactionsByPeriod(
    int accountId,
    DateTime? startDate,
    DateTime? endDate,
  );
}
