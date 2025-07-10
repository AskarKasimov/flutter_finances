import 'package:dio/dio.dart';
import 'package:flutter_finances/data/remote/api_client.dart';
import 'package:flutter_finances/data/remote/models/account/account.dart';
import 'package:flutter_finances/data/remote/models/account_request/account_request.dart';

class AccountApiService {
  final Dio _dio = ApiClient().dio;

  Future<List<AccountDTO>> fetchAccounts() async {
    final response = await _dio.get('/accounts');
    final List data = response.data as List;

    return data
        .map((json) => AccountDTO.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<AccountDTO> getAccountById(int id) async {
    final response = await _dio.get('/accounts/$id');
    return AccountDTO.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AccountDTO> updateAccount(int id, AccountRequestDTO request) async {
    final response = await _dio.put('/accounts/$id', data: request.toJson());
    return AccountDTO.fromJson(response.data as Map<String, dynamic>);
  }
}
