import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/connectivity_provider.dart';

/// Offline banner widget that shows when the device is offline.
///
/// Displays at the top of the screen with:
/// - Offline status indicator
/// - Smooth animated transitions
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityState = ref.watch(connectivityProvider);
    final l10n = AppLocalizations.of(context)!;

    // Only show when offline
    final shouldShow = connectivityState == ConnectivityState.offline;

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
              l10n: l10n,
            )
          : const SizedBox.shrink(key: ValueKey('banner_hidden')),
    );
  }
}

class _BannerContent extends StatelessWidget {
  final AppLocalizations l10n;

  const _BannerContent({
    super.key,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: GOLSpacing.space4,
        vertical: GOLSpacing.space2,
      ),
      color: colors.stateWarning.withValues(alpha: 0.15),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(
              Iconsax.wifi_square,
              size: 16,
              color: colors.stateWarning,
            ),
            const SizedBox(width: GOLSpacing.space2),
            Expanded(
              child: Text(
                l10n.offlineMode,
                style: textTheme.labelMedium?.copyWith(
                  color: colors.stateWarning,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
