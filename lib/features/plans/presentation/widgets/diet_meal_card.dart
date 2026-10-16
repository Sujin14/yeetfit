import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'diet_food_row.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Expandable glass card for one meal of a diet plan.
class DietMealCard extends StatelessWidget {
  final String name;
  final Map<String, dynamic> meal;

  const DietMealCard({super.key, required this.name, required this.meal});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final foods = (meal['foods'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final macros = Map<String, dynamic>.from(
      meal['macronutrients'] as Map? ?? const {},
    );
    String macro(String key) =>
        (macros[key] as num?)?.toStringAsFixed(0) ?? '0';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.xs,
      ),
      child: GlassCard(
        borderRadius: 16,
        padding: EdgeInsets.zero,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: colors.textSecondary,
            collapsedIconColor: colors.textSecondary,
            tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            childrenPadding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            title: Text(
              name,
              style: textTheme.titleMedium!.copyWith(
                color: colors.onBackground,
              ),
            ),
            subtitle: Text(
              '${meal['calories'] ?? 0} kcal · P ${macro('protein')}g · '
              'C ${macro('carbs')}g · F ${macro('fats')}g',
              style: textTheme.bodySmall!.copyWith(color: colors.textSecondary),
            ),
            children: foods.isEmpty
                ? [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'No foods available',
                        style: textTheme.bodySmall!.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                  ]
                : [for (final food in foods) DietFoodRow(food: food)],
          ),
        ),
      ),
    );
  }
}
