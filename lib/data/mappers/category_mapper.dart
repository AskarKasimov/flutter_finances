import 'package:flutter_finances/data/models/category/category.dart';
import 'package:flutter_finances/domain/entities/category.dart';

extension CategoryMapper on CategoryDTO {
  Category toDomain() {
    return Category(id: id, name: name, emoji: emoji, isIncome: isIncome);
  }
}
