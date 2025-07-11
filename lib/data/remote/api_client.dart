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
        headers: {'Authorization': 'Bearer 659hcWG419lR6VyZWLks6Avk'},
      ),
    );
    dio.interceptors.addAll([
      RetryInterceptor(dio: dio),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: print,
      ),
    ]);
  }
}
