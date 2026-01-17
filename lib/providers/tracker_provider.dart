// import 'package:drift/drift.dart' hide Column; // Removed - no longer using local caching
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../core/constants/platform_constants.dart';
import '../domain/models/tracker.dart' as domain;
// import '../data/local/database.dart'; // Removed - no longer using local caching
import '../services/notification_service.dart';
import 'auth_provider.dart';
import 'connectivity_provider.dart';
// import 'database_provider.dart'; // Removed - no longer using local caching

/// State for trackers list.
sealed class TrackersState {
  const TrackersState();
}

class TrackersLoading extends TrackersState {
  const TrackersLoading();
}

class TrackersLoaded extends TrackersState {
  final List<domain.Tracker> trackers;

  const TrackersLoaded(this.trackers);

  List<domain.Tracker> get activeTrackers =>
      trackers.where((t) => !t.isArchived).toList();
  List<domain.Tracker> get archivedTrackers =>
      trackers.where((t) => t.isArchived).toList();
}

class TrackersError extends TrackersState {
  final String message;
  const TrackersError(this.message);
}

/// Provider for trackers with online-first architecture.
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

/// Notifier for managing trackers with online-first support.
class TrackersNotifier extends StateNotifier<TrackersState> {
  final Ref _ref;

  TrackersNotifier(this._ref) : super(const TrackersLoading()) {
    _init();
  }

