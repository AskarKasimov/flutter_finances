import 'package:dio/dio.dart';
import 'package:flutter_finances/data/remote/api_client.dart';
import 'package:flutter_finances/data/remote/json_deserializer.dart';
import 'package:flutter_finances/data/remote/models/category/category.dart';

class CategoryApiService {
  final Dio _dio = ApiClient().dio;

  Future<List<CategoryDTO>> fetchCategories() async {
    final response = await _dio.get('/categories');
    final List data = response.data as List;
    return deserializeListInIsolate(
      data.cast<Map<String, dynamic>>(),
      CategoryDTO.fromJson,
    );
  }

  Future<List<CategoryDTO>> fetchCategoriesByIsIncome(bool isIncome) async {
    final response = await _dio.get('/categories/$isIncome');
    final List data = response.data as List;
    return deserializeListInIsolate(
      data.cast<Map<String, dynamic>>(),
      CategoryDTO.fromJson,
    );
  }
}
