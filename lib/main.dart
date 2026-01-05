import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/config/app_config.dart';
import 'core/config/supabase_config.dart';
import 'grow_out_loud/foundation/gol_theme.dart';
import 'providers/sync_provider.dart';
import 'providers/settings_provider.dart';
import 'routing/app_router.dart';
import 'screens/design_system_home.dart';
import 'screens/grow_out_loud_gallery_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await AppConfig.init();

  // Initialize Supabase
  await SupabaseConfig.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Initialize sync provider to listen for connectivity changes
    ref.watch(syncProvider);

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
