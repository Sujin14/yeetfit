import 'package:flutter/material.dart';
import 'shimmer_box.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// GlassCard-shaped shimmer block.
class ShimmerCard extends StatelessWidget {
  final double height;
  final EdgeInsets? margin;
  final double borderRadius;

  const ShimmerCard({
    super.key,
    required this.height,
    this.margin,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          margin ??
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: ShimmerBox(height: height, borderRadius: borderRadius),
    );
  }
}
