import 'package:flutter/material.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_radius.dart';
import '../foundation/gol_shadows.dart';

enum GOLCardVariant { standard, elevated, interactive }

class GOLCard extends StatelessWidget {
  final Widget child;
  final GOLCardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const GOLCard({
    super.key,
    required this.child,
    this.variant = GOLCardVariant.standard,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final decoration = _decoration(colors, isDark);

    final content = Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );

    if (variant == GOLCardVariant.interactive && onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(GOLRadius.cardStandard),
          onTap: onTap,
          child: Ink(
            decoration: decoration,
            child: content,
          ),
        ),
      );
    }

    return Container(
      decoration: decoration,
      child: content,
    );
  }

  BoxDecoration _decoration(GOLSemanticColors colors, bool isDark) {
    switch (variant) {
      case GOLCardVariant.standard:
        return BoxDecoration(
          color: colors.surfaceDefault,
          border: Border.all(color: colors.borderDefault),
          borderRadius: BorderRadius.circular(GOLRadius.cardStandard),
        );
      case GOLCardVariant.elevated:
        return BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(GOLRadius.cardStandard),
          boxShadow: isDark ? GOLShadows.smDark : GOLShadows.sm,
        );
      case GOLCardVariant.interactive:
        // Transparent background with outline only - matches input field styling
        return BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: colors.borderDefault, width: 1.5),
          borderRadius: BorderRadius.circular(GOLRadius.cardStandard),
        );
    }
  }
}
