import 'dart:math';

import 'package:flutter/material.dart';

class GradientCircularProgress extends StatelessWidget {
  const GradientCircularProgress({
    super.key,
    required this.size,
    required this.progress,
    required this.strokeWidth,
    required this.gradient,
  });

  final double size;
  final double progress;
  final double strokeWidth;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(size),
      painter: _GradientCircularProgressPainter(
        gradient: gradient,
        progress: progress,
        radius: size,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  const _GradientCircularProgressPainter({
    required this.radius,
    required this.strokeWidth,
    required this.progress,
    required this.gradient,
  });

  final double radius;
  final double strokeWidth;
  final double progress;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    size = Size.fromRadius(radius);
    double offset = strokeWidth / 2;
    Rect rect = Offset(offset, offset) &
        Size(size.width - strokeWidth, size.height - strokeWidth);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    paint.shader = gradient.createShader(rect);
    double angle = 2 * pi * (progress / 100);
    canvas.drawArc(rect, -pi / 2, angle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
