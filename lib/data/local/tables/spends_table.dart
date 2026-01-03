import 'package:drift/drift.dart';

/// Entry platform spends table - Per-platform ad spend.
///
/// Tracks how much was spent on each platform for a daily entry.
class EntryPlatformSpends extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Foreign key to daily_entries
  TextColumn get entryId => text().named('entry_id')();

  /// Platform identifier (e.g., 'facebook', 'tiktok')
  TextColumn get platform => text()();

  /// Amount spent on this platform (stored as integer for CFA)
  IntColumn get amount => integer().withDefault(const Constant(0))();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  /// Last updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();

  /// Sync status: 'synced', 'pending', 'error'
  TextColumn get syncStatus => text().withDefault(const Constant('pending')).named('sync_status')();

  @override
  Set<Column> get primaryKey => {id};
}
