import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeetfit/core/utils/nutrition_targets_fields.dart';
import '../model/weight_model.dart';

// Data source for weight tracking operations using Firestore.
class WeightDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _user(String userId) =>
      _firestore.collection('users').doc(userId);

  CollectionReference<Map<String, dynamic>> _weight(String userId) =>
      _user(userId).collection('progress').doc('weight').collection('weight');

  // Updates the user's currentWeight (recalculating the daily nutrition
  // targets from it) and today's weight entry.
  Future<void> updateWeight(
    String userId,
    double currentWeight,
    double? goalWeight,
    double? initialWeight,
    DateTime? targetDate,
  ) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final profile = (await _user(userId).get()).data();
    final targets = NutritionTargetsFields.calculate({
      ...?profile,
      'currentWeight': currentWeight,
    });

    await _user(userId).set({
      'currentWeight': currentWeight,
      if (targets != null) ...NutritionTargetsFields.toMap(targets),
      if (goalWeight != null || initialWeight != null || targetDate != null)
        'weightGoal': {
          'goalWeight': ?goalWeight,
          'initialWeight': ?initialWeight,
          if (targetDate != null) 'targetDate': Timestamp.fromDate(targetDate),
        },
    }, SetOptions(merge: true));

    await _weight(userId).doc(today).set({
      'date': today,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight ?? 70.0,
      'initialWeight': initialWeight ?? 75.0,
      'targetDate': targetDate != null ? Timestamp.fromDate(targetDate) : null,
      'timestamp': Timestamp.fromDate(DateTime.parse('$today 00:00:00')),
    }, SetOptions(merge: true));
  }

  // Fetches weight data for a specific date.
  Future<WeightModel?> getWeightData(String userId, String date) async {
    final doc = await _weight(userId).doc(date).get();
    return doc.exists ? WeightModel.fromMap(doc.data()!) : null;
  }

  // Fetches user's weight goal from profile.
  Future<WeightModel?> getUserWeightGoal(String userId) async {
    final doc = await _user(userId).get();
    final weightGoal = doc.data()?['weightGoal'];
    if (weightGoal == null) return null;
    return WeightModel.fromMap({
      'date': DateTime.now().toIso8601String().split('T')[0],
      'currentWeight': 75.0,
      ...weightGoal,
    });
  }

  // Sets user's weight goal in profile.
  Future<void> setUserWeightGoal(
    String userId,
    double goalWeight,
    double initialWeight,
    DateTime? targetDate,
  ) {
    return _user(userId).set({
      'weightGoal': {
        'goalWeight': goalWeight,
        'initialWeight': initialWeight,
        'targetDate': targetDate != null
            ? Timestamp.fromDate(targetDate)
            : null,
      },
    }, SetOptions(merge: true));
  }

  // Fetches weekly weight data within date range.
  Future<List<WeightModel>> getWeeklyWeightData(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final result = await _weight(userId)
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();
    return result.docs.map((doc) => WeightModel.fromMap(doc.data())).toList();
  }
}
