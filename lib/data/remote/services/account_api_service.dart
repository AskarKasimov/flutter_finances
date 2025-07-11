import 'package:dio/dio.dart';
import 'package:flutter_finances/data/remote/api_client.dart';
import 'package:flutter_finances/data/remote/json_deserializer.dart';
import 'package:flutter_finances/data/remote/models/account/account.dart';
import 'package:flutter_finances/data/remote/models/account_request/account_request.dart';

class AccountApiService {
  final Dio _dio = ApiClient().dio;

  Future<List<AccountDTO>> fetchAccounts() async {
    final response = await _dio.get('/accounts');
    final List data = response.data as List;
    return deserializeListInIsolate(
      data.cast<Map<String, dynamic>>(),
      AccountDTO.fromJson,
    );
  }

  Future<AccountDTO> getAccountById(int id) async {
    final response = await _dio.get('/accounts/$id');
    return deserializeInIsolate(
      response.data as Map<String, dynamic>,
      AccountDTO.fromJson,
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
