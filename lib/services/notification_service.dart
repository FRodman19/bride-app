import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../domain/models/tracker.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import 'notification_id_manager.dart';

/// Callback type for handling notification taps
typedef NotificationTapCallback = void Function(String? payload);

/// Provider for the notification service.
/// Listens to auth and settings changes for auto-hydration.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();

  // Initialize service and then set up listeners
  service.initialize().then((_) {
    // Listen for auth state changes - cancel notifications on logout
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous is AuthAuthenticated && next is AuthUnauthenticated) {
        // User logged out - cancel all notifications
        service.cancelAll();
        debugPrint('NotificationService: Cleared notifications on logout');
      } else if (previous is! AuthAuthenticated && next is AuthAuthenticated) {
        // User logged in - hydrate notifications from settings
        final settings = ref.read(settingsProvider);
        service.hydrateFromSettings(settings);
      }
    });

    // Listen for settings changes - reschedule when settings change
    ref.listen<AppSettings>(settingsProvider, (previous, next) {
      // Only reschedule if user is authenticated
      final authState = ref.read(authProvider);
      if (authState is AuthAuthenticated) {
        service.hydrateFromSettings(next);
      }
    });

    // Initial hydration after service is initialized
    final authState = ref.read(authProvider);
    if (authState is AuthAuthenticated) {
      final settings = ref.read(settingsProvider);
      service.hydrateFromSettings(settings);
    }
  });

  ref.onDispose(() => service.dispose());
  return service;
});

