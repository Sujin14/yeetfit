import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_box.dart';
import 'package:yeetfit/shared/widgets/shimmer_card.dart';
import 'package:yeetfit/shared/widgets/shimmer_line.dart';
import 'package:yeetfit/shared/widgets/shimmer_wrapper.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Full dashboard skeleton: header, recovery score, mood row, 2×2 progress
/// grid, workout, meal, BMI and challenges cards.
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Non-scrolling, but avoids overflow on short screens.
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: _skeleton(),
    );
  }

  Widget _skeleton() {
    return ShimmerWrapper(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSpacing.screenEdge),
            child: Row(
              children: [
                ShimmerBox(width: 48, height: 48, borderRadius: 24),
                SizedBox(width: AppSpacing.smd),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLine(height: 18, width: 140),
                    SizedBox(height: 6),
                    ShimmerLine(height: 12, width: 100),
                  ],
                ),
              ],
            ),
          ),
          const ShimmerCard(height: 152),
          const SizedBox(height: AppSpacing.md),
          const ShimmerCard(height: 96),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenEdge,
            ),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                4,
                (_) => const ShimmerBox(borderRadius: 20),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const ShimmerCard(height: 72),
          const SizedBox(height: AppSpacing.md),
          const ShimmerCard(height: 190),
          const SizedBox(height: AppSpacing.md),
          const ShimmerCard(height: 150),
          const SizedBox(height: AppSpacing.md),
          const ShimmerCard(height: 76),
        ],
      ),
    );
  }
}
