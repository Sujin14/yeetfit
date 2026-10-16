import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../domain/entities/bmi_category.dart';
import '../providers/bmi_provider.dart';
import 'bmi_scale_bar.dart';
import 'dashboard_card_error.dart';
import 'dashboard_card_skeleton.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// BMI value, band, scale and suggestion. Prompts for profile data when
/// height or weight is missing.
class DashboardBmiCard extends ConsumerWidget {
  final String userId;
  final VoidCallback onCompleteProfile;

  const DashboardBmiCard({
    super.key,
    required this.userId,
    required this.onCompleteProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final bmiAsync = ref.watch(bmiStreamProvider(userId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: bmiAsync.when(
        loading: () => const DashboardCardSkeleton(height: 150),
        error: (error, _) => DashboardCardError(
          message: 'Could not load BMI: $error',
          onRetry: () => ref.invalidate(bmiStreamProvider(userId)),
        ),
        data: (bmi) {
          final title = Text(
            'Body Mass Index',
            style: textTheme.titleMedium!.copyWith(color: colors.onBackground),
          );

          if (bmi <= 0) {
            return GlassCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              borderRadius: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 6),
                  Text(
                    'Add your height and weight to see your BMI.',
                    style: textTheme.bodySmall!.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onCompleteProfile,
                      child: Text(
                        'Update profile →',
                        style: textTheme.labelLarge!.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final category = BmiCategory.fromBmi(bmi);
          final categoryColor = switch (category) {
            BmiCategory.underweight => colors.bmiUnderweight,
            BmiCategory.normal => colors.bmiNormal,
            BmiCategory.overweight => colors.bmiOverweight,
            BmiCategory.obese => colors.bmiObese,
          };

          return GlassCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            borderRadius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: title),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: categoryColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        category.label,
                        style: textTheme.labelLarge!.copyWith(
                          color: categoryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  bmi.toStringAsFixed(1),
                  style: textTheme.displayLarge!.copyWith(color: categoryColor),
                ),
                const SizedBox(height: AppSpacing.smd),
                BmiScaleBar(bmi: bmi),
                const SizedBox(height: AppSpacing.smd),
                Text(
                  category.suggestion,
                  style: textTheme.bodySmall!.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
