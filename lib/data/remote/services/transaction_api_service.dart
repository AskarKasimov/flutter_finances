import 'package:dio/dio.dart';
import 'package:flutter_finances/data/remote/api_client.dart';
import 'package:flutter_finances/data/remote/models/transaction/transaction.dart';
import 'package:flutter_finances/data/remote/models/transaction_request/transaction_request.dart';
import 'package:flutter_finances/data/remote/models/transaction_response/transaction_response.dart';

class TransactionApiService {
  final Dio _dio = ApiClient().dio;

  Future<TransactionResponseDTO> getTransactionById(int id) async {
    final response = await _dio.get('/transactions/$id');
    return TransactionResponseDTO.fromJson(
      response.data as Map<String, dynamic>,
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
    return data
        .map(
          (json) =>
              TransactionResponseDTO.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<TransactionDTO> createTransaction(
    TransactionRequestDTO request,
  ) async {
    final response = await _dio.post('/transactions', data: request.toJson());
    return TransactionDTO.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TransactionResponseDTO> updateTransaction(
    int id,
    TransactionRequestDTO request,
  ) async {
    final response = await _dio.put(
      '/transactions/$id',
      data: request.toJson(),
    );
    return TransactionResponseDTO.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> deleteTransaction(int id) async {
    await _dio.delete('/transactions/$id');
  }
}
