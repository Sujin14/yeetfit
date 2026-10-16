import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_card_list.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Placeholder result tiles while a food search runs.
class FoodSearchShimmer extends StatelessWidget {
  const FoodSearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.sm),
      child: ShimmerCardList(count: 6, height: 64),
    );
  }
}
