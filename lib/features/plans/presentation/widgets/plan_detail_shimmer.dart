import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_card.dart';
import 'package:yeetfit/shared/widgets/shimmer_line.dart';
import 'package:yeetfit/shared/widgets/shimmer_wrapper.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Plan detail skeleton: cover image, description lines, content card.
class PlanDetailShimmer extends StatelessWidget {
  const PlanDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShimmerCard(height: 200),
          SizedBox(height: AppSpacing.md),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
            child: ShimmerWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLine(height: 20, width: 200),
                  SizedBox(height: 10),
                  ShimmerLine(height: 14),
                  SizedBox(height: 6),
                  ShimmerLine(height: 14),
                  SizedBox(height: 6),
                  ShimmerLine(height: 14, width: 160),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          ShimmerCard(height: 160),
        ],
      ),
    );
  }
}
