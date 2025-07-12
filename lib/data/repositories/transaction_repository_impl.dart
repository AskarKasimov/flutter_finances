import 'dart:convert';

import 'package:flutter_finances/data/local_data/dao/sync_event_dao.dart';
import 'package:flutter_finances/data/local_data/dao/transaction_dao.dart';
import 'package:flutter_finances/data/local_data/database/app_database.dart';
import 'package:flutter_finances/data/local_data/mappers.dart';
import 'package:flutter_finances/data/remote/mappers/transaction_form_mapper.dart';
import 'package:flutter_finances/data/remote/mappers/transaction_mapper.dart';
import 'package:flutter_finances/data/remote/services/transaction_api_service.dart';
import 'package:flutter_finances/data/sync/sync_service.dart';
import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/entities/transaction.dart' as domain;
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionApiService _api;
  final TransactionDao _dao;
  final SyncEventDao _syncEventDao;
  final SyncService _syncService;

  TransactionRepositoryImpl(
    this._api,
    this._dao,
    this._syncEventDao,
    this._syncService,
  );

  @override
  Future<domain.Transaction> createTransaction(
    TransactionForm transaction,
  ) async {
    await _syncService.syncPendingEvents();
    final dto = await _api.createTransaction(transaction.toDTO());

    final domain = dto.toDomain();
    await _dao.insertOrUpdateTransaction(domain.toCompanion());

    await _syncEventDao.insertEvent(
      SyncEventsCompanion.insert(
        entityId: domain.id,
        entityType: 'transaction',
        type: 'create',
        payload: jsonEncode(transaction.toDTO().toJson()),
      ),
    );

    return domain;
  }

  @override
  Future<domain.Transaction> getTransactionById(int id) async {
    await _syncService.syncPendingEvents();
    try {
      final dto = await _api.getTransactionById(id);
      final domain = dto.toDomain();
      await _dao.insertOrUpdateTransaction(domain.toCompanion());
      return domain;
    } catch (e) {
      final local = await _dao.getTransactionById(id);
      if (local == null) throw Exception('Transaction not found locally');
      return local.toDomain();
    }
  }

  @override
  Future<domain.Transaction> updateTransaction(
    int id,
    TransactionForm transaction,
  ) async {
    await _syncService.syncPendingEvents();
    try {
      final dto = await _api.updateTransaction(id, transaction.toDTO());
      final domain = dto.toDomain();
      await _dao.insertOrUpdateTransaction(domain.toCompanion());

      await _syncEventDao.insertEvent(
        SyncEventsCompanion.insert(
          entityId: domain.id,
          entityType: 'transaction',
          type: 'update',
          payload: jsonEncode(transaction.toDTO().toJson()),
        ),
      );

      return domain;
    } catch (e) {
      final companion = transaction.toCompanion();
      await _dao.insertOrUpdateTransaction(companion);

      await _syncEventDao.insertEvent(
        SyncEventsCompanion.insert(
          entityId: id,
          entityType: 'transaction',
          type: 'update',
          payload: jsonEncode(transaction.toDTO().toJson()),
        ),
      );

      final updated = await _dao.getTransactionById(id);
      if (updated == null) throw Exception('Local transaction not found');
      return updated.toDomain();
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await _syncService.syncPendingEvents();
    try {
      await _api.deleteTransaction(id);
      await _dao.deleteTransaction(id);
    } catch (e) {
      await _dao.deleteTransaction(id);

      await _syncEventDao.insertEvent(
        SyncEventsCompanion.insert(
          entityId: id,
          entityType: 'transaction',
          type: 'delete',
          payload: '',
        ),
      );
    }
  }

  @override
  Future<List<domain.Transaction>> getTransactionsByPeriod(
    int accountId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    await _syncService.syncPendingEvents();
    try {
      final dtos = await _api.getTransactionsByPeriod(
        accountId,
        startDate,
        endDate,
      );

      for (final dto in dtos) {
        final domain = dto.toDomain();
        await _dao.insertOrUpdateTransaction(
          domain.toCompanion(forUpdate: true),
        );
      }
    } catch (e) {}

    final local = await _dao.getTransactionsByPeriod(startDate, endDate);
    return local.map((e) => e.toDomain()).toList();
  }
}
