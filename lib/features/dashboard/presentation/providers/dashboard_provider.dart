import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../../meal_tracking/data/model/food_model.dart';
import '../../../steps_tracking/presentation/providers/steps_provider.dart';
import '../../../../shared/theme/theme.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final bmiFutureProvider =
    FutureProvider.family<double, String>((ref, userId) async {
  final date = ref.watch(selectedDateProvider).toIso8601String().split('T')[0];
  final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  final weightDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('weight')
      .collection('weight')
      .doc(date)
      .get();

  final height = (userDoc.data()?['height'] as num?)?.toDouble() ?? 181.0;
  final weight = weightDoc.exists
      ? (weightDoc.data()?['currentWeight'] as num?)?.toDouble() ?? 77.0
      : (userDoc.data()?['weight'] as num?)?.toDouble() ?? 77.0;

  if (height <= 0) return 0.0;
  return weight / ((height / 100) * (height / 100));
});

final bmiCategoryProvider = Provider.family<String, double>((ref, bmi) {
  if (bmi < 18.5) return 'Underweight';
  if (bmi < 25) return 'Normal';
  if (bmi < 30) return 'Overweight';
  return 'Obesity';
});

final bmiColorProvider = Provider.family<Color, double>((ref, bmi) {
  if (bmi < 18.5) return AppTheme.colors['bmiUnderweight']!;
  if (bmi < 25) return AppTheme.colors['bmiNormal']!;
  if (bmi < 30) return AppTheme.colors['bmiOverweight']!;
  return AppTheme.colors['bmiObese']!;
});

final bmiSuggestionProvider = Provider.family<String, double>((ref, bmi) {
  if (bmi < 18.5) {
    return 'Consider a balanced diet with more calories and consult a nutritionist.';
  }
  if (bmi < 25) {
    return 'Great job! Maintain a healthy lifestyle with regular exercise and balanced nutrition.';
  }
  if (bmi < 30) {
    return 'Incorporate regular physical activity and a balanced diet to achieve a healthy weight.';
  }
  return 'Consult a healthcare professional for a personalized weight management plan.';
});

final progressColorProvider = Provider.family<Color, double>((ref, percent) {
  if (percent < 0.25) return AppTheme.colors['noProgress']!;
  if (percent < 0.5) return AppTheme.colors['quarterProgress']!;
  if (percent < 0.75) return AppTheme.colors['halfProgress']!;
  return AppTheme.colors['fullProgress']!;
});

final userDataFutureProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return doc.data();
});

