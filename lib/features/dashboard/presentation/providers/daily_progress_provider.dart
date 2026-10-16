import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yeetfit/core/utils/nutrition_targets_fields.dart';
import '../../../steps_tracking/presentation/providers/steps_provider.dart';
import '../../domain/entities/daily_progress.dart';
import 'selected_date_provider.dart';
import 'package:yeetfit/shared/providers/user_document_provider.dart';

final dailyProgressStreamProvider =
    StreamProvider.family<DailyProgress, String>((ref, userId) {
      final date = ref
          .watch(selectedDateProvider)
          .toIso8601String()
          .split('T')[0];
      final today = DateTime.now().toIso8601String().split('T')[0];
      final progress = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('progress');

      DocumentReference<Map<String, dynamic>> dayDoc(String metric) =>
          progress.doc(metric).collection(metric).doc(date);

      return Rx.combineLatest6(
        watchUserDocument(ref, userId),
        dayDoc('steps').snapshots(),
        dayDoc('water').snapshots(),
        dayDoc('sleep').snapshots(),
        progress.doc('food').collection('food').snapshots(),
        date == today ? _liveStepsStream(ref, userId) : Stream.value(0),
        (userData, stepsDoc, waterDoc, sleepDoc, foodDocs, liveSteps) {
          final stepsData = stepsDoc.data();
          final waterData = waterDoc.data();
          final sleepData = sleepDoc.data();
          final nutrition = _nutritionFor(date, foodDocs, userData);

          return DailyProgress(
            steps: date == today && liveSteps > 0
                ? liveSteps
                : _asDouble(stepsData, 'steps', 0).round(),
            stepsGoal: _asDouble(stepsData, 'goalSteps', 10000).round(),
            glasses: _asDouble(waterData, 'glassesConsumed', 0).round(),
            waterGoal: _asDouble(waterData, 'goalGlasses', 8).round(),
            hoursSlept: _asDouble(sleepData, 'duration', 0),
            sleepGoal: _asDouble(sleepData, 'goalHours', 8),
            calories: nutrition.calories,
            caloriesGoal: nutrition.caloriesGoal,
            protein: nutrition.protein,
            proteinGoal: nutrition.proteinGoal,
            carbs: nutrition.carbs,
            carbsGoal: nutrition.carbsGoal,
            fat: nutrition.fat,
            fatGoal: nutrition.fatGoal,
          );
        },
      );
    });

double _asDouble(Map<String, dynamic>? map, String key, double fallback) {
  final value = map?[key];
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

String _asString(Map<String, dynamic>? map, String key, String fallback) =>
    map?[key]?.toString() ?? fallback;

typedef _Nutrition = ({
  double calories,
  double caloriesGoal,
  double protein,
  double proteinGoal,
  double carbs,
  double carbsGoal,
  double fat,
  double fatGoal,
});

/// Sums the day's food entries. Goals are the profile's saved daily targets,
/// calculated from the profile when they haven't been saved yet, and 0 when
/// the profile is incomplete.
_Nutrition _nutritionFor(
  String date,
  QuerySnapshot<Map<String, dynamic>> foodDocs,
  Map<String, dynamic>? userData,
) {
  double calories = 0, protein = 0, carbs = 0, fat = 0;

  for (final doc in foodDocs.docs) {
    final data = doc.data();
    if (doc.id != '$date-goal' && _asString(data, 'date', '') == date) {
      calories += _asDouble(data, 'calories', 0);
      protein += _asDouble(data, 'protein', 0);
      carbs += _asDouble(data, 'carbs', 0);
      fat += _asDouble(data, 'fat', 0);
    }
  }

  final targets =
      NutritionTargetsFields.saved(userData) ??
      NutritionTargetsFields.calculate(userData);

  return (
    calories: calories,
    caloriesGoal: targets?.calories.toDouble() ?? 0,
    protein: protein,
    proteinGoal: targets?.protein.toDouble() ?? 0,
    carbs: carbs,
    carbsGoal: targets?.carbs.toDouble() ?? 0,
    fat: fat,
    fatGoal: targets?.fat.toDouble() ?? 0,
  );
}

Stream<int> _liveStepsStream(Ref ref, String userId) {
  final controller = StreamController<int>();
  final subscription = ref.listen<AsyncValue<int?>>(
    stepsCountProvider(userId),
    (_, next) => controller.add(next.value ?? 0),
    fireImmediately: true,
  );
  ref.onDispose(() {
    subscription.close();
    controller.close();
  });
  return controller.stream;
}
