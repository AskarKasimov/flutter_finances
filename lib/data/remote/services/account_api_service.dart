import 'package:dio/dio.dart';
import 'package:flutter_finances/data/remote/json_deserializer.dart';
import 'package:flutter_finances/data/remote/models/account/account.dart';
import 'package:flutter_finances/data/remote/models/account_request/account_request.dart';
import 'package:flutter_finances/data/remote/models/account_response/account_response.dart';

class AccountApiService {
  final Dio _dio;

  AccountApiService({required Dio dio}) : _dio = dio;

  Future<List<AccountDTO>> fetchAccounts() async {
    final response = await _dio.get('/accounts');
    final List data = response.data as List;
    return deserializeListInIsolate(
      data.cast<Map<String, dynamic>>(),
      AccountDTO.fromJson,
    );
  }

  Future<AccountResponseDTO> getAccountById(int id) async {
    final response = await _dio.get('/accounts/$id');
    return deserializeInIsolate(
      response.data as Map<String, dynamic>,
      AccountResponseDTO.fromJson,
    );
  }

  Future<AccountDTO> updateAccount(int id, AccountRequestDTO request) async {
    final response = await _dio.put('/accounts/$id', data: request.toJson());
    return deserializeInIsolate(
      response.data as Map<String, dynamic>,
      AccountDTO.fromJson,
    );
  }
}
