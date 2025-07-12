import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;
  final List<int> retryableStatusCodes = [500, 502, 503, 504, 408, 429];

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final statusCode = err.response?.statusCode;

    final shouldRetry =
        statusCode != null && retryableStatusCodes.contains(statusCode);
    final int retryCount = requestOptions.extra['retry_count'] ?? 0;

    if (shouldRetry && retryCount < maxRetries) {
      final nextRetryCount = retryCount + 1;
      final delay = _exponentialBackoffWithJitter(nextRetryCount);

      await Future.delayed(delay);

      final newOptions = Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        extra: {...requestOptions.extra, 'retry_count': nextRetryCount},
      );

      try {
        final response = await dio.request(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: newOptions,
        );
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(e as DioException);
      }
    }

    return handler.next(err);
  }

  Duration _exponentialBackoffWithJitter(int retryCount) {
    final random = Random();
    final backoff = baseDelay.inMilliseconds * pow(2, retryCount);
    final jitter = random.nextInt(100);
    return Duration(milliseconds: backoff.toInt() + jitter);
  }
}
