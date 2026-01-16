import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_radius.dart';
import '../foundation/gol_spacing.dart';

enum GOLChipVariant { filter, input, status }

class GOLChip extends StatelessWidget {
  final String label;
  final GOLChipVariant variant;
  final bool selected;
  final VoidCallback? onDeleted;

  const GOLChip({
    super.key,
    required this.label,
    this.variant = GOLChipVariant.filter,
    this.selected = false,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final scheme = _chipStyle(colors);

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: scheme.background,
        borderRadius: BorderRadius.circular(GOLRadius.full),
        border: scheme.border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: scheme.textColor),
          ),
          if (variant == GOLChipVariant.input && onDeleted != null) ...[
            const SizedBox(width: GOLSpacing.space2),
            GestureDetector(
              onTap: onDeleted,
              child: Icon(Iconsax.close_circle, size: 16, color: scheme.textColor),
            ),
          ],
        ],
      ),
    );
  }

  _ChipScheme _chipStyle(GOLSemanticColors colors) {
    switch (variant) {
      case GOLChipVariant.filter:
        if (selected) {
          return _ChipScheme(
            background: colors.accentSubtle,
            border: Border.all(color: colors.interactivePrimary),
            textColor: colors.textAccent,
          );
        }
        return _ChipScheme(
          background: Colors.transparent,
          border: Border.all(color: colors.borderDefault),
          textColor: colors.textPrimary,
        );
      case GOLChipVariant.input:
        return _ChipScheme(
          background: colors.backgroundTertiary,
          border: Border.all(color: Colors.transparent),
          textColor: colors.textPrimary,
        );
      case GOLChipVariant.status:
        return _ChipScheme(
          background: colors.accentSubtle,
          border: Border.all(color: Colors.transparent),
          textColor: colors.textAccent,
        );
    }
  }
}

class _ChipScheme {
  final Color background;
  final Border? border;
  final Color textColor;

  const _ChipScheme({
    required this.background,
    required this.border,
    required this.textColor,
  });
}

/// A selectable chip for multi-select scenarios (platforms, goals, tags).
///
/// When selected:
/// - Background: accent color with transparency
/// - Border: accent/gold color (2px)
/// - Text: accent/gold color with bold weight
///
/// When unselected:
/// - Background: surfaceRaised
/// - Border: borderDefault (1px)
/// - Text: textPrimary with normal weight
///
/// Usage:
/// ```dart
/// GOLSelectableChip(
///   label: 'Facebook',
///   selected: _selectedPlatforms.contains('Facebook'),
///   onTap: () => _togglePlatform('Facebook'),
/// )
/// ```
class GOLSelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  const GOLSelectableChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: GOLSpacing.space3,
          vertical: GOLSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: selected
              ? colors.interactivePrimary.withValues(alpha: 0.15)
              : colors.surfaceRaised,
          borderRadius: BorderRadius.circular(GOLRadius.full),
          border: Border.all(
            color: selected ? colors.interactivePrimary : colors.borderDefault,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? colors.interactivePrimary : colors.textSecondary,
              ),
              const SizedBox(width: GOLSpacing.space1),
            ],
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: selected ? colors.interactivePrimary : colors.textPrimary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A group of selectable chips for easy multi-select.
///
/// Usage:
/// ```dart
/// GOLSelectableChipGroup(
///   items: ['Facebook', 'TikTok', 'Instagram'],
///   selectedItems: _selectedPlatforms,
///   onChanged: (selected) => setState(() => _selectedPlatforms = selected),
/// )
/// ```
class GOLSelectableChipGroup extends StatelessWidget {
  final List<String> items;
  final Set<String> selectedItems;
  final ValueChanged<Set<String>> onChanged;
  final bool singleSelect;

  const GOLSelectableChipGroup({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.singleSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: GOLSpacing.space2,
      runSpacing: GOLSpacing.space2,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        return GOLSelectableChip(
          label: item,
          selected: isSelected,
          onTap: () {
            Set<String> newSelection;
            if (singleSelect) {
              // Single select mode: replace selection with new item
              newSelection = {item};
            } else {
              // Multi select mode: toggle item in selection
              newSelection = Set<String>.from(selectedItems);
              if (isSelected) {
                newSelection.remove(item);
              } else {
                newSelection.add(item);
              }
            }
            onChanged(newSelection);
          },
        );
      }).toList(),
    );
  }
}
