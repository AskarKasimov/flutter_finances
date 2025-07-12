import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_finances/data/local_data/dao/account_dao.dart';
import 'package:flutter_finances/data/local_data/dao/sync_event_dao.dart';
import 'package:flutter_finances/data/local_data/database/app_database.dart';
import 'package:flutter_finances/data/local_data/mappers.dart';
import 'package:flutter_finances/data/remote/mappers/account_form_mapper.dart';
import 'package:flutter_finances/data/remote/mappers/account_response_mapper.dart';
import 'package:flutter_finances/data/remote/services/account_api_service.dart';
import 'package:flutter_finances/data/sync/sync_service.dart';
import 'package:flutter_finances/domain/entities/account_response.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountDao _dao;
  final AccountApiService _api;
  final SyncEventDao _syncDao;
  final SyncService _syncService;

  AccountRepositoryImpl(this._dao, this._api, this._syncDao, this._syncService);

  @override
  Future<List<AccountResponse>> getAllAccounts() async {
    await _syncService.syncPendingEvents();

    try {
      // Получаем аккаунты с сервера через API
      final apiAccountsDto = await _api.fetchAccounts();

      // Преобразуем и сохраняем в локальную базу
      for (final dto in apiAccountsDto) {
        final accountEntity = dto.toDomain();
        await _dao.insertOrUpdateAccount(accountEntity.toCompanion());
      }
    } catch (e) {
      // Логируем ошибку или игнорируем (например, офлайн-режим)
      print('Ошибка при загрузке аккаунтов с API: $e');
    }

    // Возвращаем аккаунты из локальной базы (обновленные)
    final localAccounts = await _dao.getAllAccounts();
    return localAccounts.map((it) => it.toDomain()).toList();
  }

  @override
  Future<AccountResponse> getAccountById(int id) async {
    await _syncService.syncPendingEvents();

    try {
      final apiAccountDto = await _api.getAccountById(id);
      final accountEntity = apiAccountDto.toDomain();
      await _dao.insertOrUpdateAccount(accountEntity.toCompanion());
    } catch (e) {
      print('Ошибка при загрузке аккаунта с API: $e');
      // Можно продолжить и вернуть локальные данные даже при ошибке API (например, офлайн)
    }

    final localAccount = await _dao.getAccountById(id);
    if (localAccount == null) {
      throw Exception('Account with id $id not found');
    }
    return localAccount.toDomain();
  }

  @override
  Future<AccountResponse> updateAccount(int id, AccountForm accountForm) async {
    await _syncService.syncPendingEvents();

    await _dao.updateAccountById(accountForm.toCompanion(id: Value(id)));

    await _syncDao.insertEvent(
      SyncEventsCompanion.insert(
        entityId: id,
        entityType: 'account',
        type: 'update',
        payload: jsonEncode(accountForm.toDTO().toJson()),
      ),
    );

    final updated = await _dao.getAccountById(id);
    return updated!.toDomain();
  }
}
