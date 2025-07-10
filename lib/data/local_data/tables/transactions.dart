import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get accountId => integer()();

  IntColumn get categoryId => integer()();

  RealColumn get amount => real()();

  DateTimeColumn get timestamp => dateTime()();

  TextColumn get comment => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();
}
