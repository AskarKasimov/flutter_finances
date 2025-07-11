import 'package:flutter_finances/data/remote/mappers/category_mapper.dart';
import 'package:flutter_finances/data/remote/services/category_api_service.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryApiService _api;

  CategoryRepositoryImpl(this._api);

  @override
  Future<List<Category>> getAllCategories() async {
    final dtos = await _api.fetchCategories();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<Category>> getCategoriesByIsIncome(bool isIncome) async {
    final dtos = await _api.fetchCategoriesByIsIncome(isIncome);
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
