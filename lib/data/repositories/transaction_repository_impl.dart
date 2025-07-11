import 'package:flutter_finances/data/remote/mappers/transaction_form_mapper.dart';
import 'package:flutter_finances/data/remote/mappers/transaction_mapper.dart';
import 'package:flutter_finances/data/remote/services/transaction_api_service.dart';
import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionApiService _api;

  TransactionRepositoryImpl(this._api);

  @override
  Future<Transaction> createTransaction(TransactionForm transaction) async {
    final dto = await _api.createTransaction(transaction.toDTO());
    return dto.toDomain();
  }

  @override
  Future<Transaction> getTransactionById(int id) async {
    final dto = await _api.getTransactionById(id);
    return dto.toDomain();
  }

  @override
  Future<Transaction> updateTransaction(
    int id,
    TransactionForm transaction,
  ) async {
    final dto = await _api.updateTransaction(id, transaction.toDTO());
    return dto.toDomain();
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await _api.deleteTransaction(id);
  }

  @override
  Future<List<Transaction>> getTransactionsByPeriod(
    int accountId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final from = startDate;
    final to = endDate;

    final dtos = await _api.getTransactionsByPeriod(accountId, from, to);
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
