import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/food_provider.dart';
import '../widgets/calorie_appbar.dart';
import '../widgets/calorie_summary.dart';
import '../widgets/meal_section.dart';
import '../widgets/shimmer_card.dart';

class CalorieTrackingScreen extends ConsumerWidget {
  const CalorieTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track calories')),
      );
    }

    final today = DateTime.now().toIso8601String().split('T')[0];

    return Scaffold(
      appBar: CalorieAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final totalCalories =
                      [
                            'Breakfast',
                            'Morning Snack',
                            'Lunch',
                            'Evening Snack',
                            'Dinner',
                          ]
                          .map(
                            (mealType) => ref.watch(
                              dailyCaloriesProvider('$userId|$mealType'),
                            ),
                          )
                          .fold(0.0, (sum, calories) => sum + calories);
                  final goalCaloriesAsync = ref.watch(
                    calorieGoalProvider(userId),
                  );
                  final progressColor = ref.watch(
                    dailyCalorieProgressColorProvider('$userId|$today'),
                  );
                  return goalCaloriesAsync.when(
                    data: (goalCalories) => CalorieSummary(
                      totalCalories: totalCalories,
                      progressColor: progressColor,
                    ),
                    loading: () => ShimmerCard(isSummary: true),
                    error: (error, _) => Text('Error: $error'),
                  );
                },
              ),
              SizedBox(height: 24.h),
              const MealSection(mealType: 'Breakfast'),
              const MealSection(mealType: 'Morning Snack'),
              const MealSection(mealType: 'Lunch'),
              const MealSection(mealType: 'Evening Snack'),
              const MealSection(mealType: 'Dinner'),
            ],
          ),
        ),
      ),
    );
  }
}
