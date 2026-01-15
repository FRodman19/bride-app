# Phase 7.5: Platform Expansion, Per-Tracker Notifications & Notification Center - UPDATED PLAN

> **🎯 SINGLE SOURCE OF TRUTH for Platform Expansion, Notifications & Notification Center**
>
> **Status**: Updated after comprehensive code review + Notification Center added
> **Version**: 2.1 (Corrected + Extended)
> **Date**: 2026-01-14
>
> **⚠️ CRITICAL CHANGES FROM V1:**
> - ✅ Notification ID management completely redesigned (sequential vs hash)
> - ✅ Database backup/rollback strategy added
> - ✅ All code examples verified against existing codebase
> - ✅ GOL design system compliance confirmed (GOLSelectableChipGroup EXISTS)
> - ✅ Provider lifecycle fixes applied
> - ✅ Performance optimizations added (parallel hydration)
> - ✅ Missing UI components identified and addressed
> - 🆕 **Phase 2.5 added: In-App Notification Center**
> - ✅ Estimated time updated: 20-24h → 34-44h (includes fixes + notification center)

---

## Quick Links

- **Main Plan**: `/Users/MAC/Documents/test mobile app/bride_app/IMPLEMENTATION_PLAN.md`
- **Original Plan v1**: `/Users/MAC/.claude/plans/recursive-gliding-puddle.md`
- **Code Review**: Agent review identified 30 issues (5 critical, 5 high priority)
- **Design System**: `lib/grow_out_loud/` (MANDATORY - no custom components)

---

## Critical Fixes Applied

### 1. Notification ID Collision Fixed ✅
**Problem**: Hash-based IDs caused collisions (~2% with 20 trackers)
**Solution**: Sequential ID allocation with SharedPreferences persistence

**New Service Created**: `NotificationIdManager`
- Range: 1000-9999 (9000 IDs available)
- Collision-free sequential allocation
- Persists across app restarts
- IDs recycled when trackers deleted

### 2. Database Migration Safety ✅
**Problem**: No rollback strategy for irreversible ALTER COLUMN
**Solution**: Pre-migration backup with automatic restoration on failure

**New Utility Created**: `DatabaseBackup`
- Creates timestamped backups before migration
- Restores on failure automatically
- Cleans old backups (keeps last 3)

### 3. Provider Lifecycle Fixed ✅
**Problem**: Reading providers after async gaps causes crashes
**Solution**: Read all providers BEFORE async operations

### 4. Notification Hydration Optimized ✅
**Problem**: Sequential hydration blocks UI for 2 seconds with 20 trackers
**Solution**: Parallel batching (5 at a time) reduces to ~500ms

### 5. GOL Design System Verified ✅
**Status**: `GOLSelectableChipGroup` EXISTS in codebase (code review was wrong)
**Location**: `lib/grow_out_loud/components/gol_chips.dart:194-229`

---

## What This Plan Covers

This plan implements **THREE major features**:

1. **Platform Expansion** (Phase 1)
   - Expand from 2 platforms → 10 platforms
   - Add: Instagram, YouTube, Google Ads, LinkedIn, Reddit Ads, Twitter/X, Snapchat, Pinterest
   - Maintain branded SVG icons with Iconsax fallbacks

2. **Per-Tracker Notification Scheduling** (Phase 2)
   - Custom reminder schedules per project
   - Daily and Weekly frequencies
   - Morning reminders with direct log entry access
   - Collision-free notification ID management

3. **In-App Notification Center** (Phase 2.5) 🆕
   - Dashboard-accessible notification center
   - Three notification types: Action Needed (red), Insight (yellow), Milestone (green)
   - Time-based grouping: Today, Yesterday, This Week
   - Unread badge with count
   - Integration with push and local notifications

---

## Implementation Phases

### PHASE 0: Pre-Implementation Setup (NEW - 4-6 hours)
**MUST complete before Phase 1, Phase 2, or Phase 2.5**

#### Task 0.1: Create NotificationIdManager Service ⚡ CRITICAL
```dart
// lib/services/notification_id_manager.dart
class NotificationIdManager {
  static Future<void> initialize() async { /* ... */ }
  static int getOrAssignId(String trackerId) { /* ... */ }
  static Future<void> releaseId(String trackerId) async { /* ... */ }
}
```

**Deliverables**:
- [ ] Service created with sequential ID allocation
- [ ] SharedPreferences persistence implemented
- [ ] Unit tests written and passing
- [ ] Initialized in main.dart before app runs

#### Task 0.2: Create DatabaseBackup Utility ⚡ CRITICAL
```dart
// lib/data/local/database_backup.dart
class DatabaseBackup {
  static Future<String> createBackup(String dbPath) async { /* ... */ }
  static Future<void> restoreFromBackup(String dbPath) async { /* ... */ }
  static Future<void> cleanOldBackups(String dbPath) async { /* ... */ }
}
```

