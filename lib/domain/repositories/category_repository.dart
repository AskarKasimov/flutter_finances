import 'package:flutter_finances/domain/entities/category.dart';

abstract interface class CategoryRepository {
  Future<List<Category>> getAllCategories();
}
