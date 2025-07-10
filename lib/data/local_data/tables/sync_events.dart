import 'package:drift/drift.dart';

enum SyncEventType {
  create,
  update,
  delete,
}

// Drift не поддерживает enum напрямую, сделаем через int
class SyncEvents extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Тип события: 0 = create, 1 = update, 2 = delete
  IntColumn get type => integer()();

  // Тип объекта, например "transaction", "account" и т.д.
  TextColumn get entityType => text()();

  // ID объекта, к которому относится событие (например, transaction id)
  IntColumn get entityId => integer()();

  // JSON-представление данных для синхронизации
  TextColumn get payload => text()();

  // Время создания события
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Статус события: 0 = new, 1 = synced, 2 = failed (можно расширять)
  IntColumn get status => integer().withDefault(const Constant(0))();
}