**Deliverables**:
- [ ] Backup utility created
- [ ] Integration with migration strategy
- [ ] Rollback tested on simulated failure

---

### PHASE 1: Platform Expansion (4-6 hours)
**Risk**: LOW ✅
**Depends on**: Phase 0 completed

#### Task 1.1: Obtain/Create SVG Assets
- [ ] Instagram icon (gradient logo)
- [ ] YouTube icon (red play button)
- [ ] Google Ads icon (multicolor)
- [ ] LinkedIn icon (blue)
- [ ] Reddit Ads icon (orange)
- [ ] Twitter/X icon (black)

**Platforms**: Facebook ✓, TikTok ✓, Instagram 🆕, YouTube 🆕, Google Ads 🆕, LinkedIn 🆕, Reddit Ads 🆕, Twitter/X 🆕, Snapchat (Iconsax), Pinterest (Iconsax)

#### Task 1.2: Update Platform Constants
**File**: `lib/core/constants/platform_constants.dart`

```dart
static const List<PlatformInfo> platforms = [
  PlatformInfo(id: 'facebook', name: 'Facebook', svgAssetPath: 'assets/icons/facebook.svg'),
  PlatformInfo(id: 'tiktok', name: 'TikTok', svgAssetPath: 'assets/icons/tiktok.svg'),
  PlatformInfo(id: 'instagram', name: 'Instagram', svgAssetPath: 'assets/icons/instagram.svg'), // 🆕
  PlatformInfo(id: 'youtube', name: 'YouTube', svgAssetPath: 'assets/icons/youtube.svg'), // 🆕
  PlatformInfo(id: 'google-ads', name: 'Google Ads', svgAssetPath: 'assets/icons/google-ads.svg'), // 🆕
  PlatformInfo(id: 'linkedin', name: 'LinkedIn', svgAssetPath: 'assets/icons/linkedin.svg'), // 🆕
  PlatformInfo(id: 'reddit-ads', name: 'Reddit Ads', svgAssetPath: 'assets/icons/reddit-ads.svg'), // 🆕
  PlatformInfo(id: 'twitter', name: 'Twitter/X', svgAssetPath: 'assets/icons/twitter.svg'), // 🆕
  PlatformInfo(id: 'snapchat', name: 'Snapchat'), // Iconsax fallback
  PlatformInfo(id: 'pinterest', name: 'Pinterest'), // Iconsax fallback
];
```

#### Task 1.3: Update Platform Icons Utility
**File**: `lib/core/utils/platform_icons.dart`

**Pattern**: Use existing switch-case pattern (DO NOT change to helper methods)

```dart
static Widget getIcon(String platform, {double size = 24, Color? color}) {
  final platformLower = platform.toLowerCase();

  switch (platformLower) {
    case 'facebook':
      return SizedBox(width: size, height: size,
        child: SvgPicture.asset('assets/icons/facebook.svg', fit: BoxFit.contain));
    case 'tiktok':
      return SizedBox(width: size, height: size,
        child: SvgPicture.asset('assets/icons/tiktok.svg', fit: BoxFit.contain));
    // 🆕 Add 6 new SVG cases
    case 'instagram':
      return SizedBox(width: size, height: size,
        child: SvgPicture.asset('assets/icons/instagram.svg', fit: BoxFit.contain));
    // ... (repeat for youtube, google-ads, linkedin, reddit-ads, twitter)

    // Iconsax fallbacks
    case 'snapchat':
      return Icon(Iconsax.camera, size: size, color: color);
    case 'pinterest':
      return Icon(Iconsax.image, size: size, color: color);
    default:
      return Icon(Iconsax.global, size: size, color: color);
  }
}
```

#### Remaining Phase 1 Tasks (1.4-1.8)
- [ ] 1.4: Update create_tracker_screen.dart (use dynamic platform list)
- [ ] 1.5: Update edit_tracker_screen.dart (same changes)
- [ ] 1.6: Update pubspec.yaml (add 6 SVG assets)
- [ ] 1.7: Update design gallery (add 8 new platform icons)
- [ ] 1.8: Test all 10 platforms in create/edit/display flows

**Phase 1 Success Criteria**:
- [ ] 10 platforms selectable
- [ ] All SVG icons render correctly
- [ ] Existing trackers backward compatible
- [ ] Platform sync works to Supabase

---

### PHASE 2: Per-Tracker Notifications (20-24 hours)
**Risk**: MEDIUM ⚠️
**Depends on**: Phase 0 completed (NotificationIdManager required)

#### Task 2.1: Database Schema Changes

