import 'dart:math';
import 'package:flutter/material.dart';

/// 240° arc gauge opening at the bottom: starts at 150° (bottom-left) and
/// sweeps clockwise to 30° (bottom-right).
class RecoveryGaugePainter extends CustomPainter {
  static const double startAngle = 150 * pi / 180;
  static const double sweepAngle = 240 * pi / 180;

  final double progress; // 0–1
  final double strokeWidth;
  final Color trackColor;
  final Color startColor;
  final Color endColor;

  const RecoveryGaugePainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.startColor,
    required this.endColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawArc(rect, startAngle, sweepAngle, false, trackPaint);

    final clamped = progress.clamp(0.0, 1.0);
    if (clamped <= 0) return;

    // Sweep gradients are evaluated in [0, 2π) from their own zero angle, so
    // the gradient is rotated to begin just before the arc; the extra margin
    // keeps the round start cap from wrapping to the end color.
    final capAngle = (strokeWidth / 2) / radius;
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        endAngle: sweepAngle + 2 * capAngle,
        colors: [startColor, endColor],
        transform: GradientRotation(startAngle - capAngle),
      ).createShader(rect);
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle * clamped,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(RecoveryGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor;
  }
}
