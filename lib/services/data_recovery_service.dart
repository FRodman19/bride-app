import 'package:flutter/foundation.dart';
import '../core/config/supabase_config.dart';
import '../data/local/database.dart';
import '../data/local/daos/tracker_dao.dart';
import '../data/local/daos/entry_dao.dart';
import '../data/local/daos/post_dao.dart';

/// Emergency data recovery service for frankwultof@gmail.com
///
/// This service uploads ALL local data to Supabase to prevent data loss.
/// It should be run ONCE to recover missing data from the user's device.
///
/// Usage:
/// ```dart
/// final service = DataRecoveryService();
/// final report = await service.recoverUserData();
/// print(report);
/// ```
class DataRecoveryService {
  final AppDatabase _db;
  late final TrackerDao trackerDao;
  late final EntryDao entryDao;
  late final PostDao postDao;
  final supabase = SupabaseConfig.client;

  DataRecoveryService(this._db) {
    trackerDao = TrackerDao(_db);
    entryDao = EntryDao(_db);
    postDao = PostDao(_db);
  }

  /// Recovers all local data and uploads to Supabase
  /// Returns a detailed report of the recovery operation
  Future<DataRecoveryReport> recoverUserData() async {
    final report = DataRecoveryReport();

    try {
      debugPrint('🚨 Starting emergency data recovery...');
      report.startTime = DateTime.now();

      // Step 1: Verify user is authenticated
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated. Please log in first.');
      }

      report.userId = currentUser.id;
      report.userEmail = currentUser.email ?? 'unknown';
      debugPrint('✅ User authenticated: ${report.userEmail}');

      // Step 2: Recover Trackers
      await _recoverTrackers(report);

      // Step 3: Recover Entries
      await _recoverEntries(report);

      // Step 4: Recover Posts
      await _recoverPosts(report);

      report.endTime = DateTime.now();
      report.success = true;

      debugPrint('✅ Data recovery completed successfully!');
      debugPrint(report.toString());

      return report;
    } catch (e, stackTrace) {
      report.endTime = DateTime.now();
      report.success = false;
      report.error = e.toString();
      report.stackTrace = stackTrace.toString();

      debugPrint('❌ Data recovery failed: $e');
      debugPrint(stackTrace.toString());

      return report;
    }
  }

  /// Recovers all trackers
  Future<void> _recoverTrackers(DataRecoveryReport report) async {
    debugPrint('📊 Recovering trackers...');

    // Get all local trackers
    final localTrackers = await trackerDao.getAllTrackers();
    report.localTrackerCount = localTrackers.length;
    debugPrint('Found ${localTrackers.length} local trackers');

    // Check which trackers exist in Supabase
    final supabaseTrackers = await supabase
        .from('trackers')
        .select('id')
        .eq('user_id', supabase.auth.currentUser!.id);

    final supabaseTrackerIds = (supabaseTrackers as List)
        .map((t) => t['id'] as String)
        .toSet();

    report.supabaseTrackerCount = supabaseTrackerIds.length;
    debugPrint('Found ${supabaseTrackerIds.length} trackers in Supabase');

    // Upload missing trackers
    for (final tracker in localTrackers) {
      if (!supabaseTrackerIds.contains(tracker.id)) {
        try {
          await supabase.from('trackers').insert({
            'id': tracker.id,
            'user_id': supabase.auth.currentUser!.id,
            'name': tracker.name,
            'start_date': tracker.startDate.toIso8601String(),
            'currency': tracker.currency,
            'revenue_target': tracker.revenueTarget,
            'engagement_target': tracker.engagementTarget,
            'setup_cost': tracker.setupCost,
            'growth_cost_monthly': tracker.growthCostMonthly,
            'notes': tracker.notes,
            'is_archived': tracker.isArchived,
            'reminder_enabled': tracker.reminderEnabled,
            'reminder_frequency': tracker.reminderFrequency,
            'reminder_time': tracker.reminderTime,
            'reminder_day_of_week': tracker.reminderDayOfWeek,
            'created_at': tracker.createdAt.toIso8601String(),
            'updated_at': tracker.updatedAt.toIso8601String(),
          });

          report.trackersUploaded++;
          debugPrint('✅ Uploaded tracker: ${tracker.name}');
        } catch (e) {
          report.trackerErrors.add('Failed to upload tracker ${tracker.name}: $e');
          debugPrint('❌ Failed to upload tracker ${tracker.name}: $e');
        }
      }
    }

    debugPrint('📊 Trackers: ${report.trackersUploaded} uploaded, ${report.trackerErrors.length} errors');
  }

  /// Recovers all entries
  Future<void> _recoverEntries(DataRecoveryReport report) async {
    debugPrint('📝 Recovering entries...');

    // Get all local entries
    final localEntries = await entryDao.getAllEntries();
    report.localEntryCount = localEntries.length;
    debugPrint('Found ${localEntries.length} local entries');

    // Check which entries exist in Supabase
    // Note: daily_entries doesn't have user_id, user is identified via tracker_id
    final supabaseEntries = await supabase
        .from('daily_entries')
        .select('id');

    final supabaseEntryIds = (supabaseEntries as List)
        .map((e) => e['id'] as String)
        .toSet();

    report.supabaseEntryCount = supabaseEntryIds.length;
    debugPrint('Found ${supabaseEntryIds.length} entries in Supabase');

    // Upload missing entries
    for (final entry in localEntries) {
      if (!supabaseEntryIds.contains(entry.id)) {
        try {
          await supabase.from('daily_entries').insert({
            'id': entry.id,
            'tracker_id': entry.trackerId,
            'entry_date': entry.entryDate.toIso8601String().split('T')[0], // Date only (no time)
            'total_revenue': entry.totalRevenue,
            'total_dms_leads': entry.totalDmsLeads,
            'notes': entry.notes,
            'created_at': entry.createdAt.toIso8601String(),
            'updated_at': entry.updatedAt.toIso8601String(),
          });

          report.entriesUploaded++;

          // Log entries after 06/01/2026 specifically
          if (entry.entryDate.isAfter(DateTime(2026, 1, 6))) {
            report.entriesAfterJan6++;
            debugPrint('✅ Uploaded POST-JAN6 entry: ${entry.entryDate} (Revenue: ${entry.totalRevenue})');
          }
        } catch (e) {
          report.entryErrors.add('Failed to upload entry ${entry.id}: $e');
          debugPrint('❌ Failed to upload entry ${entry.id}: $e');
        }
      }
    }

    debugPrint('📝 Entries: ${report.entriesUploaded} uploaded (${report.entriesAfterJan6} after Jan 6), ${report.entryErrors.length} errors');
  }

  /// Recovers all posts
  Future<void> _recoverPosts(DataRecoveryReport report) async {
    debugPrint('📱 Recovering posts...');

    // Get all local posts
    final localPosts = await postDao.getAllPosts();
    report.localPostCount = localPosts.length;
    debugPrint('Found ${localPosts.length} local posts');

    // Check which posts exist in Supabase
    // Note: posts table doesn't have user_id, user is identified via tracker_id
    final supabasePosts = await supabase
        .from('posts')
        .select('id');

    final supabasePostIds = (supabasePosts as List)
        .map((p) => p['id'] as String)
        .toSet();

    report.supabasePostCount = supabasePostIds.length;
    debugPrint('Found ${supabasePostIds.length} posts in Supabase');

    // Upload missing posts
    for (final post in localPosts) {
      if (!supabasePostIds.contains(post.id)) {
        try {
          await supabase.from('posts').insert({
            'id': post.id,
            'tracker_id': post.trackerId,
            'title': post.title,
            'platform': post.platform,
            'url': post.url,
            'published_date': post.publishedDate?.toIso8601String(),
            'notes': post.notes,
            'created_at': post.createdAt.toIso8601String(),
            'updated_at': post.updatedAt.toIso8601String(),
          });

          report.postsUploaded++;
          debugPrint('✅ Uploaded post: ${post.id}');
        } catch (e) {
          report.postErrors.add('Failed to upload post ${post.id}: $e');
          debugPrint('❌ Failed to upload post ${post.id}: $e');
        }
      }
    }

    debugPrint('📱 Posts: ${report.postsUploaded} uploaded, ${report.postErrors.length} errors');
  }

}

