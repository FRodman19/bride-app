import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/trackers_table.dart';
import 'tables/entries_table.dart';
import 'tables/spends_table.dart';
import 'tables/platforms_table.dart';
import 'tables/posts_table.dart';
import 'tables/goals_table.dart';
import 'tables/sync_queue_table.dart';

part 'database.g.dart';

/// Local SQLite database for offline-first functionality.
///
/// Mirrors the Supabase schema for seamless sync.
/// All data is stored locally first, then synced to cloud when online.
@DriftDatabase(
  tables: [
    Trackers,
    DailyEntries,
    EntryPlatformSpends,
    TrackerPlatforms,
    Posts,
    TrackerGoals,
    SyncQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
      },
    );
  }
}

/// Opens a native SQLite database connection for mobile platforms.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'performance_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