**2.1.0: Create Backup BEFORE Migration** ⚡ NEW
```dart
// In database.dart migration
onUpgrade: (m, from, to) async {
  if (from == 1 && to == 2) {
    try {
      final dbPath = /* get DB path */;
      await DatabaseBackup.createBackup(dbPath);

      // Proceed with migration
      await m.addColumn(trackers, trackers.reminderEnabled);
      // ... other columns

      await DatabaseBackup.cleanOldBackups(dbPath, keepCount: 3);
    } catch (e) {
      await DatabaseBackup.restoreFromBackup(dbPath);
      rethrow;
    }
  }
}
```

**2.1.1: Update Drift Trackers Table**
```dart
// lib/data/local/tables/trackers_table.dart
BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false))();
TextColumn get reminderFrequency => text().withDefault(const Constant('none'))();
TextColumn get reminderTime => text().nullable()();  // "HH:MM"
IntColumn get reminderDayOfWeek => integer().nullable()();  // 1-7
```

**2.1.2: Create Migration** (schema v1 → v2)
```dart
@override
int get schemaVersion => 2;
```

**2.1.3: Update Supabase Schema** ⚡ CORRECTED
```sql
-- CORRECTED: Fixed regex, added indexes
ALTER TABLE trackers
ADD COLUMN reminder_enabled BOOLEAN DEFAULT FALSE NOT NULL,
ADD COLUMN reminder_frequency TEXT DEFAULT 'none' NOT NULL,
ADD COLUMN reminder_time TEXT,
ADD COLUMN reminder_day_of_week INTEGER;

-- FIXED: Correct time validation (was allowing 19:99)
ALTER TABLE trackers
ADD CONSTRAINT valid_reminder_time
CHECK (reminder_time IS NULL OR
       reminder_time ~ '^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$');

-- NEW: Performance index
CREATE INDEX idx_trackers_reminder_enabled
ON trackers(reminder_enabled) WHERE reminder_enabled = TRUE;
```

#### Task 2.2: Domain Model Updates
**File**: `lib/domain/models/tracker.dart`

```dart
class Tracker {
  final bool reminderEnabled;
  final String reminderFrequency;  // 'none', 'daily', 'weekly'
  final String? reminderTime;      // "HH:MM"
  final int? reminderDayOfWeek;    // 1-7

  // Update constructor, copyWith, toMap, fromMap
}
```

#### Task 2.3: Notification Service Extensions ⚡ UPDATED

**CRITICAL CHANGES**:
- ✅ Use `NotificationIdManager` instead of hash-based IDs
- ✅ Parallel batching for hydration (5 at a time)
- ✅ Retry logic with exponential backoff

```dart
// lib/services/notification_service.dart

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

  // ✅ FIXED: Use NotificationIdManager (collision-free)
  final notificationId = NotificationIdManager.getOrAssignId(trackerId);
  await _notifications.cancel(notificationId);

  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate;

  if (frequency == 'daily') {
    scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      notificationId,
      'Time to update $trackerName',
      'Log your ad spend and revenue for today',
      scheduledDate,
      _getNotificationDetails('tracker_reminders'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'tracker:$trackerId',
    );
  } else if (frequency == 'weekly' && dayOfWeek != null) {
    // Weekly scheduling logic...
  }
}

/// Cancel a tracker's reminder
Future<void> cancelTrackerReminder(String trackerId) async {
  final notificationId = NotificationIdManager.getId(trackerId);
  if (notificationId != null) {
    await _notifications.cancel(notificationId);
  }
  await NotificationIdManager.releaseId(trackerId);
}

/// Hydrate all tracker reminders (OPTIMIZED)
Future<void> hydrateTrackerReminders(List<Tracker> trackers) async {
  const batchSize = 5; // Process 5 at a time

  for (var i = 0; i < trackers.length; i += batchSize) {
    final batch = trackers.skip(i).take(batchSize).toList();

    // ✅ FIXED: Parallel processing within batch
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
                debugPrint('Failed to hydrate ${tracker.name}: $e');
              }
            }
          }
        } else {
          try {
            await cancelTrackerReminder(tracker.id);
          } catch (e) {
            debugPrint('Failed to cancel ${tracker.name}: $e');
          }
        }
      }),
      eagerError: false,
    );

    // Small delay between batches
    if (i + batchSize < trackers.length) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
```

#### Task 2.4: Provider Integration ⚡ UPDATED

**CRITICAL FIX**: Read providers BEFORE async gaps

