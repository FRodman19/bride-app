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

/// Shows a toast/snackbar message from the top.
///
/// Screen 29: Success Toast
/// - Auto-dismiss after 2-3 seconds
/// - Tap to dismiss early
/// - Appears from top of screen
/// - Outlined design with colored icons (no solid backgrounds)
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
  final textTheme = Theme.of(context).textTheme;

  // Get icon color based on variant
  final IconData icon;
  final Color iconColor;

  switch (variant) {
    case GOLToastVariant.success:
      icon = Iconsax.tick_circle5;
      iconColor = colors.stateSuccess;
    case GOLToastVariant.warning:
      icon = Iconsax.warning_25;
      iconColor = colors.stateWarning;
    case GOLToastVariant.error:
      icon = Iconsax.close_circle5;
      iconColor = colors.stateError;
    case GOLToastVariant.info:
      icon = Iconsax.info_circle5;
      iconColor = colors.interactivePrimary;
  }

  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + GOLSpacing.space4,
      left: GOLSpacing.screenPaddingHorizontal,
      right: GOLSpacing.screenPaddingHorizontal,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, -20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onTap: () {
              overlayEntry.remove();
              onTap?.call();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: GOLSpacing.space4,
                vertical: GOLSpacing.space3,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceDefault,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.borderDefault,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: iconColor, size: 22),
                  const SizedBox(width: GOLSpacing.space4),
                  Expanded(
                    child: Text(
                      message,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

  // Auto-dismiss after duration
  Future.delayed(duration, () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
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

/// Shows a delete confirmation dialog following Screen 26 wireframe.
///
/// Usage:
/// ```dart
/// final confirmed = await showDeleteEntryConfirmation(
///   context: context,
///   date: 'October 26, 2024',
///   revenue: '\$450',
///   spend: '\$270',
///   profit: '+\$180',
///   isProfit: true,
/// );
/// if (confirmed) {
///   // Perform delete
/// }
/// ```
Future<bool> showDeleteEntryConfirmation({
  required BuildContext context,
  required String date,
  required String revenue,
  required String spend,
  required String profit,
  required bool isProfit,
}) async {
  final colors = Theme.of(context).extension<GOLSemanticColors>()!;
  final textTheme = Theme.of(context).textTheme;

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: colors.surfaceDefault,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(GOLSpacing.space5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colors.stateError.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.warning_2,
                  size: 28,
                  color: colors.stateError,
                ),
              ),
              const SizedBox(height: GOLSpacing.space4),

              // Title
              Text(
                'Delete Entry?',
                style: textTheme.titleLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: GOLSpacing.space4),

              // Entry Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(GOLSpacing.space4),
                decoration: BoxDecoration(
                  color: colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      date,
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: GOLSpacing.space2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _DetailItem(
                            label: 'Revenue',
                            value: revenue,
                            textTheme: textTheme,
                            colors: colors,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 32,
                          margin: const EdgeInsets.symmetric(
                            horizontal: GOLSpacing.space3,
                          ),
                          color: colors.borderDefault,
                        ),
                        Expanded(
                          child: _DetailItem(
                            label: 'Spend',
                            value: spend,
                            textTheme: textTheme,
                            colors: colors,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 32,
                          margin: const EdgeInsets.symmetric(
                            horizontal: GOLSpacing.space3,
                          ),
                          color: colors.borderDefault,
                        ),
                        Expanded(
                          child: _DetailItem(
                            label: 'Profit',
                            value: profit,
                            valueColor: isProfit
                                ? colors.stateSuccess
                                : colors.stateError,
                            textTheme: textTheme,
                            colors: colors,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: GOLSpacing.space4),

              // Warning bullets
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(GOLSpacing.space3),
                decoration: BoxDecoration(
                  color: colors.stateError.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deleting this entry will:',
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: GOLSpacing.space2),
                    _WarningBullet(
                      text: 'Remove it from history',
                      textTheme: textTheme,
                      colors: colors,
                    ),
                    _WarningBullet(
                      text: 'Recalculate total profit',
                      textTheme: textTheme,
                      colors: colors,
                    ),
                    _WarningBullet(
                      text: 'Update all reports',
                      textTheme: textTheme,
                      colors: colors,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: GOLSpacing.space3),

              // Cannot be undone warning
              Text(
                'This action cannot be undone.',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.stateError,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: GOLSpacing.space5),

              // Actions
              SizedBox(
                width: double.infinity,
                child: GOLButton(
                  label: 'Delete Entry',
                  onPressed: () => Navigator.of(context).pop(true),
                  variant: GOLButtonVariant.destructive,
                  size: GOLButtonSize.large,
                  fullWidth: true,
                ),
              ),
              const SizedBox(height: GOLSpacing.space3),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextTheme textTheme;
  final GOLSemanticColors colors;
  final TextAlign textAlign;

  const _DetailItem({
    required this.label,
    required this.value,
    this.valueColor,
    required this.textTheme,
    required this.colors,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colors.textTertiary,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: valueColor ?? colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: textAlign,
        ),
      ],
    );
  }
}

class _WarningBullet extends StatelessWidget {
  final String text;
  final TextTheme textTheme;
  final GOLSemanticColors colors;

  const _WarningBullet({
    required this.text,
    required this.textTheme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(right: GOLSpacing.space2),
            decoration: BoxDecoration(
              color: colors.stateError,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
