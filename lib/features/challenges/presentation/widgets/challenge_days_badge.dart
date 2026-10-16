import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class ChallengeDaysBadge extends StatelessWidget {
  final int daysRemaining;

  const ChallengeDaysBadge({super.key, required this.daysRemaining});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final label = switch (daysRemaining) {
      <= 1 => 'Last day',
      _ => '$daysRemaining days left',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(color: colors.textSecondary),
      ),
    );
  }
}