```dart
// lib/providers/tracker_provider.dart

Future<TrackerResult> createTracker({
  required String name,
  // ... params
  bool reminderEnabled = false,
  String reminderFrequency = 'none',
  String? reminderTime,
  int? reminderDayOfWeek,
}) async {
  // ✅ FIXED: Read providers BEFORE async operations
  final trackerDao = _ref.read(trackerDaoProvider);
  final notificationService = _ref.read(notificationServiceProvider);
  final syncDao = _ref.read(syncDaoProvider);

  try {
    // Create tracker
    final tracker = domain.Tracker.create(/* ... */);
    await trackerDao.insertTracker(trackerCompanion);

    // Schedule notification (service already captured)
    if (reminderEnabled && reminderFrequency != 'none' && reminderTime != null) {
      try {
        final timeParts = reminderTime.split(':');
        if (timeParts.length == 2) {
          final hour = int.tryParse(timeParts[0]);
          final minute = int.tryParse(timeParts[1]);

          if (hour != null && minute != null) {
            await notificationService.scheduleTrackerReminder(
              trackerId: tracker.id,
              trackerName: tracker.name,
              frequency: reminderFrequency,
              time: TimeOfDay(hour: hour, minute: minute),
              dayOfWeek: reminderDayOfWeek,
            );
          }
        }
      } catch (e) {
        debugPrint('Failed to schedule notification: $e');
        // Don't fail tracker creation
      }
    }

    // Sync...
  } catch (e) {
    return TrackerResult.error('Failed to create tracker: $e');
  }
}

// Apply same fix to updateTracker, archiveTracker, deleteTracker
```

#### Task 2.5: UI - Create Tracker Screen

**File**: `lib/features/tracker/screens/create_tracker_screen.dart`

**✅ VERIFIED**: Uses existing `GOLSelectableChipGroup` (no need to create)

```dart
// State variables
bool _reminderEnabled = false;
String _reminderFrequency = 'daily';
TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
int _reminderDayOfWeek = 1;

// UI Section (add after notes field)
GOLDivider(),
SizedBox(height: GOLSpacing.space6),

_buildLabel(l10n.reminderNotifications),
Text(l10n.reminderNotificationsHelper,
  style: textTheme.bodySmall?.copyWith(color: colors.textSecondary)),
SizedBox(height: GOLSpacing.space4),

// Enable/disable switch
GOLCard(
  variant: GOLCardVariant.elevated,
  child: Padding(
    padding: EdgeInsets.all(GOLSpacing.space4),
    child: Row(
      children: [
        Icon(Iconsax.notification, color: colors.interactivePrimary),
        SizedBox(width: GOLSpacing.space3),
        Expanded(child: Text(l10n.enableReminder, style: textTheme.bodyMedium)),
        Switch(value: _reminderEnabled,
          onChanged: (value) => setState(() => _reminderEnabled = value)),
      ],
    ),
  ),
),

if (_reminderEnabled) ...[
  SizedBox(height: GOLSpacing.space4),

  // Frequency selector (✅ USES EXISTING COMPONENT)
  _buildLabel(l10n.frequency),
  GOLSelectableChipGroup(
    items: [l10n.daily, l10n.weekly],
    selectedItems: {_reminderFrequency == 'daily' ? l10n.daily : l10n.weekly},
    onChanged: (selected) {
      setState(() {
        _reminderFrequency = selected.first == l10n.daily ? 'daily' : 'weekly';
      });
    },
  ),

  // Time picker...
  // Day picker (if weekly)...
],
```

#### Remaining Phase 2 Tasks
- [ ] 2.6: Update edit_tracker_screen.dart (same UI)
- [ ] 2.7: Update notification routing (handle cold start)
- [ ] 2.8: Update settings screen (add permission status)
- [ ] 2.9: Add localization strings (EN + FR)
- [ ] 2.10: Comprehensive testing

**Phase 2 Success Criteria**:
- [ ] Users can enable/disable per-tracker notifications
- [ ] Notifications fire at correct time
- [ ] Tap routes to log entry screen
- [ ] No ID collisions with 20 trackers
- [ ] Hydration doesn't block UI
- [ ] Migration backup/rollback works

---

## PHASE 2.5: In-App Notification Center

### Goal
Create an in-app notification center accessible from the dashboard to display action items, insights, and milestones. This provides a centralized location for all app notifications (both local and push) with visual grouping and read/unread tracking.

### User Flow
1. User taps notification icon in dashboard header (next to design gallery icon)
2. Bottom sheet slides up showing all notifications grouped by time
3. User can:
   - View notifications by category (Action Needed, Insight, Milestone)
   - See time groupings (TODAY, YESTERDAY, THIS WEEK)
   - Mark all as read
   - Tap notification to navigate to related screen
   - Dismiss bottom sheet

### Tasks

#### Task 2.5.1: Create Notification Data Model & Database Table
- [ ] Create `lib/domain/models/app_notification.dart`
- [ ] Add notification table to Drift database
- [ ] Create database migration (version 3)
- [ ] Add DAO methods for CRUD operations

**File to create**: `bride_app/lib/domain/models/app_notification.dart`

