import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/shimmer_card_list.dart';
import 'package:yeetfit/shared/widgets/shimmer_line.dart';
import 'package:yeetfit/shared/widgets/shimmer_wrapper.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Onboarding step skeleton: step label, progress bar, title, option cards.
class UserInfoShimmer extends StatelessWidget {
  const UserInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 36),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ShimmerWrapper(
                child: Column(
                  children: [
                    ShimmerLine(height: 12, width: 80),
                    SizedBox(height: AppSpacing.md),
                    ShimmerLine(height: 3),
                    SizedBox(height: AppSpacing.xl),
                    ShimmerLine(height: 28, width: 220),
                    SizedBox(height: 10),
                    ShimmerLine(height: 14, width: 260),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            ShimmerCardList(
              count: 4,
              height: 64,
              gap: 12,
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            ),
          ],
        ),
      ),
    );
  }
}
