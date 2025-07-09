import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';

class UpdateTransactionUseCase {
  final TransactionRepository transactionRepository;

  UpdateTransactionUseCase({required this.transactionRepository});

  Future<Transaction> call(int id, TransactionForm form) {
    return transactionRepository.updateTransaction(id, form);
  }
}