/// Simple notification service for daily and weekly reminders.
///
/// This service handles LOCAL notifications only - no Firebase/FCM.
/// Notifications are scheduled on-device and fire at the specified times.
///
/// Features:
/// - Auto-hydration: Reschedules notifications based on settings on app start
/// - Logout cleanup: Cancels all notifications when user signs out
/// - Tap handling: Routes user to appropriate screen when notification is tapped
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'reminders',
      'Reminders',
      channelDescription: 'Daily and weekly reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  static const int _dailyReminderId = 1;
  static const int _weeklySummaryId = 2;
  bool _isInitialized = false;
  static bool _timezoneInitialized = false;

  /// Callback for handling notification taps (set by app router)
  static NotificationTapCallback? onNotificationTap;

  bool get isInitialized => _isInitialized;

  /// Check if exact alarm permission is granted (required for reliable scheduled notifications)
  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true; // iOS doesn't need this

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return false;

    return await androidPlugin.canScheduleExactNotifications() ?? false;
  }

  /// Request exact alarm permission - opens Android settings
  Future<void> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return;

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    await androidPlugin.requestExactAlarmsPermission();
  }

  /// Initialize timezone data (call once at app start in main.dart)
  static Future<void> initializeTimezone() async {
    if (_timezoneInitialized) return;

    tz.initializeTimeZones();
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
      _timezoneInitialized = true;
      debugPrint('NotificationService: Timezone set to $timezoneName');
    } catch (e) {
      // Fallback to UTC - notifications may fire at wrong time but won't crash
      tz.setLocalLocation(tz.UTC);
      _timezoneInitialized = true;
      debugPrint('NotificationService: Using UTC timezone (fallback): $e');
    }
  }

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _notifications.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          ),
        ),
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );

      // Create notification channel and request permission (Android)
      if (Platform.isAndroid) {
        final androidPlugin = _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        if (androidPlugin != null) {
          // Create channel for general reminders
          await androidPlugin.createNotificationChannel(
            const AndroidNotificationChannel(
              'reminders',
              'Reminders',
              description: 'Daily and weekly reminder notifications',
              importance: Importance.high,
            ),
          );

          // Create channel for tracker reminders
          await androidPlugin.createNotificationChannel(
            const AndroidNotificationChannel(
              'tracker_reminders',
              'Tracker Reminders',
              description: 'Per-tracker reminder notifications',
              importance: Importance.high,
            ),
          );

          // Request notification permission (Android 13+)
          await androidPlugin.requestNotificationsPermission();
        }
      }

      _isInitialized = true;
      debugPrint('NotificationService: Initialized successfully');
    } catch (e) {
      debugPrint('NotificationService: Failed to initialize: $e');
    }
  }

  /// Handle notification tap - route user to appropriate screen
  void _handleNotificationTap(NotificationResponse response) {
    debugPrint('NotificationService: Notification tapped - payload: ${response.payload}');
    if (onNotificationTap != null) {
      onNotificationTap!(response.payload);
    }
  }

  /// Ensure timezone and plugin are ready before scheduling.
  Future<bool> _ensureReady() async {
    if (!_timezoneInitialized) {
      await initializeTimezone();
    }
    if (!_isInitialized) {
      await initialize();
    }
    final ready = _isInitialized && _timezoneInitialized;
    if (!ready) {
      debugPrint('NotificationService: Not ready (init=$_isInitialized, tz=$_timezoneInitialized)');
    }
    return ready;
  }

  /// Hydrate (reschedule) notifications based on current settings.
  /// Called on app start, login, and when settings change.
  Future<void> hydrateFromSettings(AppSettings settings) async {
    final ready = await _ensureReady();
    if (!ready) {
      debugPrint('NotificationService: Cannot hydrate - not ready');
      return;
    }

    debugPrint('NotificationService: Hydrating notifications from settings...');

    // Daily reminder
    if (settings.dailyReminderEnabled) {
      await scheduleDailyReminder(time: settings.dailyReminderTime);
    } else {
      await cancelDailyReminder();
    }

    // Weekly summary (Sunday at 6 PM)
    if (settings.weeklySummaryEnabled) {
      await scheduleWeeklySummary(time: const TimeOfDay(hour: 18, minute: 0));
    } else {
      await cancelWeeklySummary();
    }

    debugPrint('NotificationService: Hydration complete');
  }

  /// Schedule daily reminder at specified time.
  /// Repeats every day at the same time.
  Future<void> scheduleDailyReminder({required TimeOfDay time}) async {
    final ready = await _ensureReady();
    if (!ready) {
      debugPrint('NotificationService: Not ready to schedule daily reminder');
      return;
    }

    // Cancel existing reminder first
    await _notifications.cancel(_dailyReminderId);

    // Calculate next occurrence
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If time already passed today, schedule for tomorrow
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _scheduleWithFallback(
      id: _dailyReminderId,
      title: 'Daily Reminder',
      body: 'Time to log your performance!',
      scheduled: scheduled,
      payload: 'daily_reminder',
      matchComponents: DateTimeComponents.time,
    );

    debugPrint(
        'NotificationService: Daily reminder scheduled for ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
  }

  /// Cancel the daily reminder
  Future<void> cancelDailyReminder() async {
    await _notifications.cancel(_dailyReminderId);
    debugPrint('NotificationService: Daily reminder cancelled');
  }

  /// Schedule weekly summary notification (Sunday at specified time).
  /// Repeats every Sunday.
  Future<void> scheduleWeeklySummary({required TimeOfDay time}) async {
    final ready = await _ensureReady();
    if (!ready) {
      debugPrint('NotificationService: Not ready to schedule weekly summary');
      return;
    }

    // Cancel existing summary first
    await _notifications.cancel(_weeklySummaryId);

    // Calculate next Sunday
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Find next Sunday
    while (scheduled.weekday != DateTime.sunday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    // If time already passed this Sunday, schedule for next week
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    await _scheduleWithFallback(
      id: _weeklySummaryId,
      title: 'Weekly Summary',
      body: 'Check your performance this week!',
      scheduled: scheduled,
      payload: 'weekly_summary',
      matchComponents: DateTimeComponents.dayOfWeekAndTime,
    );

    debugPrint(
        'NotificationService: Weekly summary scheduled for Sunday ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
  }

  /// Cancel the weekly summary
  Future<void> cancelWeeklySummary() async {
    await _notifications.cancel(_weeklySummaryId);
    debugPrint('NotificationService: Weekly summary cancelled');
  }

  /// Cancel all scheduled notifications.
  /// Called on logout to clear user-specific reminders.
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    debugPrint('NotificationService: All notifications cancelled');
  }

  /// Show an immediate test notification (for debugging).
  /// Returns true if notification was shown successfully.
  Future<bool> showTestNotification() async {
    if (!_isInitialized) {
      debugPrint('NotificationService: Cannot show test - not initialized');
      return false;
    }

    try {
      await _notifications.show(
        999, // Test notification ID
        'Test Notification',
        'If you see this, notifications are working!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders',
            'Reminders',
            channelDescription: 'Daily and weekly reminder notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: 'test',
      );
      debugPrint('NotificationService: Test notification shown successfully');
      return true;
    } catch (e) {
      debugPrint('NotificationService: Failed to show test notification: $e');
      return false;
    }
  }

  /// Schedule a test notification for 1 minute from now (for debugging).
  /// Uses the actual platform scheduler with fallback to inexact mode.
  /// Returns a tuple of (success, hasExactAlarmPermission) for UI feedback.
  Future<(bool success, bool usedExactMode)> scheduleTestNotification() async {
    final ready = await _ensureReady();
    if (!ready) {
      debugPrint('NotificationService: Cannot schedule test - not ready');
      return (false, false);
    }

    // Check if we have exact alarm permission
    final hasExactPermission = await canScheduleExactAlarms();

    try {
      final scheduled = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));

      await _scheduleWithFallback(
        id: 998,
        title: 'Scheduled Test',
        body: hasExactPermission
            ? 'This notification was scheduled 1 minute ago (exact mode)!'
            : 'This notification was scheduled 1 minute ago (inexact mode - may be delayed)!',
        scheduled: scheduled,
        payload: 'test_scheduled',
      );

      debugPrint('NotificationService: Test notification scheduled for $scheduled (exact=$hasExactPermission)');
      return (true, hasExactPermission);
    } catch (e) {
      debugPrint('NotificationService: Failed to schedule test notification: $e');
      return (false, false);
    }
  }

  /// Internal helper: schedule with exact mode, fallback to inexact on failure.
  Future<void> _scheduleWithFallback({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduled,
    required String payload,
    DateTimeComponents? matchComponents,
  }) async {
    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        _notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: matchComponents,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return;
    } catch (e) {
      debugPrint('NotificationService: Exact schedule failed ($e), retrying inexact');
    }

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        _notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: matchComponents,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('NotificationService: Inexact schedule also failed: $e');
    }
  }

  // ==================== TRACKER REMINDERS ====================

  /// Get notification details for tracker reminders channel
  NotificationDetails _getTrackerReminderDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'tracker_reminders',
        'Tracker Reminders',
        channelDescription: 'Per-tracker reminder notifications',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  /// Schedule a reminder for a specific tracker
  Future<void> scheduleTrackerReminder({
    required String trackerId,
    required String trackerName,
    required String frequency,
    required TimeOfDay time,
    int? dayOfWeek,
  }) async {
    final ready = await _ensureReady();
    if (!ready) return;

    // Get collision-free notification ID from NotificationIdManager
    final notificationId = await NotificationIdManager.getOrAssignId(trackerId);
    await _notifications.cancel(notificationId);

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate;

    if (frequency == 'daily') {
      scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notifications.zonedSchedule(
        notificationId,
        'Time to update $trackerName',
        'Log your ad spend and revenue for today',
        scheduledDate,
        _getTrackerReminderDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'tracker:$trackerId',
      );

      debugPrint(
          'NotificationService: Daily tracker reminder scheduled for $trackerName at ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
    } else if (frequency == 'weekly' && dayOfWeek != null) {
      // Find next occurrence of the specified day of week
      scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // Adjust to the correct day of week
      while (scheduledDate.weekday != dayOfWeek) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      // If time already passed this week, schedule for next week
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 7));
      }

      await _notifications.zonedSchedule(
        notificationId,
        'Time to update $trackerName',
        'Log your ad spend and revenue for this week',
        scheduledDate,
        _getTrackerReminderDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'tracker:$trackerId',
      );

      final days = ['', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      debugPrint(
          'NotificationService: Weekly tracker reminder scheduled for $trackerName on ${days[dayOfWeek]} at ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
    }
  }

  /// Cancel a tracker's reminder
  Future<void> cancelTrackerReminder(String trackerId) async {
    final notificationId = NotificationIdManager.getId(trackerId);
    if (notificationId != null) {
      await _notifications.cancel(notificationId);
      debugPrint('NotificationService: Cancelled reminder for tracker $trackerId');
    }
    await NotificationIdManager.releaseId(trackerId);
  }

  /// Hydrate all tracker reminders from a list of trackers
  /// Uses parallel batching (5 at a time) for optimal performance
  Future<void> hydrateTrackerReminders(List<Tracker> trackers) async {
    final ready = await _ensureReady();
    if (!ready) {
      debugPrint('NotificationService: Cannot hydrate tracker reminders - not ready');
      return;
    }

    const batchSize = 5; // Process 5 at a time

    for (var i = 0; i < trackers.length; i += batchSize) {
      final batch = trackers.skip(i).take(batchSize).toList();

      // Process batch in parallel
      await Future.wait(
        batch.map((tracker) async {
          if (!tracker.isArchived && tracker.reminderEnabled &&
              tracker.reminderFrequency != 'none' && tracker.reminderTime != null) {
            final timeParts = tracker.reminderTime!.split(':');
            if (timeParts.length == 2) {
              final hour = int.tryParse(timeParts[0]);
              final minute = int.tryParse(timeParts[1]);

              if (hour != null && minute != null) {
                try {
                  await scheduleTrackerReminder(
                    trackerId: tracker.id,
                    trackerName: tracker.name,
                    frequency: tracker.reminderFrequency,
                    time: TimeOfDay(hour: hour, minute: minute),
                    dayOfWeek: tracker.reminderDayOfWeek,
                  );
                } catch (e) {
                  debugPrint('Failed to hydrate tracker ${tracker.name}: $e');
                }
              }
            }
          } else {
            // Cancel reminder if tracker is archived or reminder is disabled
            try {
              await cancelTrackerReminder(tracker.id);
            } catch (e) {
              debugPrint('Failed to cancel tracker ${tracker.name}: $e');
            }
          }
        }),
        eagerError: false,
      );

      // Small delay between batches to prevent overwhelming the system
      if (i + batchSize < trackers.length) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    debugPrint('NotificationService: Hydrated ${trackers.length} tracker reminders');
  }

  void dispose() {
    debugPrint('NotificationService: Disposed');
  }
}
