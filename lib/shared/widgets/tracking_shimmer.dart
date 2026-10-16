import 'package:flutter/material.dart';
import 'shimmer_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Skeleton shared by the water, sleep, steps and weight screens:
/// hero area, main metric card, chart.
class TrackingShimmer extends StatelessWidget {
  const TrackingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShimmerCard(height: 160),
          SizedBox(height: AppSpacing.smd),
          ShimmerCard(height: 120),
          SizedBox(height: AppSpacing.smd),
          ShimmerCard(height: 200),
        ],
      ),
    );
  }
}
