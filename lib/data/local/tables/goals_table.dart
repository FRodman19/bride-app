import 'package:drift/drift.dart';

/// Tracker goals table - Goal tags/chips.
///
/// Stores goal types associated with a tracker.
class TrackerGoals extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Foreign key to trackers
  TextColumn get trackerId => text().named('tracker_id')();

  /// Goal type identifier (e.g., 'product_launch', 'lead_generation')
  TextColumn get goalType => text().named('goal_type')();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  /// Sync status: 'synced', 'pending', 'error'
  TextColumn get syncStatus => text().withDefault(const Constant('pending')).named('sync_status')();

  @override
  Set<Column> get primaryKey => {id};
}
