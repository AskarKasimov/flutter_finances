import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/exceptions/repository_exception.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';

class MockedCategoryRepository implements CategoryRepository {
  final List<Category> _mockCategories = [
    Category(id: 1, name: 'Зарплата', isIncome: true, emoji: '💼'),
    Category(id: 2, name: 'Подработка', isIncome: true, emoji: '💵'),
    Category(id: 3, name: 'Подарок', isIncome: true, emoji: '🎁'),
    Category(id: 4, name: 'Пенсия', isIncome: true, emoji: '👵'),
    Category(id: 5, name: 'Аренда квартиры', isIncome: false, emoji: '🏠'),
    Category(id: 6, name: 'Одежда', isIncome: false, emoji: '👗'),
    Category(id: 7, name: 'На собачку', isIncome: false, emoji: '🐶'),
    Category(id: 8, name: 'Ремонт квартиры', isIncome: false, emoji: '🔧'),
    Category(id: 9, name: 'Продукты', isIncome: false, emoji: '🍭'),
    Category(id: 10, name: 'Спортзал', isIncome: false, emoji: '🏋'),
    Category(id: 11, name: 'Медицина', isIncome: false, emoji: '💊'),
  ];

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 1000),
      ); // Simulate network delay
      return _mockCategories;
    } catch (e) {
      throw RepositoryException('Ошибка при получении категорий');
    }
  }
}
