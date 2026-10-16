import 'dart:math';
import 'package:flutter/material.dart';

/// Upper semicircle scale from 0 (left) to 100 (right), with a needle at
/// [value]. The arc is split into the rest, active-recovery and push bands.
class RecoveryMeterPainter extends CustomPainter {
  static const double _stroke = 8;

  final double value;
  final Color trackColor;
  final Color lowColor;
  final Color midColor;
  final Color highColor;
  final Color needleColor;
  final Color hubColor;
  final Color tickColor;
  final Color labelColor;
  final TextStyle labelStyle;

  const RecoveryMeterPainter({
    required this.value,
    required this.trackColor,
    required this.lowColor,
    required this.midColor,
    required this.highColor,
    required this.needleColor,
    required this.hubColor,
    required this.tickColor,
    required this.labelColor,
    required this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // The score sits in the bottom band. The scale uses the rest of the box,
    // so a larger dial does not need a larger layout slot.
    const scoreBand = 28.0;
    final center = Offset(size.width / 2, size.height - scoreBand);
    final radius = min(center.dx - 2, center.dy - 2);
    final arcRadius = radius - _stroke / 2 - 5;
    final arcRect = Rect.fromCircle(center: center, radius: arcRadius);

    canvas.drawArc(
      arcRect,
      pi,
      pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..strokeCap = StrokeCap.butt
        ..color = trackColor,
    );
    _band(canvas, arcRect, 0, 0.4, lowColor);
    _band(canvas, arcRect, 0.4, 0.7, midColor);
    _band(canvas, arcRect, 0.7, 1, highColor);

    for (var mark = 0; mark <= 100; mark += 10) {
      final angle = _angle(mark / 100);
      final direction = Offset(cos(angle), sin(angle));
      final outer = arcRadius + _stroke / 2 + 4;
      final inner = outer - (mark % 50 == 0 ? 8 : 4);
      canvas.drawLine(
        center + direction * inner,
        center + direction * outer,
        Paint()
          ..color = tickColor
          ..strokeWidth = mark % 50 == 0 ? 1.6 : 1
          ..strokeCap = StrokeCap.round,
      );
    }

    final labelRadius = arcRadius - 16;
    _label(
      canvas,
      '0',
      center + Offset(cos(_angle(0.04)), sin(_angle(0.04))) * labelRadius,
      TextAlign.center,
    );
    _label(canvas, '50', center + Offset(0, -labelRadius), TextAlign.center);
    _label(
      canvas,
      '100',
      center + Offset(cos(_angle(0.96)), sin(_angle(0.96))) * labelRadius,
      TextAlign.center,
    );

    final needleAngle = _angle(value.clamp(0, 100) / 100);
    final direction = Offset(cos(needleAngle), sin(needleAngle));
    canvas.drawLine(
      center - direction * 8,
      center + direction * (arcRadius - 8),
      Paint()
        ..color = needleColor
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, 5.5, Paint()..color = needleColor);
    canvas.drawCircle(center, 3, Paint()..color = hubColor);
  }

  /// [start] and [end] are fractions of the scale, left to right.
  void _band(Canvas canvas, Rect rect, double start, double end, Color color) {
    const gap = 0.012;
    final from = start + gap;
    final to = end - gap;
    canvas.drawArc(
      rect,
      _angle(from),
      pi * (to - from),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..strokeCap = StrokeCap.butt
        ..color = color,
    );
  }

  /// 0 sits at the left of the upper semicircle and 1 at the right.
  double _angle(double fraction) => pi * (1 + fraction);

  void _label(Canvas canvas, String text, Offset anchor, TextAlign align) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: labelStyle.copyWith(color: labelColor),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = switch (align) {
      TextAlign.right => anchor.dx - painter.width,
      TextAlign.center => anchor.dx - painter.width / 2,
      _ => anchor.dx,
    };
    painter.paint(canvas, Offset(dx, anchor.dy - painter.height / 2));
  }

  @override
  bool shouldRepaint(RecoveryMeterPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.lowColor != lowColor ||
        oldDelegate.midColor != midColor ||
        oldDelegate.highColor != highColor ||
        oldDelegate.needleColor != needleColor ||
        oldDelegate.hubColor != hubColor ||
        oldDelegate.tickColor != tickColor ||
        oldDelegate.labelColor != labelColor ||
        oldDelegate.labelStyle != labelStyle;
  }
}
