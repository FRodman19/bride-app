import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/supabase_config.dart';
import '../data/local/database.dart';
import '../data/local/daos/entry_dao.dart';
import '../data/local/daos/post_dao.dart';
import '../data/local/daos/tracker_dao.dart';

import 'connectivity_provider.dart';
import 'database_provider.dart';

/// Generate a deterministic UUID from entry_id and platform.
String _generateSpendId(String entryId, String platform) {
  final bytes = utf8.encode('$entryId:$platform');
  final hash = md5.convert(bytes);
  final hex = hash.toString();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
}

/// Sync status for UI display.
enum SyncStatus {
  idle,
  syncing,
  error,
}

/// Sync state with pending count and status.
class SyncState {
  final int pendingCount;
  final SyncStatus status;
  final String? lastError;
  final DateTime? lastSyncTime;
  final int syncProgress;
  final int syncTotal;

  const SyncState({
    this.pendingCount = 0,
    this.status = SyncStatus.idle,
    this.lastError,
    this.lastSyncTime,
    this.syncProgress = 0,
    this.syncTotal = 0,
  });

  /// Copy with optional fields. Use [clearError] to explicitly clear lastError.
  SyncState copyWith({
    int? pendingCount,
    SyncStatus? status,
    String? lastError,
    DateTime? lastSyncTime,
    int? syncProgress,
    int? syncTotal,
    bool clearError = false,
  }) {
    return SyncState(
      pendingCount: pendingCount ?? this.pendingCount,
      status: status ?? this.status,
      lastError: clearError ? null : (lastError ?? this.lastError),
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      syncProgress: syncProgress ?? this.syncProgress,
      syncTotal: syncTotal ?? this.syncTotal,
    );
  }

  bool get hasPending => pendingCount > 0;
  bool get isSyncingWithProgress => status == SyncStatus.syncing && syncTotal > 0;
  String get syncProgressText => '$syncProgress / $syncTotal';
}

/// Provider for sync state and operations.
final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref);
});

/// Provider for pending sync count (for UI indicators).
final pendingSyncCountProvider = StreamProvider<int>((ref) {
  final syncDao = ref.watch(syncDaoProvider);
  return syncDao.watchPendingCount();
});

/// Notifier for managing sync operations.
class SyncNotifier extends StateNotifier<SyncState> {
  final Ref _ref;
  bool _isProcessing = false;
  int _consecutiveFailures = 0;
  Timer? _retryTimer;

  /// Base delay for exponential backoff (1 second).
  static const _baseRetryDelay = Duration(seconds: 1);

  /// Maximum delay between retries (5 minutes).
  static const _maxRetryDelay = Duration(minutes: 5);

  /// Maximum consecutive failures before stopping auto-retry.
  static const _maxConsecutiveFailures = 5;

