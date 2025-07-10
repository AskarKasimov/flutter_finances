import 'package:drift/drift.dart';

enum SyncEventType { create, update, delete }

// Drift не поддерживает enum напрямую, сделаем через int
class SyncEvents extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Тип события: 'create', 'update', 'delete'
  TextColumn get type => text()();

  // Тип объекта: 'transaction' или 'account'
  TextColumn get entityType => text()();

  // ID объекта, к которому относится событие (например, transaction id)
  IntColumn get entityId => integer()();

  // JSON-представление данных для синхронизации
  TextColumn get payload => text()();

  // Время создания события
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Статус события: 'new', 'synced', 'failed'
  TextColumn get status => text().withDefault(const Constant('new'))();
}
