import 'package:flutter/material.dart';

import 'theme.dart';

class DSChip extends StatelessWidget {
  const DSChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? DSColors.teal500
              : (isDark ? DSColors.surfaceDark : DSColors.neutral100),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? DSColors.neutral500 : DSColors.neutral200,
                ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? DSColors.white
                  : (isDark ? DSColors.neutral200 : DSColors.black),
            ),
          ),
        ),
      ),
    );
  }
}
