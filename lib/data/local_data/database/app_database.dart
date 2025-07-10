import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_finances/data/local_data/dao/account_dao.dart';
import 'package:flutter_finances/data/local_data/dao/category_dao.dart';
import 'package:flutter_finances/data/local_data/dao/sync_event_dao.dart';
import 'package:flutter_finances/data/local_data/dao/transaction_dao.dart';
import 'package:flutter_finances/data/local_data/tables/accounts.dart';
import 'package:flutter_finances/data/local_data/tables/categories.dart';
import 'package:flutter_finances/data/local_data/tables/sync_events.dart';
import 'package:flutter_finances/data/local_data/tables/transactions.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Accounts, Categories, Transactions, SyncEvents],
  daos: [AccountDao, CategoryDao, TransactionDao, SyncEventDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static Future<AppDatabase> create() async {
    return AppDatabase._internal();
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));
    return NativeDatabase(file);
  });
}
