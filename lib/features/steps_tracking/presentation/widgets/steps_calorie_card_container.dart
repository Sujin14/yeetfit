import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/steps_provider.dart';
import 'steps_calories_card.dart';

class StepsCaloriesCardContainer extends ConsumerWidget {
  final String userId;

  const StepsCaloriesCardContainer({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caloriesBurned = ref.watch(caloriesBurnedProvider(userId));
    final goalCalories = ref.watch(goalCaloriesProvider(userId));
    return StepsCaloriesCard(
      steps: caloriesBurned.toInt(),
      calories: goalCalories,
    );
  }
}
