// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:rxdart/rxdart.dart';
// import '../../../steps_tracking/presentation/providers/steps_provider.dart';
// import '../../../../shared/theme/theme.dart';

// final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// // --- BMI Providers ---
// final bmiStreamProvider = StreamProvider.family<double, String>((ref, userId) {
//   final date = ref.watch(selectedDateProvider).toIso8601String().split('T')[0];

//   final userStream =
//       FirebaseFirestore.instance.collection('users').doc(userId).snapshots();

//   final weightStream = FirebaseFirestore.instance
//       .collection('users')
//       .doc(userId)
//       .collection('progress')
//       .doc('weight')
//       .collection('weight')
//       .doc(date)
//       .snapshots();

//   return Rx.combineLatest2(userStream, weightStream,
//       (DocumentSnapshot<Map<String, dynamic>> userDoc,
//           DocumentSnapshot<Map<String, dynamic>> weightDoc) {
//     final height = (userDoc.data()?['height'] as num?)?.toDouble() ?? 0.0;
//     final weight = weightDoc.exists
//         ? (weightDoc.data()?['currentWeight'] as num?)?.toDouble()
//         : (userDoc.data()?['currentWeight'] as num?)?.toDouble();

//     if (height <= 0 || weight == null) return 0.0;
//     return weight / ((height / 100) * (height / 100));
//   });
// });

// final bmiCategoryProvider = Provider.family<String, double>((ref, bmi) {
//   if (bmi < 18.5) return 'Underweight';
//   if (bmi < 25) return 'Normal';
//   if (bmi < 30) return 'Overweight';
//   return 'Obesity';
// });

// final bmiColorProvider = Provider.family<Color, double>((ref, bmi) {
//   if (bmi < 18.5) return AppTheme.colors['bmiUnderweight']!;
//   if (bmi < 25) return AppTheme.colors['bmiNormal']!;
//   if (bmi < 30) return AppTheme.colors['bmiOverweight']!;
//   return AppTheme.colors['bmiObese']!;
// });

// final bmiSuggestionProvider = Provider.family<String, double>((ref, bmi) {
//   if (bmi < 18.5) {
//     return 'Consider a balanced diet with more calories and consult a nutritionist.';
//   }
//   if (bmi < 25) {
//     return 'Great job! Maintain a healthy lifestyle with regular exercise and balanced nutrition.';
//   }
//   if (bmi < 30) {
//     return 'Incorporate regular physical activity and a balanced diet to achieve a healthy weight.';
//   }
//   return 'Consult a healthcare professional for a personalized weight management plan.';
// });

// final progressColorProvider = Provider.family<Color, double>((ref, percent) {
//   if (percent < 0.25) return AppTheme.colors['noProgress']!;
//   if (percent < 0.5) return AppTheme.colors['quarterProgress']!;
//   if (percent < 0.75) return AppTheme.colors['halfProgress']!;
//   return AppTheme.colors['fullProgress']!;
// });

// // --- User Data Future Provider ---
// final userDataFutureProvider =
//     FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
//   final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//   return doc.data();
// });

// // --- Daily Progress Stream Provider ---
// final dailyProgressStreamProvider =
//     StreamProvider.family<Map<String, dynamic>, String>((ref, userId) async* {
//   final firestore = FirebaseFirestore.instance;
//   final date = ref.watch(selectedDateProvider).toIso8601String().split('T')[0];
//   final today = DateTime.now().toIso8601String().split('T')[0];

//   // --- Helpers ---
//   double _asDouble(Map<String, dynamic>? m, String key, double fallback) {
//     final v = m == null ? null : m[key];
//     if (v is num) return v.toDouble();
//     if (v is String) return double.tryParse(v) ?? fallback;
//     return fallback;
//   }

//   String _asString(Map<String, dynamic>? m, String key, String fallback) {
//     final v = m == null ? null : m[key];
//     return v?.toString() ?? fallback;
//   }

//   // --- Streams ---
//   final userStream = firestore.collection('users').doc(userId).snapshots();
//   final stepsDocStream = firestore
//       .collection('users')
//       .doc(userId)
//       .collection('progress')
//       .doc('steps')
//       .collection('steps')
//       .doc(date)
//       .snapshots();
//   final waterDocStream = firestore
//       .collection('users')
//       .doc(userId)
//       .collection('progress')
//       .doc('water')
//       .collection('water')
//       .doc(date)
//       .snapshots();
//   final sleepDocStream = firestore
//       .collection('users')
//       .doc(userId)
//       .collection('progress')
//       .doc('sleep')
//       .collection('sleep')
//       .doc(date)
//       .snapshots();
//   final weightDocStream = firestore
//       .collection('users')
//       .doc(userId)
//       .collection('progress')
//       .doc('weight')
//       .collection('weight')
//       .doc(date)
//       .snapshots();
//   final foodCollectionStream = firestore
//       .collection('users')
//       .doc(userId)
//       .collection('progress')
//       .doc('food')
//       .collection('food')
//       .snapshots();

//   final stepsProviderStream = date == today
//       ? ref.watch(stepsCountStreamProvider(userId).stream).startWith(0.0).onErrorReturn(0.0)
//       : Stream.value(0.0);

