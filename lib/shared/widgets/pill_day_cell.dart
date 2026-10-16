import 'package:flutter/material.dart';

/// Round day cell used by the Progress calendar and the date picker dialog.
class PillDayCell extends StatelessWidget {
  final String label;
  final Color? fillColor;
  final Gradient? gradient;
  final Color textColor;
  final bool showRing;
  final VoidCallback? onTap;

  const PillDayCell({
    super.key,
    required this.label,
    required this.textColor,
    this.fillColor,
    this.gradient,
    this.showRing = false,
    this.onTap,
  });

  static const double size = 36;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: gradient == null ? fillColor : null,
          gradient: gradient,
          border: showRing ? Border.all(color: Colors.white, width: 1.5) : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
