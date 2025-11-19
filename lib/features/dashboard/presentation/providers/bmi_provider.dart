import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'selected_date_provider.dart';

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

  return Rx.combineLatest2(userStream, weightStream, (userDoc, weightDoc) {
    final height = (userDoc.data()?['height'] as num?)?.toDouble() ?? 0.0;
    final weight = weightDoc.exists
        ? (weightDoc.data()?['currentWeight'] as num?)?.toDouble()
        : (userDoc.data()?['currentWeight'] as num?)?.toDouble();

    if (height <= 0 || weight == null || weight <= 0) return 0.0;
    return weight / ((height / 100) * (height / 100));
  });
});

final bmiCategoryProvider = Provider.family<String, double>((ref, bmi) {
  if (bmi < 18.5) return 'Underweight';
  if (bmi < 25) return 'Normal';
  if (bmi < 30) return 'Overweight';
  return 'Obesity';
});

final bmiSuggestionProvider = Provider.family<String, double>((ref, bmi) {
  if (bmi < 18.5)
    return 'Consider a balanced diet with more calories and consult a nutritionist.';
  if (bmi < 25)
    return 'Great job! Maintain a healthy lifestyle with regular exercise and balanced nutrition.';
  if (bmi < 30)
    return 'Incorporate regular physical activity and a balanced diet to achieve a healthy weight.';
  return 'Consult a healthcare professional for a personalized weight management plan.';
});

final progressColorLogicProvider = Provider.family<String, double>((
  ref,
  percent,
) {
  if (percent < 0.25) return 'none';
  if (percent < 0.5) return '25';
  if (percent < 0.75) return '50';
  return 'full';
});
