import 'dart:ui';

import 'package:flutter/material.dart';

import 'spacing.dart';
import 'theme.dart';

class DSSkeleton extends StatefulWidget {
  const DSSkeleton({
    super.key,
    this.width,
    this.height,
    this.radius = DSSpacing.componentRadius,
    this.color,
    this.child,
  });

  final double? width;
  final double? height;
  final double radius;
  final Color? color;
  final Widget? child;

  @override
  State<DSSkeleton> createState() => _DSSkeletonState();
}

class _DSSkeletonState extends State<DSSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.color ??
        (Theme.of(context).brightness == Brightness.dark
            ? DSColors.neutral300
            : DSColors.neutral200);

    final highlight = Theme.of(context).colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final color = Color.lerp(base, highlight, _animation.value)!;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
