import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();

  Future<void> addCategory(Category category);
}
