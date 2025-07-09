import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';

class GetTransactionByIdUseCase {
  final TransactionRepository transactionRepository;

  GetTransactionByIdUseCase({required this.transactionRepository});

  Future<Transaction> call(int id) {
    return transactionRepository.getTransactionById(id);
  }
}
