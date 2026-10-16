import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../providers/progress_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// The daily calorie target the heatmap is measured against, or a prompt to
/// complete the profile when there isn't one.
class CalorieGoalBanner extends ConsumerWidget {
  final String userId;

  const CalorieGoalBanner({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetAsync = ref.watch(progressCalorieTargetProvider(userId));
    if (!targetAsync.hasValue) return const SizedBox.shrink();

    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final target = targetAsync.value;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        0,
        AppSpacing.screenEdge,
        AppSpacing.smd,
      ),
      child: GlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smd,
        ),
        child: Row(
          children: [
            Icon(
              target == null
                  ? Icons.person_outline
                  : Icons.local_fire_department_outlined,
              color: target == null ? colors.textSecondary : colors.calories,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                target == null
                    ? 'Complete your profile to see your goal'
                    : 'Daily goal · '
                          '${NumberFormat.decimalPattern().format(target)} kcal',
                style: textTheme.bodyMedium!.copyWith(
                  color: target == null
                      ? colors.textSecondary
                      : colors.onBackground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
