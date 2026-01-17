import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/config/app_config.dart';
import 'core/config/supabase_config.dart';
import 'grow_out_loud/foundation/gol_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/tracker_provider.dart';
import 'routing/app_router.dart';
import 'routing/routes.dart';
import 'screens/design_system_home.dart';
import 'screens/grow_out_loud_gallery_screen.dart';
import 'services/fcm_service.dart';
import 'services/notification_service.dart';
import 'services/notification_id_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flutter automatically uses the device's maximum refresh rate
  // No explicit enablement needed - Pixel 9 Pro XL will use 120Hz by default
  if (kDebugMode) {
    debugPrint('Display: Flutter will use device maximum refresh rate (120Hz on Pixel 9 Pro XL)');
  }

  // Set up frame timing monitor AFTER first frame (avoid rebuild loops)
  if (kDebugMode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const targetRefreshRate = 120; // Hz
      const targetFrameTime = 1000000 ~/ targetRefreshRate; // 8333 microseconds
      int frameCheckCounter = 0;

      SchedulerBinding.instance.platformDispatcher.onReportTimings = (timings) {
        // Sample every 120 frames (~1 second at 120Hz) to reduce overhead
        if (++frameCheckCounter % 120 != 0) return;

        if (timings.isNotEmpty) {
          final avgFrameTime = timings.map((t) => t.totalSpan.inMicroseconds).reduce((a, b) => a + b) / timings.length;
          if (avgFrameTime > targetFrameTime) {
            debugPrint('Performance: Slow frame detected (${(avgFrameTime / 1000).toStringAsFixed(1)}ms, target: ${targetFrameTime / 1000}ms for ${targetRefreshRate}Hz)');
          }
        }
      };
    });
  }

  // Load environment variables
  await AppConfig.init();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up FCM background message handler (must be after Firebase.initializeApp)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize timezone for local notification scheduling
  await NotificationService.initializeTimezone();

  // Initialize NotificationIdManager BEFORE app runs (CRITICAL for Phase 7.5)
  await NotificationIdManager.initialize();

  // Initialize Supabase
  await SupabaseConfig.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Set up local notification tap handler
    NotificationService.onNotificationTap = _handleLocalNotificationTap;
    // Set up FCM notification tap handler
    FCMService.onNotificationTap = _handleFCMNotificationTap;
    // Handle cold start notification (app opened from notification)
    _handleColdStartNotification();
  }

  /// Handle notification that launched the app (cold start)
  Future<void> _handleColdStartNotification() async {
    try {
      final notificationService = ref.read(notificationServiceProvider);
      final launchDetails = await notificationService.getNotificationAppLaunchDetails();

      if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
        final payload = launchDetails.notificationResponse?.payload;
        debugPrint('ColdStart: App launched from notification with payload: $payload');

        // Check current auth state immediately
        final currentAuthState = ref.read(authProvider);
        if (currentAuthState is AuthAuthenticated) {
          debugPrint('ColdStart: Auth ready, navigating with payload: $payload');
          _handleLocalNotificationTap(payload);
        } else {
          // If not authenticated yet, listen for auth state changes
          debugPrint('ColdStart: Waiting for authentication...');
          ref.listen<AuthState>(
            authProvider,
            (previous, next) {
              if (next is AuthAuthenticated && previous is! AuthAuthenticated) {
                debugPrint('ColdStart: Auth ready, navigating with payload: $payload');
                _handleLocalNotificationTap(payload);
              }
            },
          );
        }
      }
    } catch (e) {
      debugPrint('ColdStart: Error checking launch details: $e');
    }
  }

  /// Handle local notification tap - navigate to appropriate screen
  void _handleLocalNotificationTap(String? payload) {
    // Check if user is authenticated before navigating
    final authState = ref.read(authProvider);
    if (authState is! AuthAuthenticated) {
      debugPrint('NotificationTap: Ignoring - user not authenticated');
      return;
    }

    final router = ref.read(routerProvider);

    // Handle tracker-specific notifications (format: "tracker:trackerId")
    if (payload != null && payload.startsWith('tracker:')) {
      final trackerId = payload.substring(8).trim(); // Remove "tracker:" prefix

      // Validate tracker ID format (UUID v4 pattern)
      final uuidPattern = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        caseSensitive: false,
      );

      if (trackerId.isNotEmpty && uuidPattern.hasMatch(trackerId)) {
        debugPrint('NotificationTap: Navigating to log entry for tracker: $trackerId');

        // Check if tracker exists before navigation
        final trackersState = ref.read(trackersProvider);
        if (trackersState is TrackersLoaded) {
          final trackerExists = trackersState.trackers.any((t) => t.id == trackerId);
          if (!trackerExists) {
            debugPrint('NotificationTap: Tracker not found: $trackerId');
            // Navigate to dashboard without toast since we don't have context here
            // The error route will handle displaying an appropriate message
            router.go(Routes.dashboard);
            return;
          }
        }

        try {
          router.go(Routes.logEntryPath(trackerId));
        } catch (e) {
          debugPrint('NotificationTap: Navigation failed: $e');
          router.go(Routes.dashboard);
        }
        return;
      } else {
        debugPrint('NotificationTap: Invalid tracker ID format: $trackerId');
        router.go(Routes.dashboard);
        return;
      }
    }

    // Handle legacy notification types or fallback to dashboard
    switch (payload) {
      case 'daily_reminder':
      case 'weekly_summary':
      default:
        debugPrint('NotificationTap: Navigating to dashboard');
        router.go(Routes.dashboard);
    }
  }

  /// Handle FCM notification tap - navigate to appropriate screen
  void _handleFCMNotificationTap(RemoteMessage message) {
    // Check if user is authenticated before navigating
    final authState = ref.read(authProvider);
    if (authState is! AuthAuthenticated) {
      debugPrint('FCMNotificationTap: Ignoring - user not authenticated');
      return;
    }

    final router = ref.read(routerProvider);
    final data = message.data;

    // Navigate based on notification type
    if (data['type'] == 'daily_reminder' && data['tracker_id'] != null) {
      final trackerId = data['tracker_id'] as String;

      // Validate tracker ID format (UUID v4 pattern)
      final uuidPattern = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        caseSensitive: false,
      );

      if (uuidPattern.hasMatch(trackerId)) {
        debugPrint('FCMNotificationTap: Navigating to tracker: $trackerId');

        // Check if tracker exists before navigation
        final trackersState = ref.read(trackersProvider);
        if (trackersState is TrackersLoaded) {
          final trackerExists = trackersState.trackers.any((t) => t.id == trackerId);
          if (!trackerExists) {
            debugPrint('FCMNotificationTap: Tracker not found: $trackerId');
            // Navigate to dashboard without toast since we don't have context here
            // The error route will handle displaying an appropriate message
            router.go(Routes.dashboard);
            return;
          }
        }

        try {
          router.go(Routes.logEntryPath(trackerId));
        } catch (e) {
          debugPrint('FCMNotificationTap: Navigation failed: $e');
          router.go(Routes.dashboard);
        }
      } else {
        debugPrint('FCMNotificationTap: Invalid tracker ID format: $trackerId');
        router.go(Routes.dashboard);
      }
    } else {
      // Default to dashboard
      debugPrint('FCMNotificationTap: Navigating to dashboard');
      router.go(Routes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    // Initialize notification service (auto-handles auth state changes)
    ref.watch(notificationServiceProvider);

    // Initialize FCM service (auto-handles auth state changes)
    ref.watch(fcmServiceProvider);

    // Get theme mode from settings
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'Performance Tracker',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: GOLThemeData.light(),
      darkTheme: GOLThemeData.dark(),
      themeMode: settings.themeMode,
      // Localization
      locale: settings.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

/// Standalone design system gallery app for development
class DesignSystemApp extends StatelessWidget {
  const DesignSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grow Out Loud Design System',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const DesignSystemHome(),
        if (kDebugMode)
          '/gallery': (context) => const GrowOutLoudGalleryScreen(),
      },
      theme: GOLThemeData.light(),
      darkTheme: GOLThemeData.dark(),
      themeMode: ThemeMode.system,
    );
  }
}
