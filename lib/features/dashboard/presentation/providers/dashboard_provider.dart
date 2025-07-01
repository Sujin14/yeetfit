import 'package:hooks_riverpod/hooks_riverpod.dart';

// Hard-coded user data for UI development
final userDataProvider = Provider<Map<String, dynamic>>((ref) {
  return {'name': 'Sujin', 'height': 170.0, 'weight': 70.0};
});

// Hard-coded daily progress data for UI development
final dailyProgressProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'steps': 5000,
    'stepsGoal': 10000,
    'stepsDescription': 'Steps improve heart health and boost stamina.',
    'water': .5,
    'waterGoal': 2.0,
    'waterDescription': 'Hydration supports metabolism and energy levels.',
    'calories': 2000,
    'caloriesGoal': 2000,
    'caloriesDescription': 'Calories fuel your daily activities.',
    'sleep': 1.0,
    'sleepGoal': 8.0,
    'sleepDescription': 'Sleep enhances recovery and mental focus.',
  };
});

// Calculate BMI from user data
final bmiProvider = Provider<double>((ref) {
  final userData = ref.watch(userDataProvider);
  final height = userData['height'] / 100;
  final weight = userData['weight'];
  return weight / (height * height);
});
