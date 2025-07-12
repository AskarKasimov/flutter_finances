import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_finances/data/local_data/dao/sync_event_dao.dart';
import 'package:flutter_finances/data/local_data/database/app_database.dart';
import 'package:flutter_finances/data/remote/models/account_request/account_request.dart';
import 'package:flutter_finances/data/remote/models/transaction_request/transaction_request.dart';
import 'package:flutter_finances/data/remote/services/account_api_service.dart';
import 'package:flutter_finances/data/remote/services/category_api_service.dart';
import 'package:flutter_finances/data/remote/services/transaction_api_service.dart';

class SyncService {
  final SyncEventDao syncEventDao;
  final TransactionApiService transactionApi;
  final AccountApiService accountApi;
  final CategoryApiService categoryApi;

  SyncService({
    required this.syncEventDao,
    required this.transactionApi,
    required this.accountApi,
    required this.categoryApi,
  });

  Future<void> syncPendingEvents() async {
    final events = await syncEventDao.getPendingEvents();

    for (final event in events) {
      try {
        final payloadMap = jsonDecode(event.payload) as Map<String, dynamic>;

        switch (event.entityType) {
          case 'transaction':
            await _handleTransaction(event, payloadMap);
            break;
          case 'account':
            await _handleAccount(event, payloadMap);
            break;
        }

        await syncEventDao.markEventSynced(event.id);
      } catch (e) {
        await syncEventDao.markEventFailed(event.id);
        debugPrint('Failed to sync event ${event.id}: $e');
      }
    }
  }

  Future<void> _handleTransaction(
    SyncEvent event,
    Map<String, dynamic> payload,
  ) async {
    final dto = TransactionRequestDTO.fromJson(payload);

    switch (event.type) {
      case 'create':
        await transactionApi.createTransaction(dto);
        break;
      case 'update':
        await transactionApi.updateTransaction(event.entityId, dto);
        break;
      case 'delete':
        await transactionApi.deleteTransaction(event.entityId);
        break;
    }
  }

  Future<void> _handleAccount(
    SyncEvent event,
    Map<String, dynamic> payload,
  ) async {
    final dto = AccountRequestDTO.fromJson(payload);

    switch (event.type) {
      case 'create':
        // TODO: await accountApi.createAccount(dto);
        break;
      case 'update':
        await accountApi.updateAccount(event.entityId, dto);
        break;
      case 'delete':
        // TODO: await accountApi.deleteAccount(event.entityId);
        break;
    }
  }
}
