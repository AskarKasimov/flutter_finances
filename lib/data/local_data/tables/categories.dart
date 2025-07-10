import 'package:drift/drift.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get emoji => text()();

  BoolColumn get isIncome => boolean()();
}
