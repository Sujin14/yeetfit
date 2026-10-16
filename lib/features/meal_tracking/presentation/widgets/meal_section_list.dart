import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/food_item.dart';
import '../providers/food_provider.dart';
import 'meal_section.dart';

class MealSectionList extends ConsumerWidget {
  final String userId;

  /// Called with the stored meal slot new food should be logged under.
  final ValueChanged<String> onAddFood;
  final ValueChanged<FoodItem> onOpenEntry;

  const MealSectionList({
    super.key,
    required this.userId,
    required this.onAddFood,
    required this.onOpenEntry,
  });

  /// Display title → stored meal slot, in the order meals are eaten.
  static const List<(String, String)> _sections = [
    ('Breakfast', 'Breakfast'),
    ('Mid Morning Snack', 'Morning Snack'),
    ('Lunch', 'Lunch'),
    ('Evening Snack', 'Evening Snack'),
    ('Dinner', 'Dinner'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = todayMealsKey(userId);
    final meals = ref.watch(todayMealsProvider(key));

    return Column(
      children: [
        for (final (title, slot) in _sections)
          MealSection(
            userId: userId,
            title: title,
            entries: meals.whenData(
              (all) => all.where((meal) => meal.mealType == slot).toList(),
            ),
            onAdd: () => onAddFood(slot),
            onRetry: () => ref.invalidate(todayMealsProvider(key)),
            onOpenEntry: onOpenEntry,
          ),
      ],
    );
  }
}
