import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/config/app_config.dart';
import 'core/config/supabase_config.dart';
import 'grow_out_loud/foundation/gol_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/sync_provider.dart';
import 'providers/settings_provider.dart';
import 'routing/app_router.dart';
import 'routing/routes.dart';
import 'screens/design_system_home.dart';
import 'screens/grow_out_loud_gallery_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await AppConfig.init();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize timezone for local notification scheduling
  await NotificationService.initializeTimezone();

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
    // Set up notification tap handler
    NotificationService.onNotificationTap = _handleNotificationTap;
  }

  /// Handle notification tap - navigate to appropriate screen
  void _handleNotificationTap(String? payload) {
    // Check if user is authenticated before navigating
    final authState = ref.read(authProvider);
    if (authState is! AuthAuthenticated) {
      debugPrint('NotificationTap: Ignoring - user not authenticated');
      return;
    }

    final router = ref.read(routerProvider);

    switch (payload) {
      case 'daily_reminder':
        // Navigate to dashboard where user can select a tracker to log
        router.go(Routes.dashboard);
        break;
      case 'weekly_summary':
        // Navigate to dashboard to see weekly summary
        router.go(Routes.dashboard);
        break;
      default:
        // Default to dashboard
        router.go(Routes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    // Initialize sync provider to listen for connectivity changes
    ref.watch(syncProvider);

    // Initialize notification service (auto-handles auth state changes)
    ref.watch(notificationServiceProvider);

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