  void _init() {
    // Watch auth state changes
    _ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        // Immediately show loading state when user signs in
        if (mounted) state = const TrackersLoading();
        loadTrackers();
      } else if (next is AuthUnauthenticated) {
        // When user signs out, show empty state
        if (mounted) state = const TrackersLoaded([]);
      }
    }, fireImmediately: true);
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

  /// Convert technical errors to user-friendly messages
  String _getUserFriendlyError(dynamic error, String action) {
    final errorStr = error.toString().toLowerCase();

    // Network/connectivity errors
    if (errorStr.contains('network') ||
        errorStr.contains('socket') ||
        errorStr.contains('connection') ||
        errorStr.contains('timeout')) {
      return "We couldn't $action your tracker. Please check your internet connection and try again.";
    }

    // Supabase/server errors
    if (errorStr.contains('postgrest') ||
        errorStr.contains('supabase') ||
        errorStr.contains('server')) {
      return "We're having trouble connecting to our servers. Please try again in a moment.";
    }

    // Authentication errors
    if (errorStr.contains('auth') ||
        errorStr.contains('token') ||
        errorStr.contains('unauthorized')) {
      return "Your session has expired. Please sign in again.";
    }

    // Generic fallback
    return "We couldn't $action your tracker. Please try again.";
  }

  /// Load all trackers for the current user.
  /// ONLINE-FIRST: Loads ONLY from Supabase, never from local cache.
  Future<void> loadTrackers() async {
    final userId = _userId;
    if (userId == null) {
      if (mounted) state = const TrackersLoaded([]);
      return;
    }

    // Set loading state if not already loading
    if (mounted && state is! TrackersLoading) {
      state = const TrackersLoading();
    }

    try {
      // Check if online
      if (!_isOnline) {
        if (mounted) {
          state = const TrackersError(
            "You're offline. Please check your internet connection and try again."
          );
        }
        return;
      }

      // Load ONLY from Supabase (never from local)
      await _syncFromRemote(userId);
    } catch (e) {
      if (mounted) state = TrackersError(_getUserFriendlyError(e, 'load'));
    }
  }

  /// Load trackers from Supabase (NO local caching).
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

      final domainTrackers = <domain.Tracker>[];

      for (final data in (response as List)) {
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

        // Calculate totals from entries (NO local writes)
        double totalRevenue = 0;
        double totalSpend = 0;
        int entryCount = 0;

        final entries = data['daily_entries'] as List? ?? [];
        for (final entryData in entries) {
          entryCount++;
          final entryRevenue = (entryData['total_revenue'] as num?)?.toInt() ?? 0;
          totalRevenue += entryRevenue;

          // Calculate spend from platform spends (NO local writes)
          final spends = entryData['entry_platform_spends'] as List? ?? [];
          for (final spend in spends) {
            final amount = (spend['amount'] as num?)?.toInt() ?? 0;
            totalSpend += amount;
          }
        }

        // Create domain tracker directly from Supabase data (NO local writes)
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
            'reminder_enabled': data['reminder_enabled'] ?? false,
            'reminder_frequency': data['reminder_frequency'] ?? 'none',
            'reminder_time': data['reminder_time'],
            'reminder_day_of_week': data['reminder_day_of_week'],
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
      // Sync failed - show error to user
      if (mounted) {
        state = TrackersError(_getUserFriendlyError(e, 'load'));
      }
    }
  }

  /// Create a new tracker.
  /// Online-first: Saves to Supabase FIRST, then caches locally.
  Future<TrackerResult> createTracker({
    required String name,
    required DateTime startDate,
    String currency = 'XOF',
    double? revenueTarget,
    int? engagementTarget,
    double setupCost = 0,
    double growthCostMonthly = 0,
    String? notes,
    List<String>? platforms,
    List<String> goalTypes = const [],
    bool reminderEnabled = false,
    String reminderFrequency = 'none',
    String? reminderTime,
    int? reminderDayOfWeek,
  }) async {
    // 1. Check if online
    if (!_isOnline) {
      return TrackerResult.error(
        "You're offline. Please check your internet connection and try again."
      );
    }

    // Use default platforms from PlatformConstants if not provided
    final platformsToUse = platforms ??
        PlatformConstants.platforms
            .take(2) // Default to first 2 platforms (Facebook, TikTok)
            .map((p) => p.name)
            .toList();
    final userId = _userId;
    if (userId == null) {
      return TrackerResult.error('You need to sign in to create a tracker.');
    }

    // Check limit
    if (state is TrackersLoaded) {
      final active = (state as TrackersLoaded).activeTrackers;
      if (active.length >= 20) {
        return TrackerResult.error(
          "You've reached the maximum of 20 active trackers. Archive one to create a new tracker."
        );
      }
    }

    try {
      // Read providers BEFORE async operations to avoid lifecycle issues
      final notificationService = _ref.read(notificationServiceProvider);

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
        platforms: platformsToUse,
        goalTypes: goalTypes,
        reminderEnabled: reminderEnabled,
        reminderFrequency: reminderFrequency,
        reminderTime: reminderTime,
        reminderDayOfWeek: reminderDayOfWeek,
      );

      // 2. Write to Supabase FIRST
      try {
        await SupabaseConfig.client
            .from('trackers')
            .insert(tracker.toMap());

        // Insert platforms
        if (platformsToUse.isNotEmpty) {
          final platformsData = platformsToUse
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
      } catch (e) {
        // 3. If Supabase fails, return friendly error (DO NOT save locally)
        return TrackerResult.error(_getUserFriendlyError(e, 'save'));
      }

      // NO local caching - Supabase is the source of truth

      // Schedule notification if enabled
      if (reminderEnabled && reminderFrequency != 'none' && reminderTime != null) {
        try {
          final timeParts = reminderTime.split(':');
          if (timeParts.length == 2) {
            final hour = int.tryParse(timeParts[0]);
            final minute = int.tryParse(timeParts[1]);

            if (hour != null && minute != null &&
                hour >= 0 && hour <= 23 &&
                minute >= 0 && minute <= 59) {
              // Validate day of week for weekly reminders
              if (reminderFrequency == 'weekly' &&
                  (reminderDayOfWeek == null || reminderDayOfWeek < 1 || reminderDayOfWeek > 7)) {
                debugPrint('Invalid day of week: $reminderDayOfWeek');
              } else {
                await notificationService.scheduleTrackerReminder(
                  trackerId: tracker.id,
                  trackerName: tracker.name,
                  frequency: reminderFrequency,
                  time: TimeOfDay(hour: hour, minute: minute),
                  dayOfWeek: reminderDayOfWeek,
                );
              }
            } else {
              debugPrint('Invalid reminder time: $hour:$minute');
            }
          }
        } catch (e) {
          debugPrint('Failed to schedule notification: $e');
          // Don't fail tracker creation if notification fails
        }
      }

      // Reload trackers from Supabase to reflect the newly created tracker
      await loadTrackers();

      return TrackerResult.success(tracker);
    } catch (e) {
      return TrackerResult.error(_getUserFriendlyError(e, 'create'));
    }
  }

  /// Update an existing tracker.
  /// Online-first: Updates Supabase FIRST, then caches locally.
  Future<TrackerResult> updateTracker(domain.Tracker tracker) async {
    // 1. Check if online
    if (!_isOnline) {
      return TrackerResult.error(
        "You're offline. Please check your internet connection and try again."
      );
    }

    if (_userId == null) {
      return TrackerResult.error('You need to sign in to update a tracker.');
    }

    try {
      final notificationService = _ref.read(notificationServiceProvider);
      final updatedTracker = tracker.copyWith(updatedAt: DateTime.now());

      // 2. Write to Supabase FIRST
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
      } catch (e) {
        // 3. If Supabase fails, return friendly error (DO NOT save locally)
        return TrackerResult.error(_getUserFriendlyError(e, 'update'));
      }

      // NO local caching - Supabase is the source of truth

      // Reschedule notification if settings changed
      if (updatedTracker.reminderEnabled &&
          updatedTracker.reminderFrequency != 'none' &&
          updatedTracker.reminderTime != null) {
        try {
          final timeParts = updatedTracker.reminderTime!.split(':');
          if (timeParts.length == 2) {
            final hour = int.tryParse(timeParts[0]);
            final minute = int.tryParse(timeParts[1]);

            if (hour != null && minute != null &&
                hour >= 0 && hour <= 23 &&
                minute >= 0 && minute <= 59) {
              // Validate day of week for weekly reminders
              if (updatedTracker.reminderFrequency == 'weekly' &&
                  (updatedTracker.reminderDayOfWeek == null ||
                   updatedTracker.reminderDayOfWeek! < 1 ||
                   updatedTracker.reminderDayOfWeek! > 7)) {
                debugPrint('Invalid day of week: ${updatedTracker.reminderDayOfWeek}');
              } else {
                await notificationService.scheduleTrackerReminder(
                  trackerId: updatedTracker.id,
                  trackerName: updatedTracker.name,
                  frequency: updatedTracker.reminderFrequency,
                  time: TimeOfDay(hour: hour, minute: minute),
                  dayOfWeek: updatedTracker.reminderDayOfWeek,
                );
              }
            } else {
              debugPrint('Invalid reminder time: $hour:$minute');
            }
          }
        } catch (e) {
          debugPrint('Failed to reschedule notification: $e');
        }
      } else {
        // Cancel notification if disabled
        try {
          await notificationService.cancelTrackerReminder(updatedTracker.id);
        } catch (e) {
          debugPrint('Failed to cancel notification: $e');
        }
      }

      await loadTrackers();
      return TrackerResult.success(updatedTracker);
    } catch (e) {
      return TrackerResult.error(_getUserFriendlyError(e, 'update'));
    }
  }

  /// Archive a tracker.
  /// Online-first: Updates Supabase FIRST, then caches locally.
  Future<TrackerResult> archiveTracker(String trackerId) async {
    // Check if online
    if (!_isOnline) {
      return TrackerResult.error(
        "You're offline. Please check your internet connection and try again."
      );
    }

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
  /// Online-first: Updates Supabase FIRST, then caches locally.
  Future<TrackerResult> restoreTracker(String trackerId) async {
    // Check if online
    if (!_isOnline) {
      return TrackerResult.error(
        "You're offline. Please check your internet connection and try again."
      );
    }

    final currentState = state;
    if (currentState is! TrackersLoaded) {
      return TrackerResult.error('Trackers not loaded');
    }

    // Check limit before restoring
    if (currentState.activeTrackers.length >= 20) {
      return TrackerResult.error(
        "You've reached the maximum of 20 active trackers. Archive one to create a new tracker."
      );
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
  /// Online-first: Deletes from Supabase FIRST, then removes from local cache.
  Future<TrackerResult> deleteTracker(String trackerId) async {
    // 1. Check if online
    if (!_isOnline) {
      return TrackerResult.error(
        "You're offline. Please check your internet connection and try again."
      );
    }

    if (_userId == null) {
      return TrackerResult.error('You need to sign in to delete a tracker.');
    }

    try {
      final notificationService = _ref.read(notificationServiceProvider);

      // Cancel notification and release ID BEFORE deletion
      try {
        await notificationService.cancelTrackerReminder(trackerId);
      } catch (e) {
        debugPrint('Failed to cancel notification on delete: $e');
      }

      // 2. Delete from Supabase FIRST
      try {
        await SupabaseConfig.client
            .from('trackers')
            .delete()
            .eq('id', trackerId);
      } catch (e) {
        // 3. If Supabase fails, return friendly error (DO NOT delete locally)
        return TrackerResult.error(_getUserFriendlyError(e, 'delete'));
      }

      // NO local caching - Supabase is the source of truth

      await loadTrackers();
      return TrackerResult.success(null);
    } catch (e) {
      return TrackerResult.error(_getUserFriendlyError(e, 'delete'));
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
