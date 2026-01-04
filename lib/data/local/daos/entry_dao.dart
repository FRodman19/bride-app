import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/entries_table.dart';
import '../tables/spends_table.dart';

part 'entry_dao.g.dart';

/// Data Access Object for Daily Entry operations.
@DriftAccessor(tables: [DailyEntries, EntryPlatformSpends])
class EntryDao extends DatabaseAccessor<AppDatabase> with _$EntryDaoMixin {
  EntryDao(super.db);

  /// Get all entries for a tracker
  Future<List<DailyEntry>> getEntriesForTracker(String trackerId) {
    return (select(dailyEntries)
          ..where((e) => e.trackerId.equals(trackerId))
          ..orderBy([(e) => OrderingTerm.desc(e.entryDate)]))
        .get();
  }

  /// Get entry by ID
  Future<DailyEntry?> getEntryById(String id) {
    return (select(dailyEntries)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  /// Get entry for a specific date (to check for duplicates)
  Future<DailyEntry?> getEntryForDate(String trackerId, DateTime date) {
    // Normalize date to start of day for comparison
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(dailyEntries)
          ..where((e) =>
              e.trackerId.equals(trackerId) &
              e.entryDate.isBiggerOrEqualValue(startOfDay) &
              e.entryDate.isSmallerThanValue(endOfDay)))
        .getSingleOrNull();
  }

  /// Insert a new entry
  Future<void> insertEntry(DailyEntriesCompanion entry) {
    return into(dailyEntries).insert(entry);
  }

  /// Update an existing entry
  Future<bool> updateEntry(DailyEntriesCompanion entry) {
    return update(dailyEntries).replace(entry);
  }

  /// Delete an entry (cascades to platform spends)
  Future<void> deleteEntry(String id) async {
    await (delete(entryPlatformSpends)..where((s) => s.entryId.equals(id))).go();
    await (delete(dailyEntries)..where((e) => e.id.equals(id))).go();
  }

  /// Get platform spends for an entry
  Future<List<EntryPlatformSpend>> getSpends(String entryId) {
    return (select(entryPlatformSpends)..where((s) => s.entryId.equals(entryId))).get();
  }

  /// Set platform spends for an entry (replaces existing)
  Future<void> setSpends(String entryId, Map<String, int> spendsByPlatform) async {
    await (delete(entryPlatformSpends)..where((s) => s.entryId.equals(entryId))).go();

    for (final entry in spendsByPlatform.entries) {
      await into(entryPlatformSpends).insert(
        EntryPlatformSpendsCompanion.insert(
          id: '${entryId}_${entry.key}',
          entryId: entryId,
          platform: entry.key,
          amount: Value(entry.value),
        ),
      );
    }
  }

  /// Get total spend for an entry
  Future<int> getTotalSpend(String entryId) async {
    final sum = entryPlatformSpends.amount.sum();
    final query = selectOnly(entryPlatformSpends)
      ..addColumns([sum])
      ..where(entryPlatformSpends.entryId.equals(entryId));
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  /// Get entries within a date range
  Future<List<DailyEntry>> getEntriesInRange(
    String trackerId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(dailyEntries)
          ..where((e) =>
              e.trackerId.equals(trackerId) &
              e.entryDate.isBiggerOrEqualValue(startDate) &
              e.entryDate.isSmallerOrEqualValue(endDate))
          ..orderBy([(e) => OrderingTerm.desc(e.entryDate)]))
        .get();
  }

  /// Calculate total revenue for a tracker
  Future<int> getTotalRevenue(String trackerId) async {
    final sum = dailyEntries.totalRevenue.sum();
    final query = selectOnly(dailyEntries)
      ..addColumns([sum])
      ..where(dailyEntries.trackerId.equals(trackerId));
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  /// Watch entries for a tracker (stream for reactive UI)
  Stream<List<DailyEntry>> watchEntriesForTracker(String trackerId) {
    return (select(dailyEntries)
          ..where((e) => e.trackerId.equals(trackerId))
          ..orderBy([(e) => OrderingTerm.desc(e.entryDate)]))
        .watch();
  }

  /// Get entries pending sync
  Future<List<DailyEntry>> getPendingSyncEntries() {
    return (select(dailyEntries)..where((e) => e.syncStatus.equals('pending'))).get();
  }

  /// Mark entry as synced
  Future<void> markAsSynced(String id) {
    return (update(dailyEntries)..where((e) => e.id.equals(id))).write(
      const DailyEntriesCompanion(syncStatus: Value('synced')),
    );
  }

  /// Update sync status (synced, pending, error)
  Future<void> updateSyncStatus(String id, String status) {
    return (update(dailyEntries)..where((e) => e.id.equals(id))).write(
      DailyEntriesCompanion(syncStatus: Value(status)),
    );
  }
}
