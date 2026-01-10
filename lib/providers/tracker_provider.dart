import 'dart:convert';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/models/tracker.dart' as domain;
import '../data/local/database.dart';
import 'auth_provider.dart';
import 'connectivity_provider.dart';
import 'database_provider.dart';

/// State for trackers list.
sealed class TrackersState {
  const TrackersState();
}

class TrackersLoading extends TrackersState {
  const TrackersLoading();
}

class TrackersLoaded extends TrackersState {
  final List<domain.Tracker> trackers;
  final int pendingSyncCount;

  const TrackersLoaded(this.trackers, {this.pendingSyncCount = 0});

  List<domain.Tracker> get activeTrackers =>
      trackers.where((t) => !t.isArchived).toList();
  List<domain.Tracker> get archivedTrackers =>
      trackers.where((t) => t.isArchived).toList();
}

class TrackersError extends TrackersState {
  final String message;
  const TrackersError(this.message);
}

/// Provider for trackers with offline-first architecture.
final trackersProvider =
    StateNotifierProvider<TrackersNotifier, TrackersState>((ref) {
  return TrackersNotifier(ref);
});

/// Convenience provider for active trackers only.
final activeTrackersProvider = Provider<List<domain.Tracker>>((ref) {
  final state = ref.watch(trackersProvider);
  if (state is TrackersLoaded) {
    return state.activeTrackers;
  }
  return [];
});

/// Convenience provider to check if user can create more trackers.
final canCreateTrackerProvider = Provider<bool>((ref) {
  final trackers = ref.watch(activeTrackersProvider);
  return trackers.length < 20; // Max 20 active trackers
});

