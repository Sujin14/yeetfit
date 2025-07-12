import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/calorie_summary.dart';
import '../widgets/meal_section.dart';

class CalorieTrackingScreen extends StatelessWidget {
  const CalorieTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: const CalorieAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(height: 80.h),
          const CalorieSummary(),
          SizedBox(height: 24.h),
          const MealSection(mealType: 'Breakfast'),
          const MealSection(mealType: 'Morning Snack'),
          const MealSection(mealType: 'Lunch'),
          const MealSection(mealType: 'Evening Snack'),
          const MealSection(mealType: 'Dinner'),
        ],
      ),
    );
  }
}
