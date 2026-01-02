import 'package:flutter/material.dart';

import 'spacing.dart';

class DSIconContainer extends StatelessWidget {
  const DSIconContainer({
    super.key,
    required this.icon,
    required this.color,
    this.size = 48,
    this.iconSize = 24,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      ),
      child: Icon(
        icon,
        color: color,
        size: iconSize,
      ),
    );
  }
}
