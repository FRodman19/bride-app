import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/connectivity_provider.dart';
import '../../../providers/sync_provider.dart';

/// Offline banner widget that shows when the device is offline.
///
/// Displays at the top of the screen with:
/// - Offline status indicator
/// - Pending changes count (if any)
/// - Sync status when syncing
/// - Tap-to-sync when pending items exist
/// - Smooth animated transitions
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityState = ref.watch(connectivityProvider);
    final syncState = ref.watch(syncProvider);
    final l10n = AppLocalizations.of(context)!;

    // Determine if banner should be visible
    final shouldShow = connectivityState == ConnectivityState.offline ||
        syncState.hasPending ||
        syncState.status == SyncStatus.syncing ||
        syncState.status == SyncStatus.error;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: shouldShow
          ? _BannerContent(
              key: const ValueKey('banner_visible'),
              connectivityState: connectivityState,
              syncState: syncState,
              l10n: l10n,
              onRetry: () => ref.read(syncProvider.notifier).processPendingSync(),
            )
          : const SizedBox.shrink(key: ValueKey('banner_hidden')),
    );
  }
}

class _BannerContent extends StatelessWidget {
  final ConnectivityState connectivityState;
  final SyncState syncState;
  final AppLocalizations l10n;
  final VoidCallback onRetry;

  const _BannerContent({
    super.key,
    required this.connectivityState,
    required this.syncState,
    required this.l10n,
    required this.onRetry,
  });

  /// Convert technical error messages to user-friendly messages.
  String _getUserFriendlyError(String? error) {
    if (error == null) return l10n.unknownError;

    final lowerError = error.toLowerCase();

    // Network errors
    if (lowerError.contains('socket') ||
        lowerError.contains('network') ||
        lowerError.contains('connection') ||
        lowerError.contains('timeout')) {
      return l10n.connectionError;
    }

    // Auth errors
    if (lowerError.contains('auth') ||
        lowerError.contains('unauthorized') ||
        lowerError.contains('permission')) {
      return l10n.somethingWentWrong;
    }

    // Generic sync error
    return l10n.syncFailed;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final isOffline = connectivityState == ConnectivityState.offline;
    final isSyncing = syncState.status == SyncStatus.syncing;
    final hasError = syncState.status == SyncStatus.error;
    final hasPending = syncState.hasPending;
    final isOnline = connectivityState == ConnectivityState.online;

    // Determine banner color and content
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String message;
    bool canTapToSync = false;

    if (isOffline) {
      backgroundColor = colors.stateWarning.withValues(alpha: 0.15);
      textColor = colors.stateWarning;
      icon = Iconsax.wifi_square;
      message = hasPending
          ? l10n.offlineWithPending(syncState.pendingCount)
          : l10n.offlineMode;
    } else if (isSyncing) {
      backgroundColor = colors.interactivePrimary.withValues(alpha: 0.1);
      textColor = colors.interactivePrimary;
      icon = Iconsax.refresh;
      // Show progress if available
      message = syncState.isSyncingWithProgress
          ? '${l10n.syncing} ${syncState.syncProgressText}'
          : l10n.syncing;
    } else if (hasError) {
      backgroundColor = colors.stateError.withValues(alpha: 0.1);
      textColor = colors.stateError;
      icon = Iconsax.warning_2;
      message = l10n.syncFailed;
      canTapToSync = isOnline; // Can retry if online
    } else if (hasPending) {
      backgroundColor = colors.stateWarning.withValues(alpha: 0.1);
      textColor = colors.stateWarning;
      icon = Iconsax.cloud_change;
      message = l10n.pendingChanges(syncState.pendingCount);
      canTapToSync = isOnline; // Can sync if online with pending changes
    } else {
      return const SizedBox.shrink();
    }

    final bannerContent = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: GOLSpacing.space4,
        vertical: GOLSpacing.space2,
      ),
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (isSyncing)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            else
              Icon(icon, size: 16, color: textColor),
            const SizedBox(width: GOLSpacing.space2),
            Expanded(
              child: Text(
                message,
                style: textTheme.labelMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (hasError)
              GestureDetector(
                onTap: () {
                  // Check context is still valid before showing snackbar
                  if (!context.mounted) return;
                  // Show user-friendly error with retry option
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_getUserFriendlyError(syncState.lastError)),
                      action: SnackBarAction(
                        label: l10n.retry,
                        onPressed: onRetry,
                      ),
                    ),
                  );
                },
                child: Icon(
                  Iconsax.info_circle,
                  size: 16,
                  color: textColor,
                ),
              )
            else if (canTapToSync)
              Icon(
                Iconsax.refresh,
                size: 16,
                color: textColor.withValues(alpha: 0.7),
              ),
          ],
        ),
      ),
    );

    // Wrap with InkWell if tap-to-sync is enabled
    if (canTapToSync) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onRetry,
          child: bannerContent,
        ),
      );
    }

    return bannerContent;
  }
}

/// A scaffold wrapper that includes the offline banner.
///
/// Use this instead of Scaffold for screens that should show offline status.
class OfflineAwareScaffold extends ConsumerWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool extendBodyBehindAppBar;

  const OfflineAwareScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: body),
        ],
      ),
    );
  }
}
