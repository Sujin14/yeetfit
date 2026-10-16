import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurStrength;
  final double opacity;
  final EdgeInsets? padding;
  final Border? border;

  /// Fill tint, applied at [opacity]. Defaults to white.
  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.blurStrength = 20,
    this.opacity = 0.12,
    this.padding,
    this.border,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: (color ?? Colors.white).withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border:
                border ??
                Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}
