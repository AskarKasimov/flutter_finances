import '../entities/category.dart';

abstract interface class CategoryRepository {
  Future<List<Category>> getAllCategories();

  Future<List<Category>> getCategoriesByIsIncome(bool isIncome);
}
