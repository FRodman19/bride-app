import 'package:drift/drift.dart';

/// Tracker platforms table - N:M resolver for tracker platforms.
///
/// Links trackers to their active advertising platforms.
class TrackerPlatforms extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Foreign key to trackers
  TextColumn get trackerId => text().named('tracker_id')();

  /// Platform identifier (e.g., 'facebook', 'tiktok')
  TextColumn get platform => text()();

  /// Display order for UI
  IntColumn get displayOrder => integer().withDefault(const Constant(0)).named('display_order')();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  /// Sync status: 'synced', 'pending', 'error'
  TextColumn get syncStatus => text().withDefault(const Constant('pending')).named('sync_status')();

  @override
  Set<Column> get primaryKey => {id};
}
