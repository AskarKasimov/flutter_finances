import 'package:flutter_finances/data/remote/mappers/account_form_mapper.dart';
import 'package:flutter_finances/data/remote/mappers/account_mapper.dart';
import 'package:flutter_finances/data/remote/mappers/account_response_mapper.dart';
import 'package:flutter_finances/data/remote/services/account_api_service.dart';
import 'package:flutter_finances/domain/entities/account.dart';
import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountApiService _api;

  AccountRepositoryImpl(this._api);

  @override
  Future<List<Account>> getAllAccounts() async {
    final dtos = await _api.fetchAccounts();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<AccountResponse> getAccountById(int id) async {
    final dto = await _api.getAccountById(id);
    return dto.toDomain();
  }

  @override
  Future<Account> updateAccount(int id, AccountForm account) async {
    final dto = await _api.updateAccount(id, account.toDTO());
    return dto.toDomain();
  }
}
