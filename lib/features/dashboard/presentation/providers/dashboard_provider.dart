import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../shared/theme/theme.dart';
import '../../../meal_tracking/data/model/food_model.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../../../steps_tracking/presentation/providers/steps_provider.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final bmiStreamProvider = StreamProvider.family<double, String>((ref, userId) {
  final date = ref.watch(selectedDateProvider).toIso8601String().split('T')[0];

  final userStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots();

  final weightStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('weight')
      .collection('weight')
      .doc(date)
      .snapshots();

  return Rx.combineLatest2(userStream, weightStream, (
    DocumentSnapshot<Map<String, dynamic>> userDoc,
    DocumentSnapshot<Map<String, dynamic>> weightDoc,
  ) {
    final height = (userDoc.data()?['height'] as num?)?.toDouble() ?? 0.0;

    final weight = weightDoc.exists
        ? (weightDoc.data()?['currentWeight'] as num?)?.toDouble()
        : (userDoc.data()?['currentWeight'] as num?)?.toDouble();

    if (height <= 0 || weight == null) return 0.0;

    return weight / ((height / 100) * (height / 100));
  });
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

  final stepsGoalStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('steps')
      .collection('steps')
      .doc('$date-goal')
      .snapshots();

  final waterGoalStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('water')
      .collection('water')
      .doc('$date-goal')
      .snapshots();

  final sleepGoalStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('sleep')
      .collection('sleep')
      .doc('$date-goal')
      .snapshots();

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
    stepsGoalStream,
    waterGoalStream,
    sleepGoalStream,
  ])) {
    final userDoc = snapshots[0] as DocumentSnapshot<Map<String, dynamic>>;
    final stepsDoc = snapshots[1] as DocumentSnapshot<Map<String, dynamic>>;
    final waterDoc = snapshots[2] as DocumentSnapshot<Map<String, dynamic>>;
    final sleepDoc = snapshots[3] as DocumentSnapshot<Map<String, dynamic>>;
    final foodSnapshot = snapshots[4] as QuerySnapshot<Map<String, dynamic>>;
    final weightDoc = snapshots[5] as DocumentSnapshot<Map<String, dynamic>>;
    final liveSteps = snapshots[6] as double;
    final stepsGoalDoc = snapshots[7] as DocumentSnapshot<Map<String, dynamic>>;
    final waterGoalDoc = snapshots[8] as DocumentSnapshot<Map<String, dynamic>>;
    final sleepGoalDoc = snapshots[9] as DocumentSnapshot<Map<String, dynamic>>;

    double calories = 0.0, protein = 0.0, carbs = 0.0, fat = 0.0;
    bool hasData = foodSnapshot.docs.isNotEmpty;
    for (final doc in foodSnapshot.docs) {
      final foodItem = FoodItem.fromMap(doc.data());
      calories += foodItem.calories;
      protein += foodItem.protein;
      carbs += foodItem.carbs;
      fat += foodItem.fat;
    }

    final dailyGoalsDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('food')
        .collection('daily_goals')
        .doc(date);

    final dailyGoalsSnap = await dailyGoalsDocRef.get();
    final Map<String, dynamic>? goalsData =
        dailyGoalsSnap.exists ? dailyGoalsSnap.data() : null;

    double effectiveCaloriesGoal = 0;
    double effectiveProteinGoal = 0;
    double effectiveCarbsGoal = 0;
    double effectiveFatGoal = 0;

    if (goalsData != null) {
      effectiveCaloriesGoal =
          (goalsData['caloriesGoal'] as num?)?.toDouble() ?? 0;
      effectiveProteinGoal =
          (goalsData['proteinGoal'] as num?)?.toDouble() ?? 0;
      effectiveCarbsGoal = (goalsData['carbsGoal'] as num?)?.toDouble() ?? 0;
      effectiveFatGoal = (goalsData['fatGoal'] as num?)?.toDouble() ?? 0;
    }

    if (effectiveCaloriesGoal <= 0) {
      final userMap = userDoc.data();
      final gender = (userMap?['gender'] as String?) ?? 'female';
      final weight = (userMap?['currentWeight'] as num?)?.toDouble() ?? 70.0;
      final height = (userMap?['height'] as num?)?.toDouble() ?? 170.0;
      final age = (userMap?['age'] as num?)?.toDouble() ?? 30.0;
      final activity =
          (userMap?['activityLevel'] as String?) ?? 'Lightly Active';
      final goal = (userMap?['goal'] as String?) ?? 'Maintenance';

      double bmr;
      if (gender.toLowerCase() == 'male') {
        bmr = 10 * weight + 6.25 * height - 5 * age + 5;
      } else {
        bmr = 10 * weight + 6.25 * height - 5 * age - 161;
      }

      double activityFactor =
          activity == 'Moderately Active' ? 1.55 : 1.2;
      double totalCalories = bmr * activityFactor;
      if (goal.toLowerCase() == 'weight loss') totalCalories -= 500;

      effectiveCaloriesGoal = totalCalories;
      effectiveProteinGoal = (totalCalories * 0.20) / 4;
      effectiveFatGoal = (totalCalories * 0.30) / 9;
      effectiveCarbsGoal = (totalCalories * 0.45) / 4;
    } else {
      if (effectiveProteinGoal <= 0) {
        effectiveProteinGoal = (effectiveCaloriesGoal * 0.20) / 4;
      }
      if (effectiveFatGoal <= 0) {
        effectiveFatGoal = (effectiveCaloriesGoal * 0.30) / 9;
      }
      if (effectiveCarbsGoal <= 0) {
        effectiveCarbsGoal = (effectiveCaloriesGoal * 0.45) / 4;
      }
    }

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
      'caloriesGoal': effectiveCaloriesGoal,
      'protein': protein,
      'proteinGoal': effectiveProteinGoal,
      'carbs': carbs,
      'carbsGoal': effectiveCarbsGoal,
      'fat': fat,
      'fatGoal': effectiveFatGoal,
      'caloriesDescription':
          goalsData != null && goalsData['description'] != null
              ? goalsData['description'] as String
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

    yield progress;
  }
});

final dashboardProvider =
    StateNotifierProvider.family<DashboardNotifier, AsyncValue<void>, String>(
        (ref, userId) => DashboardNotifier(ref, userId));

class DashboardNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  final String _userId;

  DashboardNotifier(this._ref, this._userId) : super(const AsyncValue.data(null));

  void navigateToChatbot(BuildContext context) {
    context.go('/chatbot');
  }

  void navigateToChat(BuildContext context) {
    final paymentStatusAsync = _ref.read(paymentStatusProvider);
    paymentStatusAsync.when(
      data: (hasPaid) {
        if (hasPaid) {
          context.go('/admin-list');
        } else {
          context.go('/payment');
        }
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Checking payment status...'),
          ),
        );
      },
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      },
    );
  }
}