  SyncNotifier(this._ref) : super(const SyncState()) {
    _init();
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  void _init() {
    // Listen for connectivity changes
    _ref.listen<ConnectivityState>(connectivityProvider, (previous, next) {
      // When going from offline to online, trigger sync
      if (previous == ConnectivityState.offline &&
          next == ConnectivityState.online) {
        // Reset failure count when reconnecting
        _consecutiveFailures = 0;
        processPendingSync();
      }
    });

    // Load initial pending count
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    final syncDao = _ref.read(syncDaoProvider);
    final trackerDao = _ref.read(trackerDaoProvider);
    final queueCount = await syncDao.getPendingCount();
    final pendingTrackers = await trackerDao.getPendingSyncTrackers();
    final totalCount = queueCount + pendingTrackers.length;
    if (mounted) {
      state = state.copyWith(pendingCount: totalCount);
    }
  }

  /// Calculate delay using exponential backoff.
  Duration _getRetryDelay() {
    final delay = _baseRetryDelay * (1 << _consecutiveFailures);
    return delay > _maxRetryDelay ? _maxRetryDelay : delay;
  }

  /// Process all pending sync items.
  Future<void> processPendingSync() async {
    if (_isProcessing) return;

    final isOnline = _ref.read(connectivityProvider) == ConnectivityState.online;
    if (!isOnline) return;

    _isProcessing = true;
    if (mounted) {
      state = state.copyWith(
        status: SyncStatus.syncing,
        syncProgress: 0,
        syncTotal: 0,
      );
    }

    try {
      final syncDao = _ref.read(syncDaoProvider);
      final entryDao = _ref.read(entryDaoProvider);
      final trackerDao = _ref.read(trackerDaoProvider);

      // Get all pending items (queue items + pending trackers)
      final items = await syncDao.getPendingItems();
      final pendingTrackers = await trackerDao.getPendingSyncTrackers();

      final totalItems = items.length + pendingTrackers.length;

      // Update total count for progress tracking
      if (mounted && totalItems > 0) {
        state = state.copyWith(syncTotal: totalItems);
      }

      int processed = 0;
      int failed = 0;

      // Sync trackers first (they may be needed for entries)
      for (final tracker in pendingTrackers) {
        try {
          await _syncTracker(tracker, trackerDao);
          processed++;

          // Update progress
          if (mounted) {
            state = state.copyWith(syncProgress: processed);
          }
        } catch (e) {
          failed++;
        }
      }

      // Then sync queue items (entries, spends)
      for (final item in items) {
        try {
          await _processItem(item, entryDao);
          await syncDao.removeFromQueue(item.id);
          processed++;

          // Update progress
          if (mounted) {
            state = state.copyWith(syncProgress: processed);
          }
        } catch (e) {
          await syncDao.markRetry(item.id, e.toString());
          failed++;
        }
      }

      // Clean up failed items
      await syncDao.removeFailedItems();

      // Update pending count
      final remainingCount = await syncDao.getPendingCount();
      final remainingTrackers = await trackerDao.getPendingSyncTrackers();
      final totalRemaining = remainingCount + remainingTrackers.length;

      // Reset failure count on successful sync
      if (failed == 0) {
        _consecutiveFailures = 0;
      }

      if (mounted) {
        state = state.copyWith(
          pendingCount: totalRemaining,
          status: SyncStatus.idle,
          lastSyncTime: DateTime.now(),
          syncProgress: 0,
          syncTotal: 0,
          clearError: true,
        );
      }
    } catch (e) {
      _consecutiveFailures++;

      if (mounted) {
        state = state.copyWith(
          status: SyncStatus.error,
          lastError: e.toString(),
          syncProgress: 0,
          syncTotal: 0,
        );
      }

      // Schedule retry with exponential backoff if not max failures
      if (_consecutiveFailures < _maxConsecutiveFailures) {
        final delay = _getRetryDelay();
        _retryTimer?.cancel();
        _retryTimer = Timer(delay, () {
          if (mounted) {
            processPendingSync();
          }
        });
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processItem(SyncQueueData item, EntryDao entryDao) async {
    switch (item.targetTable) {
      case 'daily_entries':
        await _syncEntry(item, entryDao);
        break;
      case 'entry_platform_spends':
        await _syncSpend(item);
        break;
      case 'posts':
        await _syncPost(item);
        break;
      default:
        // Unknown table, skip
        break;
    }
  }

  Future<void> _syncEntry(SyncQueueData item, EntryDao entryDao) async {
    switch (item.operation) {
      case 'insert':
        final entry = await entryDao.getEntryById(item.recordId);
        if (entry != null) {
          final spends = await entryDao.getSpends(entry.id);
          final spendsMap = <String, int>{};
          for (final spend in spends) {
            spendsMap[spend.platform] = spend.amount;
          }

          await SupabaseConfig.client.from('daily_entries').insert({
            'id': entry.id,
            'tracker_id': entry.trackerId,
            'entry_date': entry.entryDate.toIso8601String().split('T')[0],
            'total_revenue': entry.totalRevenue,
            'total_dms_leads': entry.totalDmsLeads,
            'notes': entry.notes,
            'created_at': entry.createdAt.toIso8601String(),
            'updated_at': entry.updatedAt.toIso8601String(),
          });

          // Sync platform spends
          if (spendsMap.isNotEmpty) {
            final spendsData = spendsMap.entries
                .map((e) => {
                      'id': _generateSpendId(entry.id, e.key),
                      'entry_id': entry.id,
                      'platform': e.key,
                      'amount': e.value,
                    })
                .toList();
            await SupabaseConfig.client.from('entry_platform_spends').insert(spendsData);
          }

          // Update local sync status
          await entryDao.updateSyncStatus(entry.id, 'synced');
        }
        break;

      case 'update':
        final entry = await entryDao.getEntryById(item.recordId);
        if (entry != null) {
          final spends = await entryDao.getSpends(entry.id);
          final spendsMap = <String, int>{};
          for (final spend in spends) {
            spendsMap[spend.platform] = spend.amount;
          }

          // Conflict resolution: last-write-wins using atomic conditional update
          // Only update if server data is older or equal to local data (prevents race condition)
          final updateResult = await SupabaseConfig.client
              .from('daily_entries')
              .update({
                'entry_date': entry.entryDate.toIso8601String().split('T')[0],
                'total_revenue': entry.totalRevenue,
                'total_dms_leads': entry.totalDmsLeads,
                'notes': entry.notes,
                'updated_at': entry.updatedAt.toIso8601String(),
              })
              .eq('id', entry.id)
              .lte('updated_at', entry.updatedAt.toIso8601String())
              .select();

          if (updateResult.isEmpty) {
            // Server has newer data - conflict detected
            // Mark as synced (server wins) - in future could notify user or merge
            await entryDao.updateSyncStatus(entry.id, 'synced');
            break;
          }

          // Update was successful, now sync platform spends
          // Delete and re-insert spends
          await SupabaseConfig.client.from('entry_platform_spends').delete().eq('entry_id', entry.id);
          if (spendsMap.isNotEmpty) {
            final spendsData = spendsMap.entries
                .map((e) => {
                      'id': _generateSpendId(entry.id, e.key),
                      'entry_id': entry.id,
                      'platform': e.key,
                      'amount': e.value,
                    })
                .toList();
            await SupabaseConfig.client.from('entry_platform_spends').insert(spendsData);
          }

          // Update local sync status
          await entryDao.updateSyncStatus(entry.id, 'synced');
        }
        break;

      case 'delete':
        await SupabaseConfig.client.from('entry_platform_spends').delete().eq('entry_id', item.recordId);
        await SupabaseConfig.client.from('daily_entries').delete().eq('id', item.recordId);
        break;
    }
  }

  Future<void> _syncSpend(SyncQueueData item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;

    switch (item.operation) {
      case 'insert':
      case 'update':
        await SupabaseConfig.client.from('entry_platform_spends').upsert(payload);
        break;
      case 'delete':
        await SupabaseConfig.client.from('entry_platform_spends').delete().eq('id', item.recordId);
        break;
    }
  }

  /// Sync a post to Supabase.
  Future<void> _syncPost(SyncQueueData item) async {
    final postDao = _ref.read(postDaoProvider);

    switch (item.operation) {
      case 'insert':
        final post = await postDao.getPost(item.recordId);
        if (post != null) {
          await SupabaseConfig.client.from('posts').insert({
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
          await postDao.markAsSynced(post.id);
        }
        break;

      case 'update':
        final post = await postDao.getPost(item.recordId);
        if (post != null) {
          await SupabaseConfig.client
              .from('posts')
              .update({
                'title': post.title,
                'platform': post.platform,
                'url': post.url,
                'published_date': post.publishedDate?.toIso8601String(),
                'notes': post.notes,
                'updated_at': post.updatedAt.toIso8601String(),
              })
              .eq('id', post.id);
          await postDao.markAsSynced(post.id);
        }
        break;

      case 'delete':
        await SupabaseConfig.client.from('posts').delete().eq('id', item.recordId);
        break;
    }
  }

  /// Sync a tracker to Supabase.
  Future<void> _syncTracker(Tracker tracker, TrackerDao trackerDao) async {
    // Get tracker platforms and goals
    final platforms = await trackerDao.getTrackerPlatforms(tracker.id);
    final goals = await trackerDao.getTrackerGoals(tracker.id);

    // Upsert tracker (handles both insert and update)
    await SupabaseConfig.client.from('trackers').upsert({
      'id': tracker.id,
      'user_id': tracker.userId,
      'name': tracker.name,
      'start_date': tracker.startDate.toIso8601String().split('T')[0],
      'currency': tracker.currency,
      'revenue_target': tracker.revenueTarget,
      'engagement_target': tracker.engagementTarget,
      'setup_cost': tracker.setupCost,
      'growth_cost_monthly': tracker.growthCostMonthly,
      'notes': tracker.notes,
      'is_archived': tracker.isArchived,
      'created_at': tracker.createdAt.toIso8601String(),
      'updated_at': tracker.updatedAt.toIso8601String(),
    });

    // Sync platforms - delete and re-insert
    await SupabaseConfig.client
        .from('tracker_platforms')
        .delete()
        .eq('tracker_id', tracker.id);

    if (platforms.isNotEmpty) {
      final platformsData = platforms
          .map((p) => {
                'id': p.id,
                'tracker_id': p.trackerId,
                'platform': p.platform,
                'display_order': p.displayOrder,
              })
          .toList();
      await SupabaseConfig.client.from('tracker_platforms').insert(platformsData);
    }

    // Sync goals - delete and re-insert
    await SupabaseConfig.client
        .from('tracker_goals')
        .delete()
        .eq('tracker_id', tracker.id);

    if (goals.isNotEmpty) {
      final goalsData = goals
          .map((g) => {
                'id': g.id,
                'tracker_id': g.trackerId,
                'goal_type': g.goalType,
              })
          .toList();
      await SupabaseConfig.client.from('tracker_goals').insert(goalsData);
    }

    // Mark tracker as synced locally
    await trackerDao.markAsSynced(tracker.id);
  }
}