/// Report detailing the data recovery operation
class DataRecoveryReport {
  // User info
  String userId = '';
  String userEmail = '';

  // Timing
  DateTime? startTime;
  DateTime? endTime;

  // Success status
  bool success = false;
  String? error;
  String? stackTrace;

  // Trackers
  int localTrackerCount = 0;
  int supabaseTrackerCount = 0;
  int trackersUploaded = 0;
  List<String> trackerErrors = [];

  // Entries
  int localEntryCount = 0;
  int supabaseEntryCount = 0;
  int entriesUploaded = 0;
  int entriesAfterJan6 = 0; // Special tracking for entries after 06/01/2026
  List<String> entryErrors = [];

  // Posts
  int localPostCount = 0;
  int supabasePostCount = 0;
  int postsUploaded = 0;
  List<String> postErrors = [];

  /// Get total items uploaded
  int get totalUploaded =>
      trackersUploaded + entriesUploaded + postsUploaded;

  /// Get total errors
  int get totalErrors =>
      trackerErrors.length +
      entryErrors.length +
      postErrors.length;

  /// Get duration
  Duration? get duration {
    if (startTime == null || endTime == null) return null;
    return endTime!.difference(startTime!);
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('═══════════════════════════════════════════════════════');
    buffer.writeln('           DATA RECOVERY REPORT');
    buffer.writeln('═══════════════════════════════════════════════════════');
    buffer.writeln('User: $userEmail ($userId)');
    buffer.writeln('Status: ${success ? "✅ SUCCESS" : "❌ FAILED"}');
    if (duration != null) {
      buffer.writeln('Duration: ${duration!.inSeconds} seconds');
    }
    buffer.writeln('');

    buffer.writeln('─────────────────────────────────────────────────────');
    buffer.writeln('TRACKERS:');
    buffer.writeln('  Local:     $localTrackerCount');
    buffer.writeln('  Supabase:  $supabaseTrackerCount');
    buffer.writeln('  Uploaded:  $trackersUploaded');
    buffer.writeln('  Errors:    ${trackerErrors.length}');

    buffer.writeln('');
    buffer.writeln('ENTRIES:');
    buffer.writeln('  Local:         $localEntryCount');
    buffer.writeln('  Supabase:      $supabaseEntryCount');
    buffer.writeln('  Uploaded:      $entriesUploaded');
    buffer.writeln('  After Jan 6:   $entriesAfterJan6 ⚠️ (This was the issue!)');
    buffer.writeln('  Errors:        ${entryErrors.length}');

    buffer.writeln('');
    buffer.writeln('POSTS:');
    buffer.writeln('  Local:     $localPostCount');
    buffer.writeln('  Supabase:  $supabasePostCount');
    buffer.writeln('  Uploaded:  $postsUploaded');
    buffer.writeln('  Errors:    ${postErrors.length}');

    buffer.writeln('─────────────────────────────────────────────────────');
    buffer.writeln('SUMMARY:');
    buffer.writeln('  Total Uploaded: $totalUploaded items');
    buffer.writeln('  Total Errors:   $totalErrors items');

    if (totalErrors > 0) {
      buffer.writeln('');
      buffer.writeln('ERRORS:');
      for (final error in trackerErrors) {
        buffer.writeln('  - $error');
      }
      for (final error in entryErrors) {
        buffer.writeln('  - $error');
      }
      for (final error in postErrors) {
        buffer.writeln('  - $error');
      }
    }

    if (!success && error != null) {
      buffer.writeln('');
      buffer.writeln('FATAL ERROR:');
      buffer.writeln(error);
    }

    buffer.writeln('═══════════════════════════════════════════════════════');

    return buffer.toString();
  }
}
