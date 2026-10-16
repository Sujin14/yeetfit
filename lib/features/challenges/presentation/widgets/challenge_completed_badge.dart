import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ChallengeCompletedBadge extends StatelessWidget {
  const ChallengeCompletedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.success.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.success.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 14, color: colors.success),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Completed',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: colors.success),
          ),
        ],
      ),
    );
  }
}
