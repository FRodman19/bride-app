import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/trackers_table.dart';
import '../tables/platforms_table.dart';
import '../tables/goals_table.dart';

part 'tracker_dao.g.dart';

/// Data Access Object for Tracker operations.
@DriftAccessor(tables: [Trackers, TrackerPlatforms, TrackerGoals])
class TrackerDao extends DatabaseAccessor<AppDatabase> with _$TrackerDaoMixin {
  TrackerDao(super.db);

  /// Get all active (non-archived) trackers for a user
  Future<List<Tracker>> getActiveTrackers(String userId) {
    return (select(trackers)
          ..where((t) => t.userId.equals(userId) & t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  /// Get all archived trackers for a user
  Future<List<Tracker>> getArchivedTrackers(String userId) {
    return (select(trackers)
          ..where((t) => t.userId.equals(userId) & t.isArchived.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  /// Get tracker by ID
  Future<Tracker?> getTrackerById(String id) {
    return (select(trackers)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get count of active trackers for a user (for 20 limit check)
  Future<int> getActiveTrackerCount(String userId) async {
    final count = countAll();
    final query = selectOnly(trackers)
      ..addColumns([count])
      ..where(trackers.userId.equals(userId) & trackers.isArchived.equals(false));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Upsert a tracker (insert or replace if exists)
  Future<void> upsertTracker(TrackersCompanion tracker) {
    return into(trackers).insert(
      tracker,
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Insert a new tracker (legacy - use upsertTracker instead)
  @Deprecated('Use upsertTracker to handle conflicts properly')
  Future<void> insertTracker(TrackersCompanion tracker) {
    return upsertTracker(tracker);
  }

  /// Update an existing tracker
  Future<bool> updateTracker(TrackersCompanion tracker) {
    return update(trackers).replace(tracker);
  }

  /// Archive a tracker
  Future<void> archiveTracker(String id) {
    return (update(trackers)..where((t) => t.id.equals(id))).write(
      TrackersCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value('pending'),
      ),
    );
  }

  /// Restore a tracker from archive
  Future<void> restoreTracker(String id) {
    return (update(trackers)..where((t) => t.id.equals(id))).write(
      TrackersCompanion(
        isArchived: const Value(false),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value('pending'),
      ),
    );
  }

  /// Delete a tracker (cascades to platforms and goals)
  Future<void> deleteTracker(String id) async {
    await (delete(trackerGoals)..where((g) => g.trackerId.equals(id))).go();
    await (delete(trackerPlatforms)..where((p) => p.trackerId.equals(id))).go();
    await (delete(trackers)..where((t) => t.id.equals(id))).go();
  }

  /// Get platforms for a tracker
  Future<List<TrackerPlatform>> getTrackerPlatforms(String trackerId) {
    return (select(trackerPlatforms)
          ..where((p) => p.trackerId.equals(trackerId))
          ..orderBy([(p) => OrderingTerm.asc(p.displayOrder)]))
        .get();
  }

  /// Set platforms for a tracker (replaces existing)
  Future<void> setTrackerPlatforms(String trackerId, List<String> platformIds) async {
    await (delete(trackerPlatforms)..where((p) => p.trackerId.equals(trackerId))).go();

    for (var i = 0; i < platformIds.length; i++) {
      await into(trackerPlatforms).insert(
        TrackerPlatformsCompanion.insert(
          id: '${trackerId}_${platformIds[i]}',
          trackerId: trackerId,
          platform: platformIds[i],
          displayOrder: Value(i),
        ),
      );
    }
  }

  /// Get goals for a tracker
  Future<List<TrackerGoal>> getTrackerGoals(String trackerId) {
    return (select(trackerGoals)..where((g) => g.trackerId.equals(trackerId))).get();
  }

  /// Set goals for a tracker (replaces existing)
  Future<void> setTrackerGoals(String trackerId, List<String> goalTypes) async {
    await (delete(trackerGoals)..where((g) => g.trackerId.equals(trackerId))).go();

    for (final goalType in goalTypes) {
      await into(trackerGoals).insert(
        TrackerGoalsCompanion.insert(
          id: '${trackerId}_$goalType',
          trackerId: trackerId,
          goalType: goalType,
        ),
      );
    }
  }

  /// Watch all active trackers (stream for reactive UI)
  Stream<List<Tracker>> watchActiveTrackers(String userId) {
    return (select(trackers)
          ..where((t) => t.userId.equals(userId) & t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  /// Get trackers pending sync
  Future<List<Tracker>> getPendingSyncTrackers() {
    return (select(trackers)..where((t) => t.syncStatus.equals('pending'))).get();
  }

  /// Mark tracker as synced
  Future<void> markAsSynced(String id) {
    return (update(trackers)..where((t) => t.id.equals(id))).write(
      const TrackersCompanion(syncStatus: Value('synced')),
    );
  }

  /// Get ALL trackers (for data recovery)
  Future<List<Tracker>> getAllTrackers() {
    return (select(trackers)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).get();
  }
}
