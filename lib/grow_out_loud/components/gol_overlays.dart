import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_spacing.dart';
import 'gol_buttons.dart';

Future<void> showGOLDialog(BuildContext context) {
  final colors = Theme.of(context).extension<GOLSemanticColors>()!;
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm action'),
        content: Text(
          'This dialog uses Grow Out Loud modal tokens and button styles.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: colors.textSecondary),
        ),
        actions: [
          GOLButton(
            label: 'Cancel',
            variant: GOLButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: GOLSpacing.space2),
          GOLButton(
            label: 'Confirm',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

Future<void> showGOLBottomSheet(BuildContext context) {
  final colors = Theme.of(context).extension<GOLSemanticColors>()!;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: false,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: GOLSpacing.space4,
          vertical: GOLSpacing.space6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.borderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: GOLSpacing.space6),
            Text('Bottom Sheet', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: GOLSpacing.space2),
            Text(
              'Surface-raised panel with the standard top radius.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: GOLSpacing.space6),
            GOLButton(
              label: 'Close',
              variant: GOLButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pop(),
              fullWidth: true,
            ),
          ],
        ),
      );
    },
  );
}

/// Toast variants for different feedback types.
enum GOLToastVariant {
  /// Default info toast (blue/neutral)
  info,

  /// Success toast (green) - Screen 29
  success,

  /// Warning toast (amber/yellow)
  warning,

  /// Error toast (red)
  error,
}

/// Shows a toast/snackbar message.
///
/// Screen 29: Success Toast
/// - Auto-dismiss after 2-3 seconds
/// - Tap to dismiss early
/// - Overlays on current screen
///
/// Usage:
/// ```dart
/// showGOLToast(context, 'Project created successfully', variant: GOLToastVariant.success);
/// showGOLToast(context, 'Something went wrong', variant: GOLToastVariant.error);
/// ```
void showGOLToast(
  BuildContext context,
  String message, {
  GOLToastVariant variant = GOLToastVariant.info,
  Duration duration = const Duration(seconds: 3),
  VoidCallback? onTap,
}) {
  final colors = Theme.of(context).extension<GOLSemanticColors>()!;

  // Get icon and background color based on variant
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  switch (variant) {
    case GOLToastVariant.success:
      icon = Iconsax.tick_circle;
      backgroundColor = colors.stateSuccess;
      iconColor = Colors.white;
    case GOLToastVariant.warning:
      icon = Iconsax.warning_2;
      backgroundColor = colors.stateWarning;
      iconColor = Colors.white;
    case GOLToastVariant.error:
      icon = Iconsax.close_circle;
      backgroundColor = colors.stateError;
      iconColor = Colors.white;
    case GOLToastVariant.info:
      icon = Iconsax.info_circle;
      backgroundColor = colors.surfaceRaised;
      iconColor = colors.interactivePrimary;
  }

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          onTap?.call();
        },
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: GOLSpacing.space3),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: variant == GOLToastVariant.info
                      ? colors.textPrimary
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: GOLSpacing.screenPaddingHorizontal,
        vertical: GOLSpacing.space4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: GOLSpacing.space4,
        vertical: GOLSpacing.space3,
      ),
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

/// Shows a success toast - convenience wrapper.
void showSuccessToast(BuildContext context, String message) {
  showGOLToast(context, message, variant: GOLToastVariant.success);
}

/// Shows an error toast - convenience wrapper.
void showErrorToast(BuildContext context, String message) {
  showGOLToast(context, message, variant: GOLToastVariant.error);
}

/// Shows a warning toast - convenience wrapper.
void showWarningToast(BuildContext context, String message) {
  showGOLToast(context, message, variant: GOLToastVariant.warning);
}
