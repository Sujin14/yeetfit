import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_card_list.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Plan-list placeholders.
class PlanListShimmer extends StatelessWidget {
  const PlanListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.screenEdge),
      child: ShimmerCardList(count: 4, height: 100, gap: AppSpacing.md),
    );
  }
}
