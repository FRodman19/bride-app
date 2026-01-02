import 'package:flutter/material.dart';

import 'spacing.dart';
import 'theme.dart';

enum DSCardTone { standard, elevated }

class DSCard extends StatelessWidget {
  const DSCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.tone = DSCardTone.standard,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final DSCardTone tone;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? DSColors.surfaceDark : DSColors.surfaceLight;
    final elevated = isDark ? DSColors.surfaceDark : DSColors.white;
    final background = tone == DSCardTone.elevated ? elevated : base;

    final widget = Material(
      color: background,
      borderRadius: BorderRadius.circular(DSSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DSSpacing.cardRadius),
        highlightColor: DSColors.teal500.withOpacity(0.08),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(DSSpacing.lg),
          child: child,
        ),
      ),
    );

    if (tone == DSCardTone.elevated) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DSSpacing.cardRadius),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: isDark ? 16 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: widget,
      );
    }

    return widget;
  }
}