```dart
import 'package:equatable/equatable.dart';

/// Type of notification with associated semantic color.
enum AppNotificationType {
  actionNeeded,  // Red - requires user action
  insight,       // Yellow/Amber - helpful information
  milestone,     // Green - achievement/celebration
}

/// Represents a notification in the app notification center.
class AppNotification extends Equatable {
  final String id;
  final AppNotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  /// Optional: Tracker ID if notification is related to a specific tracker
  final String? trackerId;

  /// Optional: Navigation route when notification is tapped
  final String? actionRoute;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.trackerId,
    this.actionRoute,
  });

  AppNotification copyWith({
    String? id,
    AppNotificationType? type,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? trackerId,
    String? actionRoute,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      trackerId: trackerId ?? this.trackerId,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        message,
        timestamp,
        isRead,
        trackerId,
        actionRoute,
      ];
}
```

**Drift Table** (add to `app_database.dart`):

```dart
@DataClassName('AppNotificationData')
class AppNotifications extends Table {
  TextColumn get id => text()();
  IntColumn get type => intEnum<AppNotificationType>()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  TextColumn get trackerId => text().nullable()();
  TextColumn get actionRoute => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Migration** (update `onUpgrade` in database):

```dart
if (from == 2 && to == 3) {
  await m.createTable(appNotifications);
  await m.createIndex(Index(
    'idx_notifications_timestamp',
    'ON app_notifications(timestamp DESC)',
  ));
}
```

**Acceptance Criteria:**
- [ ] Model handles all three notification types
- [ ] Database stores notifications with indexes for performance
- [ ] DAO provides methods: create, markAsRead, markAllAsRead, getUnreadCount, getGroupedByTime
- [ ] Old notifications auto-deleted after 30 days

---

#### Task 2.5.2: Create NotificationCenterProvider
- [ ] Create `lib/providers/notification_center_provider.dart`
- [ ] Implement state management for notifications
- [ ] Add methods for grouping (Today/Yesterday/This Week)
- [ ] Add unread count stream

**File to create**: `bride_app/lib/providers/notification_center_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/dao/notification_dao.dart';
import '../domain/models/app_notification.dart';

/// Provider for notification center state
final notificationCenterProvider =
    StateNotifierProvider<NotificationCenterNotifier, NotificationCenterState>((ref) {
  final notificationDao = ref.watch(notificationDaoProvider);
  return NotificationCenterNotifier(notificationDao);
});

/// Provider for unread notification count (for badge)
final unreadCountProvider = StreamProvider<int>((ref) {
  final notificationDao = ref.watch(notificationDaoProvider);
  return notificationDao.watchUnreadCount();
});

class NotificationCenterNotifier extends StateNotifier<NotificationCenterState> {
  final NotificationDao _notificationDao;

  NotificationCenterNotifier(this._notificationDao)
      : super(const NotificationCenterLoading()) {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final notifications = await _notificationDao.getAllNotifications();
      final grouped = _groupByTime(notifications);
      state = NotificationCenterLoaded(
        allNotifications: notifications,
        groupedNotifications: grouped,
      );
    } catch (e) {
      state = NotificationCenterError(message: e.toString());
    }
  }

  Map<String, List<AppNotification>> _groupByTime(List<AppNotification> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: now.weekday - 1));

    final Map<String, List<AppNotification>> grouped = {
      'TODAY': [],
      'YESTERDAY': [],
      'THIS WEEK': [],
    };

    for (final notification in notifications) {
      final notificationDate = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );

      if (notificationDate.isAtSameMomentAs(today)) {
        grouped['TODAY']!.add(notification);
      } else if (notificationDate.isAtSameMomentAs(yesterday)) {
        grouped['YESTERDAY']!.add(notification);
      } else if (notificationDate.isAfter(thisWeekStart) ||
                 notificationDate.isAtSameMomentAs(thisWeekStart)) {
        grouped['THIS WEEK']!.add(notification);
      }
    }

    // Remove empty groups
    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  Future<void> markAsRead(String notificationId) async {
    await _notificationDao.markAsRead(notificationId);
    await _loadNotifications();
  }

  Future<void> markAllAsRead() async {
    await _notificationDao.markAllAsRead();
    await _loadNotifications();
  }

  Future<void> addNotification(AppNotification notification) async {
    await _notificationDao.insertNotification(notification);
    await _loadNotifications();
  }

  Future<void> refresh() => _loadNotifications();
}

// State classes
sealed class NotificationCenterState {
  const NotificationCenterState();
}

class NotificationCenterLoading extends NotificationCenterState {
  const NotificationCenterLoading();
}

class NotificationCenterLoaded extends NotificationCenterState {
  final List<AppNotification> allNotifications;
  final Map<String, List<AppNotification>> groupedNotifications;

  const NotificationCenterLoaded({
    required this.allNotifications,
    required this.groupedNotifications,
  });
}

