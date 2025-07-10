import 'package:drift/drift.dart';
import 'package:flutter_finances/data/local_data/database/app_database.dart';
import 'package:flutter_finances/data/local_data/tables/sync_events.dart';

part 'sync_event_dao.g.dart';

@DriftAccessor(tables: [SyncEvents])
class SyncEventDao extends DatabaseAccessor<AppDatabase>
    with _$SyncEventDaoMixin {
  SyncEventDao(super.db);

  Future<int> insertEvent(SyncEventsCompanion event) =>
      db.into(db.syncEvents).insert(event);

  Future<List<SyncEvent>> getPendingEvents() =>
      (db.select(db.syncEvents)..where((tbl) => tbl.status.equals(0))).get();

  Future<void> markEventSynced(int id) =>
      (db.update(db.syncEvents)..where((tbl) => tbl.id.equals(id))).write(
        const SyncEventsCompanion(status: Value(1)),
      );

  Future<void> deleteEvent(int id) =>
      (db.delete(db.syncEvents)..where((tbl) => tbl.id.equals(id))).go();
}
