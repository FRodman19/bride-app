import 'package:flutter/material.dart';

import 'spacing.dart';
import 'theme.dart';

class DSNavItem {
  const DSNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class DSBottomNavBar extends StatelessWidget {
  const DSBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<DSNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? DSColors.surfaceDark : DSColors.white;
    final inactive = isDark ? DSColors.neutral300 : DSColors.neutral500;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DSSpacing.horizontalPadding,
        vertical: DSSpacing.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isActive = index == currentIndex;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 22,
                      color: isActive ? DSColors.orange500 : inactive,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                isActive ? DSColors.orange500 : inactive,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class DSSidebar extends StatelessWidget {
  const DSSidebar({super.key, required this.items});

  final List<DSNavItem> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? DSColors.surfaceDark : DSColors.surfaceLight;

    return Container(
      width: 220,
      padding: const EdgeInsets.all(DSSpacing.lg),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(item.icon, size: 18),
                    const SizedBox(width: 8),
                    Text(item.label),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
