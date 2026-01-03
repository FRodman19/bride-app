import 'package:drift/drift.dart';

/// Posts table - Optional content references.
///
/// Tracks content/posts associated with a tracker.
/// Posts are reference-only, have no financial impact.
class Posts extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Foreign key to trackers
  TextColumn get trackerId => text().named('tracker_id')();

  /// Post title
  TextColumn get title => text()();

  /// Platform where post was published
  TextColumn get platform => text()();

  /// Optional URL to the post
  TextColumn get url => text().nullable()();

  /// Date post was published
  DateTimeColumn get publishedDate => dateTime().nullable().named('published_date')();

  /// Optional notes
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
