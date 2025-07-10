import 'package:dio/dio.dart';
import 'package:flutter_finances/data/remote/retry_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  late final Dio dio;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://shmr-finance.ru/api/v1/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );
    dio.interceptors.add(RetryInterceptor(dio: dio));
  }
}
