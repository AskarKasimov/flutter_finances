import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';

class UseCaseGetTransactionsByPeriod {
  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;

  UseCaseGetTransactionsByPeriod(this.transactionRepository, this.categoryRepository);

  Future<List<Transaction>> call({
    required DateTime startDate,
    required DateTime endDate,
    required bool isIncome,
  }) async {
    final transactions = await transactionRepository.getTransactionsByPeriod(
      1,
      startDate,
      endDate,
    );

    final categories = await categoryRepository.getCategoriesByIsIncome(
      isIncome,
    );
    final categoryIds = categories.map((c) => c.id).toSet();

    return transactions
        .where((transaction) => categoryIds.contains(transaction.categoryId))
        .toList();
  }
}
