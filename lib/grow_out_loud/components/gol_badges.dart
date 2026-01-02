import 'package:flutter/material.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_radius.dart';

enum GOLBadgeVariant { dot, count }

class GOLBadge extends StatelessWidget {
  final GOLBadgeVariant variant;
  final String? count;

  const GOLBadge({
    super.key,
    this.variant = GOLBadgeVariant.dot,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    switch (variant) {
      case GOLBadgeVariant.dot:
        return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: GOLPrimitives.error500,
            shape: BoxShape.circle,
          ),
        );
      case GOLBadgeVariant.count:
        final display = count ?? '1';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
          decoration: BoxDecoration(
            color: colors.stateError,
            borderRadius: BorderRadius.circular(GOLRadius.full),
          ),
          alignment: Alignment.center,
          child: Text(
            display,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.textInverse,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
          ),
        );
    }
  }
}
