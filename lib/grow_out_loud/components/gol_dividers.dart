import 'package:flutter/material.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_spacing.dart';
import '../foundation/gol_typography.dart';

class GOLDivider extends StatelessWidget {
  final String? label;

  const GOLDivider({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    if (label == null) {
      return Container(height: 1, color: colors.borderDefault);
    }

    return Row(
      children: [
        Expanded(child: Container(height: 1, color: colors.borderDefault)),
        const SizedBox(width: GOLSpacing.space4),
        Text(
          label!,
          style: GOLTypography.overline(colors.textTertiary),
        ),
        const SizedBox(width: GOLSpacing.space4),
        Expanded(child: Container(height: 1, color: colors.borderDefault)),
      ],
    );
  }
}
