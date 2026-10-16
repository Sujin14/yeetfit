import 'package:flutter/material.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'water_circular_indicator.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class WaterCircularCard extends StatelessWidget {
  final int consumed;
  final int goal;

  const WaterCircularCard({
    super.key,
    required this.consumed,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final level = ProgressLevel.fromRatio(goal > 0 ? consumed / goal : 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          children: [
            WaterCircularIndicator(
              consumed: consumed,
              goal: goal,
              progressColor: colors.progressColor(level),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '1 glass = 250 ml',
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
