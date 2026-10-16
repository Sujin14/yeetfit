import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/entities/nutrition_targets.dart';
import 'package:yeetfit/core/services/streak_service.dart';
import 'package:yeetfit/core/utils/nutrition_targets_fields.dart';
import 'package:yeetfit/shared/providers/user_document_provider.dart';
import '../../../user_info/data/datasources/firestore_user_service.dart';
import '../../data/datasources/food_datasource.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/usecases/add_food_entry.dart';
import '../utils/meal_types.dart';

final foodRepositoryProvider = Provider<FoodRepository>(
  (ref) => FoodRepositoryImpl(FoodDataSource()),
);

final addFoodEntryProvider = Provider<AddFoodEntry>(
  (ref) => AddFoodEntry(ref.watch(foodRepositoryProvider)),
);

typedef TodayMealsKey = ({String uid, String date});

TodayMealsKey todayMealsKey(String userId) =>
    (uid: userId, date: StreakService.todayKey());

/// Every entry logged on `date`, all meal slots in one Firestore listener.
/// Sections group it client-side by `mealType`.
final todayMealsProvider = StreamProvider.autoDispose
    .family<List<FoodItem>, TodayMealsKey>(
      (ref, key) =>
          ref.watch(foodRepositoryProvider).watchTodayMeals(key.uid, key.date),
    );

/// The daily targets saved on the profile, updated live. Profiles saved
/// before the targets existed get them calculated and saved once. Null
/// while gender, age, weight or height is missing.
final nutritionTargetsProvider = FutureProvider.autoDispose
    .family<NutritionTargets?, String>((ref, userId) async {
      final userData = await ref.watch(userDocumentProvider(userId).future);
      final saved = NutritionTargetsFields.saved(userData);
      if (saved != null) return saved;
      final calculated = NutritionTargetsFields.calculate(userData);
      if (calculated != null) {
        try {
          await FirestoreUserService().saveNutritionTargets(userId, calculated);
        } catch (e) {
          debugPrint('Saving nutrition targets failed: $e');
        }
      }
      return calculated;
    });

/// Today's calorie and macro totals summed over every logged entry.
final dailyNutrientsProvider = Provider.autoDispose
    .family<Map<String, double>, String>((ref, userId) {
      final items =
          ref.watch(todayMealsProvider(todayMealsKey(userId))).value ??
          const [];
      final totals = {
        'calories': 0.0,
        'protein': 0.0,
        'fat': 0.0,
        'carbs': 0.0,
        'fiber': 0.0,
      };
      for (final item in items) {
        totals['calories'] = totals['calories']! + item.calories;
        totals['protein'] = totals['protein']! + item.protein;
        totals['fat'] = totals['fat']! + item.fat;
        totals['carbs'] = totals['carbs']! + item.carbs;
        totals['fiber'] = totals['fiber']! + item.fiber;
      }
      return totals;
    });

/// Macro goals in grams from the saved targets; 0 while they're unknown.
final nutrientGoalsProvider = Provider.autoDispose
    .family<Map<String, double>, String>((ref, userId) {
      final targets = ref.watch(nutritionTargetsProvider(userId)).value;
      if (targets == null) {
        return const {'protein': 0, 'fat': 0, 'carbs': 0, 'fiber': 0};
      }
      return {
        'protein': targets.protein.toDouble(),
        'fat': targets.fat.toDouble(),
        'carbs': targets.carbs.toDouble(),
        'fiber': targets.calories < 2000 ? 25.0 : 30.0,
      };
    });

/// Every entry from the last 7 days across the known meal slots.
final weeklyFoodDataProvider = FutureProvider.autoDispose
    .family<List<FoodItem>, String>((ref, userId) async {
      final items = await ref
          .read(foodRepositoryProvider)
          .getWeeklyFoodData(userId);
      return items.where((item) => mealTypes.contains(item.mealType)).toList();
    });
