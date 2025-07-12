import 'package:flutter_finances/domain/repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository transactionRepository;

  DeleteTransactionUseCase({required this.transactionRepository});

  Future<void> call(int transactionId) {
    return transactionRepository.deleteTransaction(transactionId);
  }
}
