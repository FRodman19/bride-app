import 'package:flutter/material.dart';

import 'spacing.dart';
import 'theme.dart';

enum DSBadgeVariant { neutral, success, error, warning, info }

class DSBadge extends StatelessWidget {
  const DSBadge({
    super.key,
    required this.label,
    this.variant = DSBadgeVariant.neutral,
    this.child,
  });

  final String label;
  final DSBadgeVariant variant;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _background(),
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _foreground(),
            ),
      ),
    );

    if (child == null) {
      return badge;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(right: -6, top: -6, child: badge),
      ],
    );
  }

  Color _background() {
    switch (variant) {
      case DSBadgeVariant.success:
        return DSColors.premiumGreenSoft;
      case DSBadgeVariant.error:
        return DSColors.premiumRedSoft;
      case DSBadgeVariant.warning:
        return DSColors.premiumAmberSoft;
      case DSBadgeVariant.info:
        return DSColors.premiumBlueSoft;
      case DSBadgeVariant.neutral:
        return DSColors.neutral200;
    }
  }

  Color _foreground() {
    switch (variant) {
      case DSBadgeVariant.success:
        return DSColors.premiumGreen;
      case DSBadgeVariant.error:
        return DSColors.premiumRed;
      case DSBadgeVariant.warning:
        return DSColors.premiumAmber;
      case DSBadgeVariant.info:
        return DSColors.premiumBlue;
      case DSBadgeVariant.neutral:
        return DSColors.black;
    }
  }
}
