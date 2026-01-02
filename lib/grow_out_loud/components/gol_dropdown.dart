import 'package:flutter/material.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_spacing.dart';

class GOLDropdownItem<T> {
  final T value;
  final String label;
  final Widget? icon;

  const GOLDropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

class GOLDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<GOLDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;

  const GOLDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: GOLSpacing.inputLabelGap),
        DropdownButtonFormField<T>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: colors.backgroundPrimary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: GOLSpacing.inputPaddingHorizontal,
              vertical: GOLSpacing.inputPaddingVertical,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: colors.borderDefault, width: 1.5),
              borderRadius: BorderRadius.circular(GOLSpacing.inlineSm),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.borderFocus, width: 2),
              borderRadius: BorderRadius.circular(GOLSpacing.inlineSm),
            ),
          ),
          icon: Icon(Icons.chevron_right, color: colors.textSecondary),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item.value,
                  child: Row(
                    children: [
                      if (item.icon != null) ...[
                        item.icon!,
                        const SizedBox(width: GOLSpacing.inlineSm),
                      ],
                      Text(item.label),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
