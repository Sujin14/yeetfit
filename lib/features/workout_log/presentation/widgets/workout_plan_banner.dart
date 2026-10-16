import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Teal-tinted note that the form was pre-filled from a coach plan.
class WorkoutPlanBanner extends StatelessWidget {
  final String planTitle;

  const WorkoutPlanBanner({super.key, required this.planTitle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: AppSpacing.smd,
      ),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.secondary.withValues(alpha: 0.45)),
      ),
      child: Text(
        "📋 From your coach's plan: $planTitle",
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: colors.onBackground),
      ),
    );
  }
}
