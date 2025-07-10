import 'package:drift/drift.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer()();

  TextColumn get name => text()();

  RealColumn get balance => real()();

  TextColumn get currency => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();
}
