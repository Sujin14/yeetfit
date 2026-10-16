import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_box.dart';
import 'package:yeetfit/shared/widgets/shimmer_card.dart';
import 'package:yeetfit/shared/widgets/shimmer_wrapper.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Recovery screen skeleton: score arc, then the breakdown card.
class RecoveryShimmer extends StatelessWidget {
  const RecoveryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        children: [
          ShimmerWrapper(
            child: Center(
              child: ShimmerBox(width: 180, height: 180, borderRadius: 90),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          ShimmerCard(height: 160),
        ],
      ),
    );
  }
}
