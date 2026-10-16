import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Section heading inside the log-workout sheet.
class WorkoutFormLabel extends StatelessWidget {
  final String text;

  const WorkoutFormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelLarge!.copyWith(color: colors.textSecondary),
      ),
    );
  }
}
