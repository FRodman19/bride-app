import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';

class DSSuccessIcon extends StatelessWidget {
  const DSSuccessIcon({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.7, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Icon(Icons.check_circle, color: DSColors.premiumGreen, size: size),
    );
  }
}

class DSErrorIcon extends StatelessWidget {
  const DSErrorIcon({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final wobble = math.sin(value * math.pi * 2) * 0.06;
        return Transform.rotate(angle: wobble, child: child);
      },
      child: Icon(Icons.error, color: DSColors.premiumRed, size: size),
    );
  }
}
