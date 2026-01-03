import 'package:drift/drift.dart';

/// Daily entries table - Daily performance logs.
///
/// Stores revenue, DMs/leads for each day.
/// Platform spends are in separate table (EntryPlatformSpends).
class DailyEntries extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Foreign key to trackers
  TextColumn get trackerId => text().named('tracker_id')();

  /// Entry date (one per day per tracker)
  DateTimeColumn get entryDate => dateTime().named('entry_date')();

  /// Total revenue for the day (stored as integer for CFA - no decimals)
  IntColumn get totalRevenue => integer().named('total_revenue')();

  /// Total DMs/Leads received
  IntColumn get totalDmsLeads => integer().withDefault(const Constant(0)).named('total_dms_leads')();

  /// Optional notes for the day
  TextColumn get notes => text().nullable()();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  /// Last updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();

  /// Sync status: 'synced', 'pending', 'error'
  TextColumn get syncStatus => text().withDefault(const Constant('pending')).named('sync_status')();

  @override
  Set<Column> get primaryKey => {id};
}
