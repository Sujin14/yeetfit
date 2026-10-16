import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class MoodCorrelationLockedCard extends StatelessWidget {
  final int loggedDays;
  final int requiredDays;

  const MoodCorrelationLockedCard({
    super.key,
    required this.loggedDays,
    required this.requiredDays,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GlassCard(
      borderRadius: 20,
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: colors.textMuted),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log mood for $requiredDays days to see your fitness–mood '
                  'pattern',
                  style: textTheme.bodyMedium!.copyWith(
                    color: colors.onBackground,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$loggedDays of $requiredDays days logged',
                  style: textTheme.bodySmall!.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
