import 'package:dio/dio.dart';
import 'package:flutter_finances/data/remote/json_deserializer.dart';
import 'package:flutter_finances/data/remote/models/transaction/transaction.dart';
import 'package:flutter_finances/data/remote/models/transaction_request/transaction_request.dart';
import 'package:flutter_finances/data/remote/models/transaction_response/transaction_response.dart';

class TransactionApiService {
  final Dio _dio;

  TransactionApiService({required Dio dio}) : _dio = dio;

  Future<TransactionResponseDTO> getTransactionById(int id) async {
    final response = await _dio.get('/transactions/$id');
    return deserializeInIsolate(
      response.data as Map<String, dynamic>,
      TransactionResponseDTO.fromJson,
    );
  }

  Future<List<TransactionResponseDTO>> getTransactionsByPeriod(
    int accountId,
    DateTime from,
    DateTime to,
  ) async {
    final response = await _dio.get(
      '/transactions/account/$accountId/period',
      queryParameters: {
        'startDate': from.toIso8601String(),
        'endDate': to.toIso8601String(),
      },
    );
    final List data = response.data as List;
    return deserializeListInIsolate(
      data.cast<Map<String, dynamic>>(),
      TransactionResponseDTO.fromJson,
    );
  }

  Future<TransactionDTO> createTransaction(
    TransactionRequestDTO request,
  ) async {
    final response = await _dio.post('/transactions', data: request.toJson());
    return deserializeInIsolate(
      response.data as Map<String, dynamic>,
      TransactionDTO.fromJson,
    );
  }

  Future<TransactionResponseDTO> updateTransaction(
    int id,
    TransactionRequestDTO request,
  ) async {
    final response = await _dio.put(
      '/transactions/$id',
      data: request.toJson(),
    );
    return deserializeInIsolate(
      response.data as Map<String, dynamic>,
      TransactionResponseDTO.fromJson,
    );
  }

  Future<void> deleteTransaction(int id) async {
    await _dio.delete('/transactions/$id');
  }
}