final dailyProgressStreamProvider =
    StreamProvider.family<Map<String, dynamic>, String>((ref, userId) async* {
  final date = ref.watch(selectedDateProvider).toIso8601String().split('T')[0];
  final today = DateTime.now().toIso8601String().split('T')[0];

  // Firestore base streams
  final userStream =
      FirebaseFirestore.instance.collection('users').doc(userId).snapshots();

  final stepsStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('steps')
      .collection('steps')
      .doc(date)
      .snapshots();

  final waterStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('water')
      .collection('water')
      .doc(date)
      .snapshots();

  final sleepStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('sleep')
      .collection('sleep')
      .doc(date)
      .snapshots();

  final foodStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('food')
      .collection('food')
      .where('date', isEqualTo: date)
      .snapshots();

  final weightStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('weight')
      .collection('weight')
      .doc(date)
      .snapshots();

  // ✅ patched: always emit 0.0 first for today
  final stepsProviderStream = date == today
      ? ref
          .watch(stepsCountStreamProvider(userId).stream)
          .startWith(0.0)
          .onErrorReturn(0.0)
      : Stream.value(0.0);

  await for (final snapshots in CombineLatestStream.list([
    userStream,
    stepsStream,
    waterStream,
    sleepStream,
    foodStream,
    weightStream,
    stepsProviderStream,
  ] as Iterable<Stream>)) {
    final userDoc = snapshots[0] as DocumentSnapshot<Map<String, dynamic>>;
    final stepsDoc = snapshots[1] as DocumentSnapshot<Map<String, dynamic>>;
    final waterDoc = snapshots[2] as DocumentSnapshot<Map<String, dynamic>>;
    final sleepDoc = snapshots[3] as DocumentSnapshot<Map<String, dynamic>>;
    final foodSnapshot = snapshots[4] as QuerySnapshot<Map<String, dynamic>>;
    final weightDoc = snapshots[5] as DocumentSnapshot<Map<String, dynamic>>;
    final liveSteps = snapshots[6] as double;

    print("👤 User data: ${userDoc.data()}");
    print("👟 Firestore steps: ${stepsDoc.data()}");
    print("📲 Live steps (pedometer): $liveSteps");
    print("💧 Water data: ${waterDoc.data()}");
    print("😴 Sleep data: ${sleepDoc.data()}");
    print("🍎 Food docs: ${foodSnapshot.docs.length}");
    print("⚖️ Weight data: ${weightDoc.data()}");

    // Process meal data
    double calories = 0.0, protein = 0.0, carbs = 0.0, fat = 0.0;
    bool hasData = foodSnapshot.docs.isNotEmpty;

    for (final doc in foodSnapshot.docs) {
      final foodItem = FoodItem.fromMap(doc.data());
      calories += foodItem.calories;
      protein += foodItem.protein;
      carbs += foodItem.carbs;
      fat += foodItem.fat;
    }

    // Fetch goals
    final foodGoalDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('food')
        .collection('food')
        .doc('$date-goal')
        .get();

    final waterGoalDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('water')
        .collection('water')
        .doc('$date-goal')
        .get();

    final sleepGoalDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('sleep')
        .collection('sleep')
        .doc('$date-goal')
        .get();

    final stepsGoalDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .doc('$date-goal')
        .get();

    // ✅ patched: use live steps if today
    final steps = date == today && liveSteps > 0
        ? liveSteps
        : (stepsDoc.exists
            ? (stepsDoc.data()?['steps'] as num?)?.toDouble() ?? 0.0
            : 0.0);

    hasData = hasData ||
        steps > 0 ||
        stepsDoc.exists ||
        waterDoc.exists ||
        sleepDoc.exists ||
        weightDoc.exists;

    final progress = {
      'steps': steps,
      'stepsGoal': stepsGoalDoc.exists
          ? (stepsGoalDoc.data()?['goalSteps'] as num?)?.toDouble() ?? 10000.0
          : 10000.0,
      'stepsDescription': stepsDoc.exists && stepsDoc.data() != null
          ? stepsDoc.data()!['description'] as String? ??
              'Steps improve heart health and boost stamina.'
          : 'Steps improve heart health and boost stamina.',
      'water': waterDoc.exists
          ? (waterDoc.data()?['glassesConsumed'] as num?)?.toDouble() ?? 0.0
          : 0.0,
      'waterGoal': waterGoalDoc.exists
          ? (waterGoalDoc.data()?['goalGlasses'] as num?)?.toDouble() ?? 8.0
          : 8.0,
      'waterDescription': waterDoc.exists && waterDoc.data() != null
          ? waterDoc.data()!['description'] as String? ??
              'Hydration supports metabolism and energy levels.'
          : 'Hydration supports metabolism and energy levels.',
      'calories': calories,
      'caloriesGoal': foodGoalDoc.exists
          ? (foodGoalDoc.data()?['caloriesGoal'] as num?)?.toDouble() ?? 1750.0
          : 1750.0,
      'protein': protein,
      'proteinGoal': foodGoalDoc.exists
          ? (foodGoalDoc.data()?['proteinGoal'] as num?)?.toDouble() ?? 50.0
          : 50.0,
      'carbs': carbs,
      'carbsGoal': foodGoalDoc.exists
          ? (foodGoalDoc.data()?['carbsGoal'] as num?)?.toDouble() ?? 250.0
          : 250.0,
      'fat': fat,
      'fatGoal': foodGoalDoc.exists
          ? (foodGoalDoc.data()?['fatGoal'] as num?)?.toDouble() ?? 70.0
          : 70.0,
      'caloriesDescription': foodGoalDoc.exists && foodGoalDoc.data() != null
          ? foodGoalDoc.data()!['description'] as String? ??
              'Track your daily nutrition to meet your goals.'
          : 'Track your daily nutrition to meet your goals.',
      'sleep': sleepDoc.exists
          ? (sleepDoc.data()?['duration'] as num?)?.toDouble() ?? 0.0
          : 0.0,
      'sleepGoal': sleepGoalDoc.exists
          ? (sleepGoalDoc.data()?['goalHours'] as num?)?.toDouble() ?? 8.0
          : 8.0,
      'sleepDescription': sleepDoc.exists && sleepDoc.data() != null
          ? sleepDoc.data()!['description'] as String? ??
              'Sleep enhances recovery and mental focus.'
          : 'Sleep enhances recovery and mental focus.',
      'currentWeight': weightDoc.exists
          ? (weightDoc.data()?['currentWeight'] as num?)?.toDouble() ??
              (userDoc.data()?['currentWeight'] as num?)?.toDouble() ??
              77.0
          : (userDoc.data()?['currentWeight'] as num?)?.toDouble() ?? 77.0,
      'weightGoal': weightDoc.exists
          ? (weightDoc.data()?['goalWeight'] as num?)?.toDouble() ??
              (userDoc.data()?['goalWeight'] as num?)?.toDouble() ??
              70.0
          : (userDoc.data()?['goalWeight'] as num?)?.toDouble() ?? 70.0,
      'weightDescription': 'Track your weight to monitor progress.',
      'hasData': hasData,
    };

    print("📊 Final daily progress [$date] → $progress");
    yield progress;
  }
});
