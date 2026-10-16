import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Shown instead of the step count when Health Connect is missing or access
/// hasn't been granted.
class StepsHealthAccessCard extends StatelessWidget {
  final VoidCallback onEnable;

  const StepsHealthAccessCard({super.key, required this.onEnable});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_rounded, color: colors.secondary),
              const SizedBox(width: AppSpacing.smd),
              Expanded(
                child: Text(
                  'Enable Health Connect to track steps',
                  style: textTheme.titleMedium!.copyWith(
                    color: colors.onBackground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Yeetfit reads your step count from Health Connect. Grant access '
            'to see today’s steps, distance and calories.',
            style: textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          GradientButton(label: 'Enable Health Connect', onPressed: onEnable),
        ],
      ),
    );
  }
}
