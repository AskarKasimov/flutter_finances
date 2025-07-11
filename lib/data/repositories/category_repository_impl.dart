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
    final dtos = await _api.fetchCategories();
    final filteredByIsIncome = dtos.where(
      (category) => category.isIncome == isIncome,
    );
    return filteredByIsIncome.map((dto) => dto.toDomain()).toList();
  }
}