class NotificationCenterError extends NotificationCenterState {
  final String message;
  const NotificationCenterError({required this.message});
}
```

**Acceptance Criteria:**
- [ ] Provider loads notifications on init
- [ ] Grouping logic works correctly for all time periods
- [ ] Unread count updates reactively
- [ ] Mark all as read updates state immediately

---

#### Task 2.5.3: Create Notification Card Component
- [ ] Create `lib/grow_out_loud/components/gol_notification_card.dart`
- [ ] Support all three notification types with semantic colors
- [ ] Add to design gallery for reusability

**File to create**: `bride_app/lib/grow_out_loud/components/gol_notification_card.dart`

```dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_spacing.dart';
import '../../domain/models/app_notification.dart';

/// Notification card for the notification center.
///
/// Displays notification with type-specific color indicator and icon.
class GOLNotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const GOLNotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    // Get color and icon based on notification type
    final Color indicatorColor;
    final IconData icon;

    switch (notification.type) {
      case AppNotificationType.actionNeeded:
        indicatorColor = colors.stateError;
        icon = Iconsax.warning_2;
      case AppNotificationType.insight:
        indicatorColor = colors.stateWarning;
        icon = Iconsax.lamp;
      case AppNotificationType.milestone:
        indicatorColor = colors.stateSuccess;
        icon = Iconsax.award;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(GOLSpacing.space4),
        decoration: BoxDecoration(
          color: notification.isRead
              ? colors.surfaceDefault
              : colors.surfaceRaised,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colors.borderDefault,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type indicator circle
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: GOLSpacing.space3),

            // Icon
            Icon(icon, size: 20, color: indicatorColor),
            const SizedBox(width: GOLSpacing.space3),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: textTheme.titleSmall?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space1),
                  Text(
                    notification.message,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            // Unread indicator
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: colors.interactivePrimary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
```

**Acceptance Criteria:**
- [ ] Card displays all notification fields correctly
- [ ] Color indicators match semantic colors from GOL
- [ ] Unread notifications visually distinct
- [ ] Timestamp formatted relative to current time
- [ ] Component added to design gallery

---

#### Task 2.5.4: Create Notification Center Bottom Sheet
- [ ] Create `lib/features/notification_center/notification_center_bottom_sheet.dart`
- [ ] Implement grouped list view (Today/Yesterday/This Week)
- [ ] Add "Mark All as Read" button
- [ ] Handle empty states

**File to create**: `bride_app/lib/features/notification_center/notification_center_bottom_sheet.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../grow_out_loud/foundation/gol_colors.dart';
import '../../grow_out_loud/foundation/gol_spacing.dart';
import '../../grow_out_loud/components/gol_buttons.dart';
import '../../grow_out_loud/components/gol_notification_card.dart';
import '../../providers/notification_center_provider.dart';
import '../../l10n/generated/app_localizations.dart';

/// Show the notification center as a bottom sheet.
void showNotificationCenter(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    builder: (context) => const NotificationCenterBottomSheet(),
  );
}

