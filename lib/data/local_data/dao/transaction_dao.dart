import 'package:drift/drift.dart';
import 'package:flutter_finances/data/local_data/database/app_database.dart';
import 'package:flutter_finances/data/local_data/tables/transactions.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Future<Transaction?> getTransactionById(int id) async {
    final data = await (select(
      transactions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    if (data == null) return null;
    return data;
  }

  Future<List<Transaction>> getTransactionsByPeriod(
    DateTime from,
    DateTime to,
  ) async {
    final data =
        await (select(transactions)..where(
              (t) =>
                  t.timestamp.isBiggerOrEqualValue(from) &
                  t.timestamp.isSmallerOrEqualValue(to),
            ))
            .get();

    return data;
  }

  Future<int> insertTransaction(TransactionsCompanion tx) =>
      into(transactions).insert(tx);

  Future<bool> updateTransaction(TransactionsCompanion tx) =>
      update(transactions).replace(tx);

  Future<int> deleteTransaction(int id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();
}
