import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_box.dart';
import 'package:yeetfit/shared/widgets/shimmer_wrapper.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Shimmer for the bedtime / wake-up tiles while loading.
class SleepTimeCardsShimmer extends StatelessWidget {
  const SleepTimeCardsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerWrapper(
      child: Row(
        children: [
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: 88,
              borderRadius: 20,
            ),
          ),
          SizedBox(width: AppSpacing.smd),
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: 88,
              borderRadius: 20,
            ),
          ),
        ],
      ),
    );
  }
}
