import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/sync_queue_table.dart';

part 'sync_dao.g.dart';

/// Data Access Object for Sync Queue operations.
@DriftAccessor(tables: [SyncQueue])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(super.db);

  /// Add an item to the sync queue
  Future<void> addToQueue({
    required String targetTable,
    required String recordId,
    required String operation,
    required String payload,
  }) {
    return into(syncQueue).insert(
      SyncQueueCompanion.insert(
        targetTable: targetTable,
        recordId: recordId,
        operation: operation,
        payload: payload,
      ),
    );
  }

  /// Get all pending sync items
  Future<List<SyncQueueData>> getPendingItems() {
    return (select(syncQueue)..orderBy([(s) => OrderingTerm.asc(s.id)])).get();
  }

  /// Get count of pending sync items
  Future<int> getPendingCount() async {
    final count = countAll();
    final query = selectOnly(syncQueue)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Remove item from queue after successful sync
  Future<void> removeFromQueue(int id) {
    return (delete(syncQueue)..where((s) => s.id.equals(id))).go();
  }

  /// Update retry count and error message on failure
  Future<void> markRetry(int id, String error) async {
    final item = await (select(syncQueue)..where((s) => s.id.equals(id))).getSingleOrNull();
    if (item == null) return;

    await (update(syncQueue)..where((s) => s.id.equals(id))).write(
      SyncQueueCompanion(
        retryCount: Value(item.retryCount + 1),
        lastError: Value(error),
        lastAttemptAt: Value(DateTime.now()),
      ),
    );
  }

  /// Remove items that have exceeded max retries
  Future<void> removeFailedItems({int maxRetries = 5}) {
    return (delete(syncQueue)..where((s) => s.retryCount.isBiggerOrEqualValue(maxRetries))).go();
  }

  /// Clear all items for a specific record (when deleted locally)
  Future<void> clearForRecord(String recordId) {
    return (delete(syncQueue)..where((s) => s.recordId.equals(recordId))).go();
  }

  /// Clear entire queue
  Future<void> clearQueue() {
    return delete(syncQueue).go();
  }

  /// Watch pending count (for UI indicator)
  Stream<int> watchPendingCount() {
    final count = countAll();
    return (selectOnly(syncQueue)..addColumns([count]))
        .watchSingle()
        .map((row) => row.read(count) ?? 0);
  }
}
