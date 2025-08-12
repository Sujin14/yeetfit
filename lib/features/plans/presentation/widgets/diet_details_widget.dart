import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

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
                color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                fontSize: 16.sp,
              ) ?? TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    // Define the fixed order for standard meals
    const fixedMealOrder = [
      'Breakfast',
      'Morning Snack',
      'Lunch',
      'Evening Snack',
      'Dinner',
    ];

    // Separate standard and custom meals
    final standardMeals = meals.keys.where((key) => fixedMealOrder.contains(key)).toList();
    final customMeals = meals.keys.where((key) => !fixedMealOrder.contains(key)).toList();

    // Sort standard meals by fixed order and custom meals alphabetically
    standardMeals.sort((a, b) => fixedMealOrder.indexOf(a).compareTo(fixedMealOrder.indexOf(b)));
    customMeals.sort();

    // Combine meals in the desired order
    final sortedMeals = [...standardMeals, ...customMeals];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Calories: $totalCalories cal',
          style: AppTheme.textStyles['subheading']?.copyWith(
                color: AppTheme.colors['primaryText'] ?? Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ) ?? TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        Text(
          'Macronutrients: Protein ${totalMacronutrients['protein']?.toStringAsFixed(1)}g, '
          'Carbs ${totalMacronutrients['carbs']?.toStringAsFixed(1)}g, '
          'Fats ${totalMacronutrients['fats']?.toStringAsFixed(1)}g',
          style: AppTheme.textStyles['body']?.copyWith(
                color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                fontSize: 14.sp,
              ) ?? TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: ListView(
            children: sortedMeals.map((mealName) {
              final meal = meals[mealName] as Map<String, dynamic>;
              final foods = meal['foods'] as List<dynamic>? ?? [];
              final mealCalories = meal['calories'] ?? 0;
              final mealMacronutrients = Map<String, double>.from(
                meal['macronutrients'] ?? {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0},
              );

              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: ExpansionTile(
                  title: Text(
                    '$mealName (${mealCalories} cal)',
                    style: AppTheme.textStyles['subheading']?.copyWith(
                          color: AppTheme.colors['primaryText'] ?? Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ) ?? TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  childrenPadding: EdgeInsets.all(16.w),
                  children: [
                    Text(
                      'Macronutrients: Protein ${mealMacronutrients['protein']?.toStringAsFixed(1)}g, '
                      'Carbs ${mealMacronutrients['carbs']?.toStringAsFixed(1)}g, '
                      'Fats ${mealMacronutrients['fats']?.toStringAsFixed(1)}g',
                      style: AppTheme.textStyles['body']?.copyWith(
                            color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                            fontSize: 14.sp,
                          ) ?? TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 8.h),
                    if (foods.isEmpty)
                      Text(
                        'No foods available',
                        style: AppTheme.textStyles['body']?.copyWith(
                              color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                              fontSize: 14.sp,
                            ) ?? TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ...foods.asMap().entries.map((entry) {
                      final food = entry.value as Map<String, dynamic>;
                      final foodMacronutrients = Map<String, double>.from(
                        food['macronutrients'] ?? {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0},
                      );
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${food['name'] ?? 'Unknown'}',
                              style: AppTheme.textStyles['body']?.copyWith(
                                    color: AppTheme.colors['primaryText'] ?? Colors.black,
                                    fontSize: 16.sp,
                                  ) ?? TextStyle(fontSize: 16.sp, color: Colors.black),
                            ),
                            Text(
                              'Quantity: ${food['quantity'] ?? 'N/A'} ${food['unit'] ?? 'g'}',
                              style: AppTheme.textStyles['body']?.copyWith(
                                    color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                                    fontSize: 14.sp,
                                  ) ?? TextStyle(fontSize: 14.sp, color: Colors.grey),
                            ),
                            Text(
                              'Calories: ${food['calories'] ?? 'N/A'} cal',
                              style: AppTheme.textStyles['body']?.copyWith(
                                    color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                                    fontSize: 14.sp,
                                  ) ?? TextStyle(fontSize: 14.sp, color: Colors.grey),
                            ),
                            Text(
                              'Macronutrients: Protein ${foodMacronutrients['protein']?.toStringAsFixed(1)}g, '
                              'Carbs ${foodMacronutrients['carbs']?.toStringAsFixed(1)}g, '
                              'Fats ${foodMacronutrients['fats']?.toStringAsFixed(1)}g',
                              style: AppTheme.textStyles['body']?.copyWith(
                                    color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                                    fontSize: 14.sp,
                                  ) ?? TextStyle(fontSize: 14.sp, color: Colors.grey),
                            ),
                            if (food['description'] != null && food['description'].isNotEmpty)
                              Text(
                                'Description: ${food['description']}',
                                style: AppTheme.textStyles['body']?.copyWith(
                                      color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                                      fontSize: 14.sp,
                                    ) ?? TextStyle(fontSize: 14.sp, color: Colors.grey),
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