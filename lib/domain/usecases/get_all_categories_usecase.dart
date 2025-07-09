import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';

class GetAllCategoriesUseCase {
  final CategoryRepository categoryRepository;

  GetAllCategoriesUseCase({required this.categoryRepository});

  Future<List<Category>> call() {
    return categoryRepository.getAllCategories();
  }
}
