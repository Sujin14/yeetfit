import 'dart:ui';

import 'package:flutter/material.dart';

/// Square frosted-glass icon button; defaults to the 36px app bar size.
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.color,
    this.onPressed,
    this.tooltip,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(size / 3);
    final button = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius,
            child: Ink(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: borderRadius,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 0.5,
                ),
              ),
              child: Icon(icon, color: color, size: size * 0.55),
            ),
          ),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip, child: button);
  }
}
