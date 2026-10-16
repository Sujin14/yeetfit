import 'package:flutter/material.dart';

/// Strokes a rounded-rect border with a gradient; used as a `foregroundPainter`
/// so the translucent fill underneath stays untinted.
class GradientBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double borderRadius;
  final double strokeWidth;

  const GradientBorderPainter({
    required this.gradient,
    required this.borderRadius,
    this.strokeWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(strokeWidth / 2),
        Radius.circular(borderRadius),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(GradientBorderPainter oldDelegate) =>
      oldDelegate.gradient != gradient ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.strokeWidth != strokeWidth;
}
