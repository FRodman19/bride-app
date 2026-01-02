import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../foundation/gol_colors.dart';

class GOLLinearProgress extends StatelessWidget {
  final double? value;

  const GOLLinearProgress({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: LinearProgressIndicator(
        minHeight: 4,
        value: value,
        backgroundColor: colors.backgroundTertiary,
        valueColor: AlwaysStoppedAnimation<Color>(colors.interactivePrimary),
      ),
    );
  }
}

class GOLCircularProgress extends StatelessWidget {
  final double size;
  final double value;
  final bool showPercent;

  const GOLCircularProgress({
    super.key,
    this.size = 72,
    this.value = 0.0,
    this.showPercent = true,
  }) : assert(value >= 0 && value <= 1);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _GOLCircularPainter(
              progress: value,
              strokeWidth: 6,
              trackColor: colors.backgroundTertiary,
              progressColor: colors.interactivePrimary,
            ),
          ),
          if (showPercent)
            Text(
              '${(value * 100).round()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
            ),
        ],
      ),
    );
  }
}

class _GOLCircularPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  _GOLCircularPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    final sweep = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_GOLCircularPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