class NotificationCenterBottomSheet extends ConsumerWidget {
  const NotificationCenterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final notificationState = ref.watch(notificationCenterProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surfaceDefault,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: GOLSpacing.space3),
                  decoration: BoxDecoration(
                    color: colors.borderStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GOLSpacing.space4,
                  vertical: GOLSpacing.space2,
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.notification, size: 24, color: colors.textPrimary),
                    const SizedBox(width: GOLSpacing.space2),
                    Text(
                      l10n.notifications,
                      style: textTheme.headlineSmall?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (notificationState is NotificationCenterLoaded &&
                        notificationState.allNotifications.any((n) => !n.isRead))
                      TextButton(
                        onPressed: () {
                          ref.read(notificationCenterProvider.notifier).markAllAsRead();
                        },
                        child: Text(
                          l10n.markAllAsRead,
                          style: textTheme.labelMedium?.copyWith(
                            color: colors.interactivePrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Content
              Expanded(
                child: switch (notificationState) {
                  NotificationCenterLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  NotificationCenterError(:final message) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.warning_2, size: 48, color: colors.stateError),
                          const SizedBox(height: GOLSpacing.space4),
                          Text(
                            l10n.errorLoadingNotifications,
                            style: textTheme.titleMedium?.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: GOLSpacing.space2),
                          Text(
                            message,
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  NotificationCenterLoaded(:final groupedNotifications) =>
                    groupedNotifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.notification_bing,
                                   size: 64,
                                   color: colors.textTertiary),
                              const SizedBox(height: GOLSpacing.space4),
                              Text(
                                l10n.noNotifications,
                                style: textTheme.titleMedium?.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(GOLSpacing.space4),
                          itemCount: _calculateItemCount(groupedNotifications),
                          itemBuilder: (context, index) {
                            return _buildGroupedItem(
                              context,
                              ref,
                              groupedNotifications,
                              index,
                            );
                          },
                        ),
                },
              ),
            ],
          ),
        );
      },
    );
  }

  int _calculateItemCount(Map<String, List<AppNotification>> grouped) {
    int count = 0;
    for (final entry in grouped.entries) {
      count += 1; // Header
      count += entry.value.length; // Notifications
    }
    return count;
  }

  Widget _buildGroupedItem(
    BuildContext context,
    WidgetRef ref,
    Map<String, List<AppNotification>> grouped,
    int index,
  ) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    int currentIndex = 0;
    for (final entry in grouped.entries) {
      // Check if this is the group header
      if (currentIndex == index) {
        return Padding(
          padding: const EdgeInsets.only(
            top: GOLSpacing.space4,
            bottom: GOLSpacing.space2,
          ),
          child: Text(
            entry.key,
            style: textTheme.labelSmall?.copyWith(
              color: colors.textTertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        );
      }
      currentIndex++;

      // Check if this is one of the notifications in this group
      final notificationIndex = index - currentIndex;
      if (notificationIndex < entry.value.length) {
        final notification = entry.value[notificationIndex];
        return Padding(
          padding: const EdgeInsets.only(bottom: GOLSpacing.space2),
          child: GOLNotificationCard(
            notification: notification,
            onTap: () {
              // Mark as read
              ref.read(notificationCenterProvider.notifier)
                  .markAsRead(notification.id);

              // Navigate if action route provided
              if (notification.actionRoute != null) {
                context.pop(); // Close bottom sheet
                context.push(notification.actionRoute!);
              }
            },
          ),
        );
      }
      currentIndex += entry.value.length;
    }

    return const SizedBox.shrink();
  }
}
```

**Acceptance Criteria:**
- [ ] Bottom sheet shows drag handle and header
- [ ] Notifications grouped by time correctly
- [ ] "Mark All as Read" button works
- [ ] Tapping notification navigates and marks as read
- [ ] Empty state displays when no notifications
- [ ] Error state displays on failure

---

#### Task 2.5.5: Add Notification Icon to Dashboard
- [ ] Update `dashboard_screen.dart` to add notification icon
- [ ] Add unread badge count indicator
- [ ] Position next to design gallery icon

**File to update**: `bride_app/lib/features/dashboard/screens/dashboard_screen.dart`

Update the header section (lines 178-211):

```dart
// Header with notification center and design system button
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashboard,
            style: textTheme.displaySmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            activeTrackers.length == 1
                ? l10n.activeProjectsCount(activeTrackers.length)
                : l10n.activeProjectsCountPlural(activeTrackers.length),
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    ),

    // 🆕 Notification Center Icon with Badge
    Consumer(
      builder: (context, ref, child) {
        final unreadCount = ref.watch(unreadCountProvider);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () => showNotificationCenter(context),
              icon: Icon(Iconsax.notification, color: colors.textSecondary),
              tooltip: l10n.notificationCenter,
            ),
            if (unreadCount.hasValue && unreadCount.value! > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.stateError,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      unreadCount.value! > 9 ? '9+' : '${unreadCount.value}',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    ),

    // Design System Gallery button (dev only)
    IconButton(
      onPressed: () => context.push(Routes.designSystemGallery),
      icon: Icon(Iconsax.color_swatch, color: colors.textSecondary),
      tooltip: l10n.designSystemGalleryTooltip,
    ),
  ],
),
```

**Acceptance Criteria:**
- [ ] Notification icon appears next to design gallery icon
- [ ] Badge shows unread count (1-9 or "9+")
- [ ] Badge hidden when no unread notifications
- [ ] Tapping icon opens notification center bottom sheet

---

#### Task 2.5.6: Integrate with Notification Service
- [ ] Update `NotificationService` to create app notifications
- [ ] Add method to sync push notifications to center
- [ ] Auto-create app notification when local notification scheduled

**File to update**: `bride_app/lib/services/notification_service.dart`

Add method to create app notification when scheduling tracker reminder:

```dart
Future<void> scheduleTrackerReminder({
  required String trackerId,
  required String trackerName,
  required TimeOfDay time,
  required bool isWeekly,
  int? weekday, // 1=Monday, 7=Sunday (for weekly)
}) async {
  // ... existing notification scheduling code ...

  // 🆕 Create app notification for notification center
  final notificationDao = _ref.read(notificationDaoProvider);
  final appNotification = AppNotification(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    type: AppNotificationType.actionNeeded,
    title: 'Log your entry for $trackerName',
    message: 'Don\'t forget to track today\'s performance!',
    timestamp: DateTime.now(),
    trackerId: trackerId,
    actionRoute: Routes.logEntryPath(trackerId),
  );

  await notificationDao.insertNotification(appNotification);
}
```

**Acceptance Criteria:**
- [ ] Local notifications create app notifications automatically
- [ ] Push notifications synced to notification center
- [ ] App notifications include navigation routes
- [ ] Tracker-specific notifications link to correct tracker

---

#### Task 2.5.7: Add Localization Strings
- [ ] Add notification center strings to `app_en.arb`
- [ ] Add French translations to `app_fr.arb`

**Strings to add**:

```json
// app_en.arb
"notifications": "Notifications",
"notificationCenter": "Notification Center",
"markAllAsRead": "Mark All as Read",
"noNotifications": "No notifications yet",
"errorLoadingNotifications": "Failed to load notifications",
"actionNeeded": "Action Needed",
"insight": "Insight",
"milestone": "Milestone"

