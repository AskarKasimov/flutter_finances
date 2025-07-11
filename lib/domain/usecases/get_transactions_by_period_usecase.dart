import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';

class GetTransactionsByPeriodUseCase {
  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;

  GetTransactionsByPeriodUseCase({
    required this.transactionRepository,
    required this.categoryRepository,
  });

  Future<List<Transaction>> call({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
    required bool? isIncome,
  }) async {
    final transactions = await transactionRepository.getTransactionsByPeriod(
      userId,
      startDate,
      endDate,
    );
    final List<Category> categories;
    if (isIncome != null) {
      categories = await categoryRepository.getCategoriesByIsIncome(isIncome);
    } else {
      categories = await categoryRepository.getAllCategories();
    }
    final categoryIds = categories.map((c) => c.id).toSet();

    return transactions
        .where((transaction) => categoryIds.contains(transaction.categoryId))
        .toList();
  }
}
