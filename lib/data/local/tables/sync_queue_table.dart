import 'package:drift/drift.dart';

/// Sync queue table - Pending changes to sync (local only).
///
/// Tracks all changes that need to be synced to Supabase.
/// This table is NOT mirrored to Supabase.
class SyncQueue extends Table {
  /// Auto-increment ID for ordering
  IntColumn get id => integer().autoIncrement()();

  /// Target table name (e.g., 'trackers', 'daily_entries')
  TextColumn get targetTable => text().named('target_table')();

  /// Record ID (UUID of the record to sync)
  TextColumn get recordId => text().named('record_id')();

  /// Operation type: 'insert', 'update', 'delete'
  TextColumn get operation => text()();

  /// JSON payload of the data to sync
  TextColumn get payload => text()();

  /// Number of retry attempts
  IntColumn get retryCount => integer().withDefault(const Constant(0)).named('retry_count')();

  /// Last error message if sync failed
  TextColumn get lastError => text().nullable().named('last_error')();

  /// Created timestamp (when change was made)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  /// Last attempt timestamp
  DateTimeColumn get lastAttemptAt => dateTime().nullable().named('last_attempt_at')();
}
