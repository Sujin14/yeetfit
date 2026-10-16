import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../domain/entities/food_item.dart';
import 'nutrition_value_row.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class NutritionMacroCard extends StatelessWidget {
  final FoodItem foodItem;

  const NutritionMacroCard({super.key, required this.foodItem});

  String _grams(double value) => '${value.toStringAsFixed(1)} g';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenEdge,
          vertical: AppSpacing.smd,
        ),
        child: Column(
          children: [
            NutritionValueRow(
              label: 'Calories',
              value: '${foodItem.calories.round()} kcal',
              accentColor: colors.calories,
            ),
            NutritionValueRow(
              label: 'Protein',
              value: _grams(foodItem.protein),
              accentColor: colors.protein,
            ),
            NutritionValueRow(
              label: 'Carbs',
              value: _grams(foodItem.carbs),
              accentColor: colors.carbs,
            ),
            NutritionValueRow(
              label: 'Fat',
              value: _grams(foodItem.fat),
              accentColor: colors.fat,
            ),
            NutritionValueRow(
              label: 'Fiber',
              value: _grams(foodItem.fiber),
              accentColor: colors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
