import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/database.dart';
import '../data/local/daos/tracker_dao.dart';
import '../data/local/daos/entry_dao.dart';
import '../data/local/daos/post_dao.dart';

/// Provider for the local SQLite database.
///
/// This is the single source of truth for all local data.
/// Initialize this early in the app lifecycle.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  // Dispose when no longer needed
  ref.onDispose(() {
    db.close();
  });

  return db;
});

/// Provider for the Tracker DAO.
final trackerDaoProvider = Provider<TrackerDao>((ref) {
  final db = ref.watch(databaseProvider);
  return TrackerDao(db);
});

/// Provider for the Entry DAO.
final entryDaoProvider = Provider<EntryDao>((ref) {
  final db = ref.watch(databaseProvider);
  return EntryDao(db);
});

/// Provider for the Post DAO.
final postDaoProvider = Provider<PostDao>((ref) {
  final db = ref.watch(databaseProvider);
  return PostDao(db);
});
