import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'database_backup.dart';
import 'tables/trackers_table.dart';
import 'tables/entries_table.dart';
import 'tables/spends_table.dart';
import 'tables/platforms_table.dart';
import 'tables/posts_table.dart';
import 'tables/goals_table.dart';

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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1 && to == 2) {
          // Migration v1 → v2: Add notification reminder columns to trackers
          try {
            final dbFolder = await getApplicationDocumentsDirectory();
            final dbPath = p.join(dbFolder.path, 'performance_tracker.sqlite');

            // Create backup before migration
            final backupPath = await DatabaseBackup.createBackup(dbPath);
            debugPrint('✅ Database backup created: $backupPath');

            // Add new columns for per-tracker notifications
            await m.addColumn(trackers, trackers.reminderEnabled);
            await m.addColumn(trackers, trackers.reminderFrequency);
            await m.addColumn(trackers, trackers.reminderTime);
            await m.addColumn(trackers, trackers.reminderDayOfWeek);

            // Clean old backups (keep last 3)
            await DatabaseBackup.cleanOldBackups(dbPath, keepCount: 3);
            debugPrint('✅ Migration v1 → v2 completed successfully');
          } catch (e) {
            debugPrint('❌ Migration failed: $e');

            // Attempt to restore from backup
            final dbFolder = await getApplicationDocumentsDirectory();
            final dbPath = p.join(dbFolder.path, 'performance_tracker.sqlite');

            try {
              await DatabaseBackup.restoreFromBackup(dbPath);
              debugPrint('✅ Database restored from backup');
            } catch (restoreError) {
              debugPrint('❌ Failed to restore backup: $restoreError');
            }

            rethrow;
          }
        }
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
