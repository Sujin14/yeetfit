import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_box.dart';

/// Card-shaped shimmer used while a single dashboard card's data loads.
/// Without [height] it fills its parent (e.g. a grid cell).
class DashboardCardSkeleton extends StatelessWidget {
  final double? height;
  final double borderRadius;

  const DashboardCardSkeleton({super.key, this.height, this.borderRadius = 20});

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(height: height, borderRadius: borderRadius);
  }
}
