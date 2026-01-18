import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_spacing.dart';
import 'gol_buttons.dart';
import 'gol_grid_loader.dart';

/// Professional loading screen with optional retry button.
///
/// Displays a centered loading indicator with optional message and retry action.
/// Perfect for data fetching states in a top-tier mobile app.
///
/// Example:
/// ```dart
/// GOLLoadingScreen(
///   message: 'Loading your trackers...',
///   onRetry: () => ref.read(trackersProvider.notifier).loadTrackers(),
/// )
/// ```
class GOLLoadingScreen extends StatelessWidget {
  /// Message to display below the loader (optional)
  final String? message;

  /// Callback when retry button is tapped (optional)
  /// If null, no retry button is shown
  final VoidCallback? onRetry;

  /// Whether to show a refresh/retry button even while loading
  /// Useful for long-running operations where user might want to cancel and retry
  final bool showRetryWhileLoading;

  /// Custom icon to display above the loader (optional)
  final IconData? icon;

  const GOLLoadingScreen({
    super.key,
    this.message,
    this.onRetry,
    this.showRetryWhileLoading = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Optional custom icon
          if (icon != null) ...[
            Icon(
              icon,
              size: 48,
              color: colors.interactivePrimary,
            ),
            const SizedBox(height: GOLSpacing.space5),
          ],

          // Main loader - three dots animation
          const GOLGridLoader(size: 48),

          // Loading message
          if (message != null) ...[
            const SizedBox(height: GOLSpacing.space5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: GOLSpacing.space6),
              child: Text(
                message!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          // Retry button (shown while loading if enabled)
          if (onRetry != null && showRetryWhileLoading) ...[
            const SizedBox(height: GOLSpacing.space6),
            GOLButton(
              label: 'Refresh',
              onPressed: onRetry,
              variant: GOLButtonVariant.tertiary,
              size: GOLButtonSize.small,
              icon: const Icon(Iconsax.refresh, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact loading indicator for inline use.
///
/// Smaller version for use within cards, list items, etc.
class GOLLoadingIndicator extends StatelessWidget {
  /// Message to display next to the loader (optional)
  final String? message;

  /// Size of the loading indicator
  final double size;

  const GOLLoadingIndicator({
    super.key,
    this.message,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    if (message == null) {
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colors.interactivePrimary),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(colors.interactivePrimary),
          ),
        ),
        const SizedBox(width: GOLSpacing.space3),
        Text(
          message!,
          style: textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Professional loading overlay for full-screen loading states.
///
/// Displays a semi-transparent overlay with centered loader.
/// Use for blocking operations that prevent user interaction.
class GOLLoadingOverlay extends StatelessWidget {
  /// Message to display below the loader (optional)
  final String? message;

  /// Whether the overlay is currently visible
  final bool isLoading;

  /// The child widget to show when not loading
  final Widget child;

  const GOLLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;

    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: colors.backgroundPrimary.withValues(alpha: 0.8),
            child: GOLLoadingScreen(message: message),
          ),
      ],
    );
  }
}
