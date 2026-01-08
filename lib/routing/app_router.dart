import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../l10n/generated/app_localizations.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/tracker/screens/trackers_list_screen.dart';
import '../features/tracker/screens/create_tracker_screen.dart';
import '../features/tracker/screens/tracker_hub_screen.dart';
import '../features/tracker/screens/log_entry_screen.dart';
import '../features/tracker/screens/entry_detail_screen.dart';
import '../features/tracker/screens/edit_entry_screen.dart';
import '../features/tracker/screens/entry_history_screen.dart';
import '../features/tracker/screens/archive_screen.dart';
import '../features/tracker/screens/edit_tracker_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../screens/grow_out_loud_gallery_screen.dart';
import '../providers/auth_provider.dart';
import 'routes.dart';

// Placeholder screens - will be replaced with actual implementations
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title - Coming Soon')),
    );
  }
}

/// Provider for the app router.
///
/// Usage:
/// ```dart
/// MaterialApp.router(
///   routerConfig: ref.watch(routerProvider),
/// )
/// ```
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: Routes.dashboard,
    debugLogDiagnostics: true,

    // Redirect based on auth state
    redirect: (context, state) {
      final isLoading = authState is AuthLoading;
      final isAuthenticated = authState is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation == Routes.login ||
          state.matchedLocation == Routes.signUp ||
          state.matchedLocation == Routes.forgotPassword;

      // Still loading - don't redirect
      if (isLoading) return null;

      // Not authenticated and not on auth route - go to login
      if (!isAuthenticated && !isAuthRoute) {
        return Routes.login;
      }

      // Authenticated and on auth route - go to dashboard
      if (isAuthenticated && isAuthRoute) {
        return Routes.dashboard;
      }

      return null;
    },

    routes: [
      // Auth routes
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.signUp,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return _MainShell(child: child);
        },
        routes: [
          // Dashboard
          GoRoute(
            path: Routes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),

          // Trackers list
          GoRoute(
            path: Routes.trackers,
            name: 'trackers',
            builder: (context, state) => const TrackersListScreen(),
          ),

          // Settings
          GoRoute(
            path: Routes.settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'platforms',
                name: 'platform-management',
                builder: (context, state) => const _PlaceholderScreen('Platform Management'),
              ),
            ],
          ),
        ],
      ),

      // Create tracker (full screen, not in shell - no bottom nav)
      GoRoute(
        path: Routes.createTracker,
        name: 'create-tracker',
        builder: (context, state) => const CreateTrackerScreen(),
      ),

      // Tracker hub (full screen, not in shell)
      GoRoute(
        path: '/trackers/:id',
        name: 'tracker-hub',
        builder: (context, state) {
          final trackerId = state.pathParameters['id']!;
          return TrackerHubScreen(trackerId: trackerId);
        },
        routes: [
          // Edit tracker
          GoRoute(
            path: 'edit',
            name: 'edit-tracker',
            builder: (context, state) {
              final trackerId = state.pathParameters['id']!;
              return EditTrackerScreen(trackerId: trackerId);
            },
          ),

          // Entry routes
          GoRoute(
            path: 'entries/log',
            name: 'log-entry',
            builder: (context, state) {
              final trackerId = state.pathParameters['id']!;
              return LogEntryScreen(trackerId: trackerId);
            },
          ),
          GoRoute(
            path: 'entries/history',
            name: 'entry-history',
            builder: (context, state) {
              final trackerId = state.pathParameters['id']!;
              return EntryHistoryScreen(trackerId: trackerId);
            },
          ),
          GoRoute(
            path: 'entries/bulk',
            name: 'bulk-edit',
            builder: (context, state) {
              final trackerId = state.pathParameters['id']!;
              return _PlaceholderScreen('Bulk Edit: $trackerId');
            },
          ),
          GoRoute(
            path: 'entries/:entryId',
            name: 'entry-detail',
            builder: (context, state) {
              final trackerId = state.pathParameters['id']!;
              final entryId = state.pathParameters['entryId']!;
              return EntryDetailScreen(trackerId: trackerId, entryId: entryId);
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'edit-entry',
                builder: (context, state) {
                  final trackerId = state.pathParameters['id']!;
                  final entryId = state.pathParameters['entryId']!;
                  return EditEntryScreen(trackerId: trackerId, entryId: entryId);
                },
              ),
            ],
          ),

          // Post routes
          GoRoute(
            path: 'posts',
            name: 'posts',
            builder: (context, state) {
              final trackerId = state.pathParameters['id']!;
              return _PlaceholderScreen('Posts: $trackerId');
            },
            routes: [
              GoRoute(
                path: 'add',
                name: 'add-post',
                builder: (context, state) {
                  final trackerId = state.pathParameters['id']!;
                  return _PlaceholderScreen('Add Post: $trackerId');
                },
              ),
              GoRoute(
                path: ':postId/edit',
                name: 'edit-post',
                builder: (context, state) {
                  final trackerId = state.pathParameters['id']!;
                  final postId = state.pathParameters['postId']!;
                  return _PlaceholderScreen('Edit Post: $postId (Tracker: $trackerId)');
                },
              ),
            ],
          ),
        ],
      ),

      // Archive (full screen)
      GoRoute(
        path: Routes.archive,
        name: 'archive',
        builder: (context, state) => const ArchiveScreen(),
      ),

      // Design System Gallery (dev/debug only - remove in production)
      GoRoute(
        path: Routes.designSystemGallery,
        name: 'design-system-gallery',
        builder: (context, state) => const GrowOutLoudGalleryScreen(),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
});

/// Main shell with bottom navigation.
class _MainShell extends ConsumerWidget {
  final Widget child;
  const _MainShell({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        enableFeedback: false, // No fancy animations per design system
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.category),
            activeIcon: const Icon(Iconsax.category5),
            label: l10n.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.folder_2),
            activeIcon: const Icon(Iconsax.folder_25),
            label: l10n.projects,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.setting_2),
            activeIcon: const Icon(Iconsax.setting_25),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(Routes.trackers)) return 1;
    if (location.startsWith(Routes.settings)) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(Routes.dashboard);
        break;
      case 1:
        context.go(Routes.trackers);
        break;
      case 2:
        context.go(Routes.settings);
        break;
    }
  }
}
