import 'package:drift/drift.dart';

/// Trackers table - Main campaign/project entity.
///
/// Mirrors Supabase trackers table for sync.
class Trackers extends Table {
  /// UUID primary key (works offline, syncs properly)
  TextColumn get id => text()();

  /// User ID from Supabase Auth
  TextColumn get userId => text().named('user_id')();

  /// Tracker name (min 3, max 50 characters)
  TextColumn get name => text().withLength(min: 3, max: 50)();

  /// Campaign start date
  DateTimeColumn get startDate => dateTime().named('start_date')();

  /// Currency code (default: XOF for Franc CFA)
  TextColumn get currency => text().withDefault(const Constant('XOF'))();

  /// Revenue target (optional)
  IntColumn get revenueTarget => integer().nullable().named('revenue_target')();

  /// Engagement target - DMs/Leads (optional)
  IntColumn get engagementTarget => integer().nullable().named('engagement_target')();

  /// Initial setup cost
  IntColumn get setupCost => integer().withDefault(const Constant(0)).named('setup_cost')();

  /// Monthly growth/maintenance cost
  IntColumn get growthCostMonthly => integer().withDefault(const Constant(0)).named('growth_cost_monthly')();

  /// Optional notes
  TextColumn get notes => text().nullable()();

  /// Whether tracker is archived (read-only mode)
  BoolColumn get isArchived => boolean().withDefault(const Constant(false)).named('is_archived')();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();

  /// Last updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();

  /// Sync status: 'synced', 'pending', 'error'
  TextColumn get syncStatus => text().withDefault(const Constant('pending')).named('sync_status')();

  /// Whether reminder notifications are enabled
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false)).named('reminder_enabled')();

  /// Reminder frequency: 'none', 'daily', 'weekly'
  TextColumn get reminderFrequency => text().withDefault(const Constant('none')).named('reminder_frequency')();

  /// Reminder time in HH:MM format (e.g., "09:00")
  TextColumn get reminderTime => text().nullable().named('reminder_time')();

  /// Day of week for weekly reminders (1=Monday, 7=Sunday)
  IntColumn get reminderDayOfWeek => integer().nullable().named('reminder_day_of_week')();

  @override
  Set<Column> get primaryKey => {id};
}
