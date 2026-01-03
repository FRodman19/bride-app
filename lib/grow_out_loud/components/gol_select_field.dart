import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_radius.dart';
import '../foundation/gol_spacing.dart';
import 'gol_dividers.dart';

/// A select field that opens a bottom sheet for selection.
///
/// This is the preferred pattern for dropdowns in the app - instead of
/// using native dropdowns, we use a tappable field that opens a bottom
/// sheet with a list of options.
///
/// Features:
/// - Outline-only styling (transparent background, border)
/// - Opens a bottom sheet with options
/// - Supports leading icon and trailing badge
/// - Thin grey divider in bottom sheet
///
/// Usage:
/// ```dart
/// GOLSelectField<String>(
///   label: 'Currency',
///   value: selectedCurrency,
///   displayText: getCurrencyName(selectedCurrency),
///   leadingIcon: Iconsax.dollar_circle,
///   trailingBadge: selectedCurrency, // Shows "USD" badge
///   onTap: () => _showCurrencyPicker(context),
/// )
/// ```
class GOLSelectField extends StatelessWidget {
  /// Label shown above the field
  final String label;

  /// Display text shown in the field (e.g., currency name)
  final String displayText;

  /// Optional hint text when no value is selected
  final String? hintText;

  /// Leading icon (shown on the left)
  final IconData? leadingIcon;

  /// Trailing badge text (e.g., "USD", "XAF")
  final String? trailingBadge;

  /// Called when the field is tapped
  final VoidCallback? onTap;

  /// Whether the field is enabled
  final bool enabled;

  const GOLSelectField({
    super.key,
    required this.label,
    required this.displayText,
    this.hintText,
    this.leadingIcon,
    this.trailingBadge,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final hasValue = displayText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: GOLSpacing.inputLabelGap),

        // Field
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(GOLRadius.input),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: GOLSpacing.inputPaddingHorizontal,
                vertical: GOLSpacing.inputPaddingVertical,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: enabled ? colors.borderDefault : colors.borderDefault.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(GOLRadius.input),
              ),
              child: Row(
                children: [
                  // Leading icon
                  if (leadingIcon != null) ...[
                    Icon(
                      leadingIcon,
                      color: enabled ? colors.textTertiary : colors.textTertiary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: GOLSpacing.space3),
                  ],

                  // Display text or hint
                  Expanded(
                    child: Text(
                      hasValue ? displayText : (hintText ?? ''),
                      style: textTheme.bodyMedium?.copyWith(
                        color: hasValue
                            ? (enabled ? colors.textPrimary : colors.textTertiary)
                            : colors.textTertiary,
                      ),
                    ),
                  ),

                  // Trailing badge
                  if (trailingBadge != null) ...[
                    GOLBadge(text: trailingBadge!),
                    const SizedBox(width: GOLSpacing.space2),
                  ],

                  // Arrow icon
                  Icon(
                    Iconsax.arrow_down_1,
                    size: 16,
                    color: enabled ? colors.textTertiary : colors.textTertiary.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A badge widget for displaying code/abbreviation in fields.
///
/// Used for currency codes, country codes, etc.
///
/// Usage:
/// ```dart
/// GOLBadge(text: 'USD')
/// GOLBadge(text: 'XAF')
/// ```
class GOLBadge extends StatelessWidget {
  final String text;

  const GOLBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GOLSpacing.space2,
        vertical: GOLSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: colors.interactivePrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: textTheme.labelMedium?.copyWith(
          color: colors.interactivePrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Helper to show a standard bottom sheet picker.
///
/// This provides consistent styling for all bottom sheet pickers:
/// - Handle bar at top
/// - Title
/// - Thin grey divider
/// - List of options
///
/// Usage:
/// ```dart
/// showGOLBottomSheetPicker<String>(
///   context: context,
///   title: 'Select Currency',
///   items: currencies,
///   selectedValue: currentCurrency,
///   itemBuilder: (currency, isSelected) => ListTile(...),
///   onSelected: (currency) => setState(() => _currency = currency),
/// );
/// ```
Future<T?> showGOLBottomSheetPicker<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required T? selectedValue,
  required Widget Function(T item, bool isSelected) itemBuilder,
  required ValueChanged<T> onSelected,
}) {
  final colors = Theme.of(context).extension<GOLSemanticColors>()!;
  final textTheme = Theme.of(context).textTheme;

  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: colors.surfaceDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: GOLSpacing.space3),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.borderDefault,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(GOLSpacing.space4),
              child: Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Thin grey divider
            const GOLDivider(),

            // Items list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item == selectedValue;
                  return InkWell(
                    onTap: () {
                      onSelected(item);
                      Navigator.pop(context, item);
                    },
                    child: itemBuilder(item, isSelected),
                  );
                },
              ),
            ),

            const SizedBox(height: GOLSpacing.space4),
          ],
        ),
      );
    },
  );
}
