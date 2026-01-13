import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'spacing.dart';
import 'theme.dart';

class DSProgressBar extends StatelessWidget {
  const DSProgressBar({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 6,
        backgroundColor: DSColors.neutral200,
        valueColor: const AlwaysStoppedAnimation(DSColors.teal500),
      ),
    );
  }
}

/// Elegant loading spinner with smooth animation
///
/// Uses SpinKitThreeBounce for a modern, premium feel
class DSGridLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const DSGridLoader({super.key, this.size = 48, this.color});

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? DSColors.teal500,
      size: size * 0.4, // Dots are 40% of container size
    );
  }
}
