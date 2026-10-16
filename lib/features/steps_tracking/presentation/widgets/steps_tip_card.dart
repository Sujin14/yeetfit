import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

// Tip card for steps tracking.
class StepsTipCard extends StatelessWidget {
  const StepsTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_outline_rounded, color: colors.warning),
            const SizedBox(width: AppSpacing.smd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today’s tip',
                    style: textTheme.titleMedium!.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Weighted vests can make your walks more effective. Use '
                    'one that’s only 5–10% of your body weight for safety and '
                    'comfort.',
                    style: textTheme.bodyMedium!.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
