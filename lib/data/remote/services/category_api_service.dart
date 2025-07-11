import 'package:dio/dio.dart';
import 'package:flutter_finances/data/remote/json_deserializer.dart';
import 'package:flutter_finances/data/remote/models/category/category.dart';

class CategoryApiService {
  final Dio _dio;

  CategoryApiService({required Dio dio}) : _dio = dio;

  Future<List<CategoryDTO>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories');
      final List data = response.data as List;
      return deserializeListInIsolate(
        data.cast<Map<String, dynamic>>(),
        CategoryDTO.fromJson,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      rethrow;
    }
  }
}