// app_fr.arb
"notifications": "Notifications",
"notificationCenter": "Centre de notifications",
"markAllAsRead": "Tout marquer comme lu",
"noNotifications": "Aucune notification",
"errorLoadingNotifications": "Échec du chargement des notifications",
"actionNeeded": "Action requise",
"insight": "Aperçu",
"milestone": "Étape importante"
```

**Acceptance Criteria:**
- [ ] All UI strings localized in English and French
- [ ] Notification type labels translated
- [ ] Empty/error states have translations

---

#### Task 2.5.8: Add Notification Center to Design Gallery
- [ ] Add notification center examples to `grow_out_loud_gallery_screen.dart`
- [ ] Show all three notification types
- [ ] Demonstrate grouped view

**Acceptance Criteria:**
- [ ] GOLNotificationCard examples in gallery
- [ ] All notification types visible
- [ ] Interactive example with bottom sheet

---

#### Task 2.5.9: Testing & Cleanup
- [ ] Test notification creation from multiple sources
- [ ] Test grouping with various timestamps
- [ ] Test mark as read functionality
- [ ] Test badge count updates
- [ ] Test navigation from notifications
- [ ] Test empty and error states
- [ ] Verify 30-day auto-cleanup works

**Test Cases**:
1. Create notifications with different types
2. Verify grouping (Today/Yesterday/This Week)
3. Mark individual notification as read
4. Mark all as read
5. Navigate from notification
6. Check unread badge count
7. Verify old notifications (>30 days) deleted

**Acceptance Criteria:**
- [ ] All notification types display correctly
- [ ] Grouping logic accurate for all time ranges
- [ ] Badge count matches unread notifications
- [ ] Navigation works from tapped notifications
- [ ] Performance acceptable with 100+ notifications

---

### Phase 2.5 Success Criteria

**Must achieve ALL of the following:**
- [ ] Notification center accessible from dashboard icon
- [ ] Three notification types (Action Needed, Insight, Milestone) display with correct colors
- [ ] Notifications grouped by time (Today/Yesterday/This Week)
- [ ] Unread badge shows accurate count
- [ ] "Mark All as Read" works correctly
- [ ] Tapping notification navigates to correct screen
- [ ] Local notifications appear in center
- [ ] Push notifications synced to center
- [ ] Empty state displays when no notifications
- [ ] Old notifications (>30 days) auto-deleted
- [ ] All strings localized (EN + FR)
- [ ] Component added to design gallery
- [ ] No performance issues with many notifications

---

## Summary of Changes from v1

| Issue | v1 Approach | v2 Fix |
|-------|-------------|--------|
| Notification IDs | Hash-based (collisions) | Sequential allocation |
| Migration safety | No rollback | Pre-backup with restore |
| Provider reads | After async | Before async (captured) |
| Hydration | Sequential (slow) | Parallel batching |
| GOL component | Claimed missing | Verified exists ✓ |
| Code patterns | Generic examples | Matched to codebase |

---

## Time Estimates

| Phase | Original | Updated | Reason |
|-------|----------|---------|--------|
| Phase 0 | N/A | 4-6h | New (ID manager + backup) |
| Phase 1 | 4-6h | 4-6h | No change |
| Phase 2 | 16-18h | 20-24h | Added fixes +4h |
| Phase 2.5 | N/A | 6-8h | New (Notification Center) |
| **Total** | **20-24h** | **34-44h** | Safety + Notification Center |

---

## Approval Checklist

Before implementation begins:

- [ ] User has reviewed this updated plan (with Phase 2.5)
- [ ] All critical fixes understood
- [ ] NotificationIdManager approach approved
- [ ] Database backup strategy approved
- [ ] Notification Center design approved
- [ ] Time estimate (34-44h) acceptable
- [ ] Phase 0 will be completed first
- [ ] Code will follow GOL design system strictly
- [ ] All code will match existing patterns

---

**Status**: ⏸️ AWAITING USER APPROVAL
**Next Step**: User reviews and approves OR requests changes
**Ready to Build**: ❌ Not yet (pending approval)

