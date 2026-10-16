import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class WaterHeroSection extends StatelessWidget {
  final int consumed;
  final int goal;

  const WaterHeroSection({
    super.key,
    required this.consumed,
    required this.goal,
  });

  static String messageFor(ProgressLevel level) => switch (level) {
    ProgressLevel.full => 'Great work! 🎉',
    ProgressLevel.threeQuarter => 'Almost there 💪',
    ProgressLevel.half => 'Halfway to your goal',
    ProgressLevel.quarter => 'Good start, keep sipping',
    ProgressLevel.none => 'Time for a glass of water 💧',
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final level = ProgressLevel.fromRatio(goal > 0 ? consumed / goal : 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: Lottie.asset(
              'assets/animations/water.json',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: AppSpacing.smd),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$consumed',
                  style: textTheme.displayLarge!.copyWith(
                    color: colors.onBackground,
                  ),
                ),
                TextSpan(
                  text: ' / $goal glasses',
                  style: textTheme.bodyMedium!.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            messageFor(level),
            style: textTheme.bodyMedium!.copyWith(
              color: colors.progressColor(level),
            ),
          ),
        ],
      ),
    );
  }
}
