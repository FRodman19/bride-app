import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../foundation/gol_colors.dart';

/// Elegant loading spinner for Grow Out Loud design system
///
/// Uses a smooth three-bounce animation that feels premium and modern.
/// The spinner automatically adapts to the theme's primary color.
///
/// Example:
/// ```dart
/// GOLGridLoader(size: 48)  // Medium size
/// GOLGridLoader(size: 32, color: colors.stateSuccess)  // Custom color
/// ```
class GOLGridLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const GOLGridLoader({
    super.key,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final spinnerColor = color ?? colors.interactivePrimary;

    return SpinKitThreeBounce(
      color: spinnerColor,
      size: size * 0.4, // Dots are 40% of container size for visual balance
    );
  }
}