/// Provider for a single tracker by ID.
final trackerByIdProvider =
    Provider.family<domain.Tracker?, String>((ref, id) {
  final state = ref.watch(trackersProvider);
  if (state is TrackersLoaded) {
    try {
      return state.trackers.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
  return null;
});

/// Notifier for managing trackers with offline-first support.
class TrackersNotifier extends StateNotifier<TrackersState> {
  final Ref _ref;

  TrackersNotifier(this._ref) : super(const TrackersLoading()) {
    _init();
  }

  void _init() {
    // Watch auth state changes
    _ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        loadTrackers();
      } else if (next is AuthUnauthenticated) {
        if (mounted) state = const TrackersLoaded([]);
      }
    }, fireImmediately: true);

    // Watch connectivity changes to trigger sync
    _ref.listen<ConnectivityState>(connectivityProvider, (previous, next) {
      if (previous == ConnectivityState.offline &&
          next == ConnectivityState.online) {
        _syncPendingChanges();
      }
    });
  }

  bool get _isOnline =>
      _ref.read(connectivityProvider) == ConnectivityState.online;

  String? get _userId {
    final authState = _ref.read(authProvider);
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return null;
  }

  /// Load all trackers for the current user.
  /// Uses local-first: loads from local DB, then syncs with remote if online.
  Future<void> loadTrackers() async {
    final userId = _userId;
    if (userId == null) {
      if (mounted) state = const TrackersLoaded([]);
      return;
    }

    if (mounted) state = const TrackersLoading();

    try {
      final trackerDao = _ref.read(trackerDaoProvider);
      final syncDao = _ref.read(syncDaoProvider);

      // Load from local database first (fast)
      final localTrackers = await trackerDao.getActiveTrackers(userId);
      final archivedTrackers = await trackerDao.getArchivedTrackers(userId);
      final pendingCount = await syncDao.getPendingCount();

      // Convert Drift models to domain models
      final allTrackers = [...localTrackers, ...archivedTrackers];
      final domainTrackers = await Future.wait(
        allTrackers.map((t) => _convertToDomainTracker(t)),
      );

      if (mounted) {
        state = TrackersLoaded(domainTrackers, pendingSyncCount: pendingCount);
      }

      // Sync with remote if online
      if (_isOnline) {
        await _syncFromRemote(userId);
      }
    } catch (e) {
      if (mounted) state = TrackersError('Failed to load trackers: $e');
    }
  }

  /// Convert Drift Tracker to domain Tracker.
  Future<domain.Tracker> _convertToDomainTracker(Tracker driftTracker) async {
    final trackerDao = _ref.read(trackerDaoProvider);

    // Get platforms and goals
    final platforms = await trackerDao.getTrackerPlatforms(driftTracker.id);
    final goals = await trackerDao.getTrackerGoals(driftTracker.id);

    // TODO: Calculate totals from entries (for now, return 0s)
    return domain.Tracker(
      id: driftTracker.id,
      userId: driftTracker.userId,
      name: driftTracker.name,
      startDate: driftTracker.startDate,
      currency: driftTracker.currency,
      revenueTarget: driftTracker.revenueTarget?.toDouble(),
      engagementTarget: driftTracker.engagementTarget,
      setupCost: driftTracker.setupCost.toDouble(),
      growthCostMonthly: driftTracker.growthCostMonthly.toDouble(),
      notes: driftTracker.notes,
      isArchived: driftTracker.isArchived,
      createdAt: driftTracker.createdAt,
      updatedAt: driftTracker.updatedAt,
      platforms: platforms.map((p) => p.platform).toList(),
      goalTypes: goals.map((g) => g.goalType).toList(),
      totalRevenue: 0,
      totalSpend: 0,
      totalProfit: 0,
      entryCount: 0,
    );
  }

  /// Sync trackers from remote Supabase to local.
  Future<void> _syncFromRemote(String userId) async {
    try {
      // Fetch trackers with full entry data including platform spends and posts
      final response = await SupabaseConfig.client
          .from('trackers')
          .select('''
            *,
            tracker_platforms(platform, display_order),
            tracker_goals(goal_type),
            daily_entries(
              id,
              entry_date,
              total_revenue,
              total_dms_leads,
              notes,
              created_at,
              updated_at,
              entry_platform_spends(id, platform, amount)
            ),
            posts(
              id,
              title,
              platform,
              url,
              published_date,
              notes,
              created_at,
              updated_at
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final trackerDao = _ref.read(trackerDaoProvider);
      final entryDao = _ref.read(entryDaoProvider);

      final domainTrackers = <domain.Tracker>[];

      for (final data in (response as List)) {
        final trackerId = data['id'] as String;

        // Extract platforms
        final platforms = (data['tracker_platforms'] as List?)
                ?.map((p) => p['platform'] as String)
                .toList() ??
            [];

        // Extract goals
        final goalTypes = (data['tracker_goals'] as List?)
                ?.map((g) => g['goal_type'] as String)
                .toList() ??
            [];

        // Calculate totals from entries
        double totalRevenue = 0;
        double totalSpend = 0;
        int entryCount = 0;

        final entries = data['daily_entries'] as List? ?? [];
        for (final entryData in entries) {
          entryCount++;
          final entryRevenue = (entryData['total_revenue'] as num?)?.toInt() ?? 0;
          totalRevenue += entryRevenue;

          // Sync entry to local database
          final entryId = entryData['id'] as String;
          final entryCompanion = DailyEntriesCompanion(
            id: Value(entryId),
            trackerId: Value(trackerId),
            entryDate: Value(DateTime.parse(entryData['entry_date'] as String)),
            totalRevenue: Value(entryRevenue),
            totalDmsLeads: Value((entryData['total_dms_leads'] as num?)?.toInt() ?? 0),
            notes: Value(entryData['notes'] as String?),
            createdAt: Value(DateTime.parse(entryData['created_at'] as String)),
            updatedAt: Value(DateTime.parse(entryData['updated_at'] as String)),
            syncStatus: const Value('synced'),
          );
          await entryDao.insertEntry(entryCompanion);

          // Sync platform spends to local database
          final spends = entryData['entry_platform_spends'] as List? ?? [];
          final spendsMap = <String, int>{};
          for (final spend in spends) {
            final amount = (spend['amount'] as num?)?.toInt() ?? 0;
            final platform = spend['platform'] as String;
            spendsMap[platform] = amount;
            totalSpend += amount;
          }
          // Save spends to local database
          await entryDao.setSpends(entryId, spendsMap);
        }

        // Sync posts to local database
        final posts = data['posts'] as List? ?? [];
        final postDao = _ref.read(postDaoProvider);
        for (final postData in posts) {
          final postCompanion = PostsCompanion(
            id: Value(postData['id'] as String),
            trackerId: Value(trackerId),
            title: Value(postData['title'] as String),
            platform: Value(postData['platform'] as String),
            url: Value(postData['url'] as String?),
            publishedDate: Value(postData['published_date'] != null
                ? DateTime.parse(postData['published_date'] as String)
                : null),
            notes: Value(postData['notes'] as String?),
            createdAt: Value(DateTime.parse(postData['created_at'] as String)),
            updatedAt: Value(DateTime.parse(postData['updated_at'] as String)),
            syncStatus: const Value('synced'),
          );
          await postDao.insertPost(postCompanion);
        }

        // Upsert tracker to local database
        final trackerCompanion = TrackersCompanion(
          id: Value(trackerId),
          userId: Value(data['user_id'] as String),
          name: Value(data['name'] as String),
          startDate: Value(DateTime.parse(data['start_date'] as String)),
          currency: Value(data['currency'] as String? ?? 'XOF'),
          revenueTarget: Value(data['revenue_target'] as int?),
          engagementTarget: Value(data['engagement_target'] as int?),
          setupCost: Value(data['setup_cost'] as int? ?? 0),
          growthCostMonthly: Value(data['growth_cost_monthly'] as int? ?? 0),
          notes: Value(data['notes'] as String?),
          isArchived: Value(data['is_archived'] as bool? ?? false),
          createdAt: Value(DateTime.parse(data['created_at'] as String)),
          updatedAt: Value(DateTime.parse(data['updated_at'] as String)),
          syncStatus: const Value('synced'),
        );

        await trackerDao.insertTracker(trackerCompanion);
        await trackerDao.setTrackerPlatforms(trackerId, platforms);
        await trackerDao.setTrackerGoals(trackerId, goalTypes);

        // Create domain tracker
        domainTrackers.add(domain.Tracker.fromMap(
          {
            'id': data['id'],
            'user_id': data['user_id'],
            'name': data['name'],
            'start_date': data['start_date'],
            'currency': data['currency'] ?? 'XOF',
            'revenue_target': data['revenue_target'],
            'engagement_target': data['engagement_target'],
            'setup_cost': data['setup_cost'] ?? 0,
            'growth_cost_monthly': data['growth_cost_monthly'] ?? 0,
            'notes': data['notes'],
            'is_archived': data['is_archived'] ?? false,
            'created_at': data['created_at'],
            'updated_at': data['updated_at'],
          },
          platforms: platforms,
          goalTypes: goalTypes,
          totalRevenue: totalRevenue,
          totalSpend: totalSpend,
          entryCount: entryCount,
        ));
      }

      if (mounted) {
        state = TrackersLoaded(domainTrackers);
      }
    } catch (e) {
      // Remote sync failed, but we still have local data
      // Log error but don't change state
    }
  }

  /// Create a new tracker.
  /// Saves to local first, then syncs to remote if online.
  Future<TrackerResult> createTracker({
    required String name,
    required DateTime startDate,
    String currency = 'XOF',
    double? revenueTarget,
    int? engagementTarget,
    double setupCost = 0,
    double growthCostMonthly = 0,
    String? notes,
    List<String> platforms = const ['Facebook', 'TikTok'],
    List<String> goalTypes = const [],
  }) async {
    final userId = _userId;
    if (userId == null) {
      return TrackerResult.error('Not authenticated');
    }

    // Check limit
    if (state is TrackersLoaded) {
      final active = (state as TrackersLoaded).activeTrackers;
      if (active.length >= 20) {
        return TrackerResult.error(
            'You have reached the maximum of 20 active trackers');
      }
    }

    try {
      // Create domain tracker
      final tracker = domain.Tracker.create(
        userId: userId,
        name: name,
        startDate: startDate,
        currency: currency,
        revenueTarget: revenueTarget,
        engagementTarget: engagementTarget,
        setupCost: setupCost,
        growthCostMonthly: growthCostMonthly,
        notes: notes,
        platforms: platforms,
        goalTypes: goalTypes,
      );

      final trackerDao = _ref.read(trackerDaoProvider);
      final syncDao = _ref.read(syncDaoProvider);

      // Save to local database first
      final trackerCompanion = TrackersCompanion(
        id: Value(tracker.id),
        userId: Value(tracker.userId),
        name: Value(tracker.name),
        startDate: Value(tracker.startDate),
        currency: Value(tracker.currency),
        revenueTarget: Value(tracker.revenueTarget?.round()),
        engagementTarget: Value(tracker.engagementTarget),
        setupCost: Value(tracker.setupCost.round()),
        growthCostMonthly: Value(tracker.growthCostMonthly.round()),
        notes: Value(tracker.notes),
        isArchived: const Value(false),
        createdAt: Value(tracker.createdAt),
        updatedAt: Value(tracker.updatedAt),
        syncStatus: Value(_isOnline ? 'synced' : 'pending'),
      );

      await trackerDao.insertTracker(trackerCompanion);
      await trackerDao.setTrackerPlatforms(tracker.id, platforms);
      await trackerDao.setTrackerGoals(tracker.id, goalTypes);

      // Try to sync to remote if online
      if (_isOnline) {
        try {
          await SupabaseConfig.client
              .from('trackers')
              .insert(tracker.toMap());

          // Insert platforms
          if (platforms.isNotEmpty) {
            final platformsData = platforms
                .asMap()
                .entries
                .map((e) => {
                      'tracker_id': tracker.id,
                      'platform': e.value,
                      'display_order': e.key,
                    })
                .toList();
            await SupabaseConfig.client
                .from('tracker_platforms')
                .insert(platformsData);
          }

          // Insert goals
          if (goalTypes.isNotEmpty) {
            final goalsData = goalTypes
                .map((g) => {
                      'tracker_id': tracker.id,
                      'goal_type': g,
                    })
                .toList();
            await SupabaseConfig.client
                .from('tracker_goals')
                .insert(goalsData);
          }

          // Mark as synced
          await trackerDao.markAsSynced(tracker.id);
        } catch (e) {
          // Remote failed, queue for later sync
          await syncDao.addToQueue(
            targetTable: 'trackers',
            recordId: tracker.id,
            operation: 'insert',
            payload: jsonEncode(tracker.toMap()),
          );
        }
      } else {
        // Offline, queue for later sync
        await syncDao.addToQueue(
          targetTable: 'trackers',
          recordId: tracker.id,
          operation: 'insert',
          payload: jsonEncode(tracker.toMap()),
        );
      }

      // Reload trackers from local
      await loadTrackers();

      return TrackerResult.success(tracker);
    } catch (e) {
      return TrackerResult.error('Failed to create tracker: $e');
    }
  }

  /// Update an existing tracker.
  Future<TrackerResult> updateTracker(domain.Tracker tracker) async {
    if (_userId == null) {
      return TrackerResult.error('Not authenticated');
    }

    try {
      final trackerDao = _ref.read(trackerDaoProvider);
      final syncDao = _ref.read(syncDaoProvider);
      final updatedTracker = tracker.copyWith(updatedAt: DateTime.now());

      // Update local first
      final trackerCompanion = TrackersCompanion(
        id: Value(updatedTracker.id),
        userId: Value(updatedTracker.userId),
        name: Value(updatedTracker.name),
        startDate: Value(updatedTracker.startDate),
        currency: Value(updatedTracker.currency),
        revenueTarget: Value(updatedTracker.revenueTarget?.round()),
        engagementTarget: Value(updatedTracker.engagementTarget),
        setupCost: Value(updatedTracker.setupCost.round()),
        growthCostMonthly: Value(updatedTracker.growthCostMonthly.round()),
        notes: Value(updatedTracker.notes),
        isArchived: Value(updatedTracker.isArchived),
        createdAt: Value(updatedTracker.createdAt),
        updatedAt: Value(updatedTracker.updatedAt),
        syncStatus: Value(_isOnline ? 'synced' : 'pending'),
      );

      await trackerDao.updateTracker(trackerCompanion);

      // Update platforms and goals in local DB
      await trackerDao.setTrackerPlatforms(updatedTracker.id, updatedTracker.platforms);
      await trackerDao.setTrackerGoals(updatedTracker.id, updatedTracker.goalTypes);

      // Sync to remote if online
      if (_isOnline) {
        try {
          await SupabaseConfig.client
              .from('trackers')
              .update(updatedTracker.toMap())
              .eq('id', tracker.id);

          // Update platforms in Supabase - delete existing and insert new
          await SupabaseConfig.client
              .from('tracker_platforms')
              .delete()
              .eq('tracker_id', tracker.id);
          if (updatedTracker.platforms.isNotEmpty) {
            final platformsData = updatedTracker.platforms
                .asMap()
                .entries
                .map((e) => {
                      'tracker_id': tracker.id,
                      'platform': e.value,
                      'display_order': e.key,
                    })
                .toList();
            await SupabaseConfig.client
                .from('tracker_platforms')
                .insert(platformsData);
          }

          // Update goals in Supabase - delete existing and insert new
          await SupabaseConfig.client
              .from('tracker_goals')
              .delete()
              .eq('tracker_id', tracker.id);
          if (updatedTracker.goalTypes.isNotEmpty) {
            final goalsData = updatedTracker.goalTypes
                .map((g) => {
                      'tracker_id': tracker.id,
                      'goal_type': g,
                    })
                .toList();
            await SupabaseConfig.client
                .from('tracker_goals')
                .insert(goalsData);
          }

          await trackerDao.markAsSynced(tracker.id);
        } catch (e) {
          await syncDao.addToQueue(
            targetTable: 'trackers',
            recordId: tracker.id,
            operation: 'update',
            payload: jsonEncode(updatedTracker.toMap()),
          );
        }
      } else {
        await syncDao.addToQueue(
          targetTable: 'trackers',
          recordId: tracker.id,
          operation: 'update',
          payload: jsonEncode(updatedTracker.toMap()),
        );
      }

      await loadTrackers();
      return TrackerResult.success(updatedTracker);
    } catch (e) {
      return TrackerResult.error('Failed to update tracker: $e');
    }
  }

  /// Archive a tracker.
  Future<TrackerResult> archiveTracker(String trackerId) async {
    final currentState = state;
    if (currentState is! TrackersLoaded) {
      return TrackerResult.error('Trackers not loaded');
    }

    try {
      final tracker =
          currentState.trackers.firstWhere((t) => t.id == trackerId);
      return updateTracker(tracker.copyWith(isArchived: true));
    } catch (e) {
      return TrackerResult.error('Tracker not found');
    }
  }

  /// Restore a tracker from archive.
  Future<TrackerResult> restoreTracker(String trackerId) async {
    final currentState = state;
    if (currentState is! TrackersLoaded) {
      return TrackerResult.error('Trackers not loaded');
    }

    // Check limit before restoring
    if (currentState.activeTrackers.length >= 20) {
      return TrackerResult.error(
          'Cannot restore: You already have 20 active trackers');
    }

    try {
      final tracker =
          currentState.trackers.firstWhere((t) => t.id == trackerId);
      return updateTracker(tracker.copyWith(isArchived: false));
    } catch (e) {
      return TrackerResult.error('Tracker not found');
    }
  }

  /// Delete a tracker permanently.
  Future<TrackerResult> deleteTracker(String trackerId) async {
    if (_userId == null) {
      return TrackerResult.error('Not authenticated');
    }

    try {
      final trackerDao = _ref.read(trackerDaoProvider);
      final syncDao = _ref.read(syncDaoProvider);

      // Delete locally first
      await trackerDao.deleteTracker(trackerId);

      // Sync to remote if online
      if (_isOnline) {
        try {
          await SupabaseConfig.client
              .from('trackers')
              .delete()
              .eq('id', trackerId);
        } catch (e) {
          await syncDao.addToQueue(
            targetTable: 'trackers',
            recordId: trackerId,
            operation: 'delete',
            payload: '{}',
          );
        }
      } else {
        await syncDao.addToQueue(
          targetTable: 'trackers',
          recordId: trackerId,
          operation: 'delete',
          payload: '{}',
        );
      }

      // Clear any pending sync items for this record
      await syncDao.clearForRecord(trackerId);

      await loadTrackers();
      return TrackerResult.success(null);
    } catch (e) {
      return TrackerResult.error('Failed to delete tracker: $e');
    }
  }

  /// Sync all pending changes to remote.
  Future<void> _syncPendingChanges() async {
    if (!_isOnline) return;

    try {
      final syncDao = _ref.read(syncDaoProvider);
      final pendingItems = await syncDao.getPendingItems();

      for (final item in pendingItems) {
        try {
          final payload = jsonDecode(item.payload) as Map<String, dynamic>;

          switch (item.operation) {
            case 'insert':
              await SupabaseConfig.client
                  .from(item.targetTable)
                  .insert(payload);
              break;
            case 'update':
              await SupabaseConfig.client
                  .from(item.targetTable)
                  .update(payload)
                  .eq('id', item.recordId);
              break;
            case 'delete':
              await SupabaseConfig.client
                  .from(item.targetTable)
                  .delete()
                  .eq('id', item.recordId);
              break;
          }

          // Success - remove from queue
          await syncDao.removeFromQueue(item.id);
        } catch (e) {
          // Failed - mark retry
          await syncDao.markRetry(item.id, e.toString());
        }
      }

      // Reload to update pending count
      await loadTrackers();
    } catch (e) {
      // Sync failed, will retry on next connectivity change
    }
  }

  /// Force sync now (user initiated).
  Future<void> syncNow() async {
    if (_isOnline) {
      await _syncPendingChanges();
      if (_userId != null) {
        await _syncFromRemote(_userId!);
      }
    }
  }
}

/// Result of a tracker operation.
class TrackerResult {
  final bool success;
  final domain.Tracker? tracker;
  final String? error;

  const TrackerResult({
    required this.success,
    this.tracker,
    this.error,
  });

  factory TrackerResult.success(domain.Tracker? tracker) => TrackerResult(
        success: true,
        tracker: tracker,
      );

  factory TrackerResult.error(String message) => TrackerResult(
        success: false,
        error: message,
      );
}
