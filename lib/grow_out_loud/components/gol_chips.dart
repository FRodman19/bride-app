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
