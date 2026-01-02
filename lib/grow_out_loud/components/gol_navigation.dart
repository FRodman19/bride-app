import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_radius.dart';
import '../foundation/gol_spacing.dart';
import '../foundation/gol_typography.dart';

class GOLBottomNavPreview extends StatelessWidget {
  const GOLBottomNavPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colors.backgroundPrimary,
        border: Border(top: BorderSide(color: colors.borderDefault)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, -1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          _NavItem(
            icon: Iconsax.home_2,
            label: 'Home',
            active: true,
          ),
          _NavItem(icon: Iconsax.clipboard_text, label: 'Tasks'),
          _NavItem(icon: Iconsax.notification, label: 'Alerts'),
          _NavItem(icon: Iconsax.user, label: 'Profile'),
        ],
      ),
    );
  }
}

class GOLAppBarPreview extends StatelessWidget {
  const GOLAppBarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: GOLSpacing.space4),
      decoration: BoxDecoration(
        color: colors.backgroundPrimary,
        border: Border(bottom: BorderSide(color: colors.borderDefault)),
      ),
      child: Row(
        children: [
          Icon(Iconsax.arrow_left, size: 24, color: colors.textPrimary),
          const SizedBox(width: GOLSpacing.space3),
          Expanded(
            child: Text(
              'Section Title',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Icon(Iconsax.search_normal, size: 20, color: colors.textSecondary),
          const SizedBox(width: GOLSpacing.space2),
          Icon(Iconsax.more, size: 20, color: colors.textSecondary),
        ],
      ),
    );
  }
}

class GOLTabBarPreview extends StatelessWidget {
  const GOLTabBarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final tabs = ['Colors', 'Type', 'Components'];

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colors.backgroundPrimary,
        border: Border(bottom: BorderSide(color: colors.borderDefault)),
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) {
            final active = index == 0;
            return Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    tabs[index],
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: active
                              ? colors.textPrimary
                              : colors.textSecondary,
                        ),
                  ),
                  if (active)
                    Positioned(
                      bottom: 0,
                      left: 16,
                      right: 16,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: colors.interactivePrimary,
                          borderRadius: BorderRadius.circular(GOLRadius.xs),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final color = active ? colors.textAccent : colors.textSecondary;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(label, style: GOLTypography.micro(color)),
        ],
      ),
    );
  }
}
