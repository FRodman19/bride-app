import 'package:flutter/material.dart';

import 'spacing.dart';
import 'theme.dart';

class DSDivider extends StatelessWidget {
  const DSDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: height,
      thickness: thickness ?? 1,
      indent: indent,
      endIndent: endIndent,
      color: isDark ? DSColors.neutral500 : DSColors.neutral200,
    );
  }
}

class DSVerticalDivider extends StatelessWidget {
  const DSVerticalDivider({
    super.key,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  final double? width;
  final double? thickness;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return VerticalDivider(
      width: width,
      thickness: thickness ?? 1,
      indent: indent,
      endIndent: endIndent,
      color: isDark ? DSColors.neutral500 : DSColors.neutral200,
    );
  }
}
