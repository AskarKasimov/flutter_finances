import 'package:drift/drift.dart';
import 'package:flutter_finances/data/local_data/database/app_database.dart';
import 'package:flutter_finances/data/local_data/tables/accounts.dart';

part 'account_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(super.db);

  Future<List<Account>> getAllAccounts() =>
      (select(accounts)..orderBy([(t) => OrderingTerm.desc(t.id)])).get();

  Future<Account?> getAccountById(int id) =>
      (select(accounts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertAccount(AccountsCompanion account) =>
      into(accounts).insert(account);

  Future<bool> updateAccountById(AccountsCompanion account) =>
      update(accounts).replace(account);

  Future<void> insertOrUpdateAccount(AccountsCompanion account) async {
    await into(accounts).insertOnConflictUpdate(account);
  }

  Future<int> deleteAccount(int id) =>
      (delete(accounts)..where((t) => t.id.equals(id))).go();
}
