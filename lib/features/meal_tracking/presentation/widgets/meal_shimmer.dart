import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_card.dart';
import 'package:yeetfit/shared/widgets/shimmer_card_list.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Nutrition screen skeleton: calorie summary, macro row, scan banner and
/// the five meal sections.
class MealShimmer extends StatelessWidget {
  const MealShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerCard(height: 120),
        SizedBox(height: AppSpacing.smd),
        ShimmerCard(height: 56),
        SizedBox(height: AppSpacing.smd),
        ShimmerCard(height: 64),
        SizedBox(height: AppSpacing.smd),
        ShimmerCardList(count: 5, height: 80, gap: 12),
      ],
    );
  }
}
