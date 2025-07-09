import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';

class CreateTransactionUseCase {
  final TransactionRepository transactionRepository;

  CreateTransactionUseCase({required this.transactionRepository});

  Future<Transaction> call(TransactionForm form) {
    return transactionRepository.createTransaction(form);
  }
}
