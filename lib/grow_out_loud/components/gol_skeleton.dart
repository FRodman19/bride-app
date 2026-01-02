import 'package:flutter/material.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_radius.dart';

class GOLSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const GOLSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.radius = GOLRadius.xs,
  });

  @override
  State<GOLSkeleton> createState() => _GOLSkeletonState();
}

class _GOLSkeletonState extends State<GOLSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final base = colors.backgroundTertiary;
    final highlight = colors.backgroundSecondary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (rect) {
              final slide = _controller.value * 2 - 1;
              return LinearGradient(
                begin: Alignment(-1 + slide, 0),
                end: Alignment(1 + slide, 0),
                colors: [base, highlight, base],
                stops: const [0.1, 0.5, 0.9],
              ).createShader(rect);
            },
            child: Container(
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(widget.radius),
              ),
            ),
          ),
        );
      },
    );
  }
}