//   // --- Combine streams ---
//   await for (final snapshots in CombineLatestStream.list([
//     userStream,
//     stepsDocStream,
//     waterDocStream,
//     sleepDocStream,
//     foodCollectionStream,
//     weightDocStream,
//     stepsProviderStream,
//   ])) {
//     final userDoc = snapshots[0] as DocumentSnapshot<Map<String, dynamic>>;
//     final stepsDoc = snapshots[1] as DocumentSnapshot<Map<String, dynamic>>;
//     final waterDoc = snapshots[2] as DocumentSnapshot<Map<String, dynamic>>;
//     final sleepDoc = snapshots[3] as DocumentSnapshot<Map<String, dynamic>>;
//     final foodDoc = snapshots[4] as QuerySnapshot<Map<String, dynamic>>;
//     final weightDoc = snapshots[5] as DocumentSnapshot<Map<String, dynamic>>;
//     final liveSteps = snapshots[6] as double;

//     // --- Food totals & goal ---
//     double calories = 0, protein = 0, carbs = 0, fat = 0;
//     double caloriesGoal = 0, proteinGoal = 0, carbsGoal = 0, fatGoal = 0;
//     bool hasFoodData = false;

//     for (final doc in foodDoc.docs) {
//       final data = doc.data();
//       if (doc.id == '$date-goal') {
//         caloriesGoal = _asDouble(data, 'caloriesGoal', 0);
//         proteinGoal = _asDouble(data, 'proteinGoal', 0);
//         carbsGoal = _asDouble(data, 'carbsGoal', 0);
//         fatGoal = _asDouble(data, 'fatGoal', 0);
//       } else if (_asString(data, 'date', '') == date) {
//         calories += _asDouble(data, 'calories', 0);
//         protein += _asDouble(data, 'protein', 0);
//         carbs += _asDouble(data, 'carbs', 0);
//         fat += _asDouble(data, 'fat', 0);
//         hasFoodData = true;
//       }
//     }

//     // --- Fallback food goals ---
//     if (caloriesGoal <= 0) {
//       final userMap = userDoc.data();
//       final gender = (_asString(userMap, 'gender', 'female')).toLowerCase();
//       final weight = _asDouble(userMap, 'currentWeight', 70);
//       final height = _asDouble(userMap, 'height', 170);
//       final age = _asDouble(userMap, 'age', 30);
//       final activity = _asString(userMap, 'activityLevel', 'Lightly Active');
//       final goal = _asString(userMap, 'goal', 'Maintenance');

//       double bmr = gender == 'male'
//           ? 10 * weight + 6.25 * height - 5 * age + 5
//           : 10 * weight + 6.25 * height - 5 * age - 161;

//       double activityFactor = activity == 'Moderately Active' ? 1.55 : 1.2;
//       double totalCalories = bmr * activityFactor;
//       if (goal == 'weight loss') totalCalories -= 500;

//       caloriesGoal = totalCalories;
//       proteinGoal = (totalCalories * 0.20) / 4;
//       fatGoal = (totalCalories * 0.30) / 9;
//       carbsGoal = (totalCalories * 0.45) / 4;
//     }

//     // --- Steps ---
//     final steps = (date == today && liveSteps > 0)
//         ? liveSteps
//         : _asDouble(stepsDoc.data(), 'steps', 0);
//     final stepsGoal = _asDouble(stepsDoc.data(), 'goalSteps', 10000);
//     final stepsDescription = _asString(
//         stepsDoc.data(), 'description', 'Steps improve heart health and boost stamina.');

//     // --- Water ---
//     final water = _asDouble(waterDoc.data(), 'glassesConsumed', 0);
//     final waterGoal = _asDouble(waterDoc.data(), 'goalGlasses', 8);
//     final waterDescription = _asString(
//         waterDoc.data(), 'description', 'Hydration supports metabolism and energy levels.');

//     // --- Sleep ---
//     final sleep = _asDouble(sleepDoc.data(), 'duration', 0);
//     final sleepGoal = _asDouble(sleepDoc.data(), 'goalHours', 8);
//     final sleepDescription = _asString(
//         sleepDoc.data(), 'description', 'Sleep enhances recovery and mental focus.');

//     // --- Weight ---
//     final currentWeight = _asDouble(weightDoc.data(), 'currentWeight',
//         _asDouble(userDoc.data(), 'currentWeight', 77));
//     final weightGoal =
//         _asDouble(weightDoc.data(), 'goalWeight', _asDouble(userDoc.data(), 'goalWeight', 70));
//     final weightDescription = 'Track your weight to monitor progress.';

//     final hasData =
//         hasFoodData || steps > 0 || water > 0 || sleep > 0 || currentWeight > 0;

//     yield {
//       // steps
//       'steps': steps,
//       'stepsGoal': stepsGoal,
//       'stepsDescription': stepsDescription,

//       // water
//       'water': water,
//       'waterGoal': waterGoal,
//       'waterDescription': waterDescription,

//       // food/macros
//       'calories': calories,
//       'caloriesGoal': caloriesGoal,
//       'protein': protein,
//       'proteinGoal': proteinGoal,
//       'carbs': carbs,
//       'carbsGoal': carbsGoal,
//       'fat': fat,
//       'fatGoal': fatGoal,

//       // sleep
//       'sleep': sleep,
//       'sleepGoal': sleepGoal,
//       'sleepDescription': sleepDescription,

//       // weight
//       'currentWeight': currentWeight,
//       'weightGoal': weightGoal,
//       'weightDescription': weightDescription,

//       'hasData': hasData,
//     };
//   }
// });
