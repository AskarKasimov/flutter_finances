import 'package:flutter_finances/data/local_data/dao/category_dao.dart';
import 'package:flutter_finances/data/local_data/mappers.dart';
import 'package:flutter_finances/data/remote/mappers/category_mapper.dart';
import 'package:flutter_finances/data/remote/services/category_api_service.dart';
import 'package:flutter_finances/data/sync/sync_service.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryApiService _api;
  final CategoryDao _dao;
  final SyncService _syncService;


  CategoryRepositoryImpl(this._api, this._dao, this._syncService);

  @override
  Future<List<Category>> getAllCategories() async {
    await _syncService.syncPendingEvents();
    try {
      final dtos = await _api.fetchCategories();
      for (final dto in dtos) {
        final entity = dto.toDomain();
        await _dao.insertOrUpdateCategory(entity.toCompanion());
      }
    } catch (e) {}
    final localEntities = await _dao.getAllCategories();
    return localEntities.map((e) => e.toDomain()).toList();
  }
}
