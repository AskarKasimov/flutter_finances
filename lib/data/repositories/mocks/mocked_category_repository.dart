import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/exceptions/RepositoryException.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';

class MockedCategoryRepository implements CategoryRepository {
  final List<Category> _mockCategories = [
    Category(id: 1, name: 'Зарплата', isIncome: true, emoji: '💰'),
    Category(id: 2, name: 'Подарок', isIncome: true, emoji: '🎁'),
    Category(id: 3, name: 'Еда', isIncome: false, emoji: '🍽️'),
    Category(id: 4, name: 'Развлечения', isIncome: false, emoji: '🎉'),
  ];

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      return _mockCategories;
    } catch (e) {
      throw RepositoryException('Ошибка при получении категорий');
    }
  }

  @override
  Future<List<Category>> getCategoriesByIsIncome(bool isIncome) async {
    final filtered =
        _mockCategories.where((c) => c.isIncome == isIncome).toList();
    return filtered;
  }
}
