import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/theme.dart';

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final EdgeInsets padding;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    required this.color,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppTheme.colors['borderGradientStart']!),
            boxShadow: [
              BoxShadow(
                color: AppTheme.colors['darkBackground']!.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
