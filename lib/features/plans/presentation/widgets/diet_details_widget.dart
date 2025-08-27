import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class DietDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> meals;
  final int totalCalories;
  final Map<String, double> totalMacronutrients;

  const DietDetailsWidget({
    super.key,
    required this.meals,
    required this.totalCalories,
    required this.totalMacronutrients,
  });

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Center(
        child: Text(
          'No meals available',
          style: AppTheme.textStyles['body']?.copyWith(
            color: AppTheme.colors['secondaryText'],
            fontSize: FixedSizes.font16(context),
          ),
        ),
      );
    }

    const fixedMealOrder = [
      'Breakfast',
      'Morning Snack',
      'Lunch',
      'Evening Snack',
      'Dinner',
    ];

    final standardMeals = meals.keys
        .where((key) => fixedMealOrder.contains(key))
        .toList();
    final customMeals = meals.keys
        .where((key) => !fixedMealOrder.contains(key))
        .toList();

    standardMeals.sort(
      (a, b) => fixedMealOrder.indexOf(a).compareTo(fixedMealOrder.indexOf(b)),
    );
    customMeals.sort();

    final sortedMeals = [...standardMeals, ...customMeals];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Calories: $totalCalories cal',
          style: AppTheme.textStyles['subheading']?.copyWith(
            color: AppTheme.colors['primaryText'],
            fontSize: FixedSizes.font18(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: FixedSizes.box8(context)),
        Text(
          'Macronutrients: Protein ${totalMacronutrients['protein']?.toStringAsFixed(1)}g, '
          'Carbs ${totalMacronutrients['carbs']?.toStringAsFixed(1)}g, '
          'Fats ${totalMacronutrients['fats']?.toStringAsFixed(1)}g',
          style: AppTheme.textStyles['body']?.copyWith(
            color: AppTheme.colors['secondaryText'],
            fontSize: FixedSizes.font14(context),
          ),
        ),
        SizedBox(height: FixedSizes.box16(context)),
        Expanded(
          child: ListView(
            children: sortedMeals.map((mealName) {
              final meal = meals[mealName] as Map<String, dynamic>;
              final foods = meal['foods'] as List<dynamic>? ?? [];
              final mealCalories = meal['calories'] ?? 0;
              final mealMacros = Map<String, double>.from(
                meal['macronutrients'] ?? {'protein': 0, 'carbs': 0, 'fats': 0},
              );

              return Padding(
                padding: EdgeInsets.only(bottom: FixedSizes.box16(context)),
                child: ExpansionTile(
                  title: Text(
                    '$mealName ($mealCalories cal)',
                    style: AppTheme.textStyles['subheading']?.copyWith(
                      color: AppTheme.colors['primaryText'],
                      fontSize: FixedSizes.font18(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  tilePadding: EdgeInsets.symmetric(
                    horizontal: FixedSizes.box16(context),
                    vertical: FixedSizes.box8(context),
                  ),
                  childrenPadding: EdgeInsets.all(FixedSizes.box16(context)),
                  children: [
                    Text(
                      'Macronutrients: Protein ${mealMacros['protein']?.toStringAsFixed(1)}g, '
                      'Carbs ${mealMacros['carbs']?.toStringAsFixed(1)}g, '
                      'Fats ${mealMacros['fats']?.toStringAsFixed(1)}g',
                      style: AppTheme.textStyles['body']?.copyWith(
                        color: AppTheme.colors['secondaryText'],
                        fontSize: FixedSizes.font14(context),
                      ),
                    ),
                    SizedBox(height: FixedSizes.box8(context)),
                    if (foods.isEmpty)
                      Text(
                        'No foods available',
                        style: AppTheme.textStyles['body']?.copyWith(
                          color: AppTheme.colors['secondaryText'],
                          fontSize: FixedSizes.font14(context),
                        ),
                      ),
                    ...foods.asMap().entries.map((entry) {
                      final food = entry.value as Map<String, dynamic>;
                      final macros = Map<String, double>.from(
                        food['macronutrients'] ??
                            {'protein': 0, 'carbs': 0, 'fats': 0},
                      );
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: FixedSizes.box8(context),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${food['name'] ?? 'Unknown'}',
                              style: AppTheme.textStyles['body']?.copyWith(
                                color: AppTheme.colors['primaryText'],
                                fontSize: FixedSizes.font16(context),
                              ),
                            ),
                            Text(
                              'Quantity: ${food['quantity'] ?? 'N/A'} ${food['unit'] ?? 'g'}',
                              style: AppTheme.textStyles['body']?.copyWith(
                                color: AppTheme.colors['secondaryText'],
                                fontSize: FixedSizes.font14(context),
                              ),
                            ),
                            Text(
                              'Calories: ${food['calories'] ?? 'N/A'} cal',
                              style: AppTheme.textStyles['body']?.copyWith(
                                color: AppTheme.colors['secondaryText'],
                                fontSize: FixedSizes.font14(context),
                              ),
                            ),
                            Text(
                              'Macronutrients: Protein ${macros['protein']?.toStringAsFixed(1)}g, '
                              'Carbs ${macros['carbs']?.toStringAsFixed(1)}g, '
                              'Fats ${macros['fats']?.toStringAsFixed(1)}g',
                              style: AppTheme.textStyles['body']?.copyWith(
                                color: AppTheme.colors['secondaryText'],
                                fontSize: FixedSizes.font14(context),
                              ),
                            ),
                            if (food['description'] != null &&
                                food['description'].isNotEmpty)
                              Text(
                                'Description: ${food['description']}',
                                style: AppTheme.textStyles['body']?.copyWith(
                                  color: AppTheme.colors['secondaryText'],
                                  fontSize: FixedSizes.font14(context),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
