import 'package:flutter/material.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_spacing.dart';
import '../foundation/gol_typography.dart';

/// Thin grey divider that works in both light and dark mode.
///
/// The divider uses [borderDefault] color which is a subtle grey
/// that matches card outlines for visual consistency.
///
/// Usage:
/// ```dart
/// GOLDivider()  // Simple horizontal divider
/// GOLDivider(label: 'OR')  // Divider with centered label
/// GOLDivider.vertical()  // Vertical divider
/// ```
class GOLDivider extends StatelessWidget {
  final String? label;
  final double? indent;
  final double? endIndent;

  const GOLDivider({
    super.key,
    this.label,
    this.indent,
    this.endIndent,
  });

  /// Creates a vertical divider (for use inside IntrinsicHeight + Row)
  static Widget vertical({
    double? width,
    EdgeInsetsGeometry? margin,
  }) {
    return Builder(
      builder: (context) {
        final colors = Theme.of(context).extension<GOLSemanticColors>()!;
        return Container(
          width: width ?? 0.5,
          color: colors.borderDefault,
          margin: margin,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;

    // Simple divider without label
    if (label == null) {
      return Container(
        height: 0.5, // Thin divider
        margin: EdgeInsets.only(
          left: indent ?? 0,
          right: endIndent ?? 0,
        ),
        color: colors.borderDefault, // Grey color matching card outlines
      );
    }

    // Divider with centered label
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 0.5,
            margin: EdgeInsets.only(left: indent ?? 0),
            color: colors.borderDefault,
          ),
        ),
        const SizedBox(width: GOLSpacing.space4),
        Text(
          label!,
          style: GOLTypography.overline(colors.textTertiary),
        ),
        const SizedBox(width: GOLSpacing.space4),
        Expanded(
          child: Container(
            height: 0.5,
            margin: EdgeInsets.only(right: endIndent ?? 0),
            color: colors.borderDefault,
          ),
        ),
      ],
    );
  }
}
