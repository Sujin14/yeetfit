import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_card_list.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Three challenge-card placeholders.
class ChallengesShimmer extends StatelessWidget {
  const ChallengesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: ShimmerCardList(count: 3, height: 100),
    );
  }
}
