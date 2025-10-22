import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/weight_model.dart';

// Data source for weight tracking operations using Firestore.
class WeightDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Updates both user's currentWeight and today's weight entry.
  Future<void> updateWeight(
    String userId,
    double currentWeight,
    double? goalWeight,
    double? initialWeight,
    DateTime? targetDate,
  ) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final userDocRef = _firestore.collection('users').doc(userId);
    final weightDocRef = userDocRef
        .collection('progress')
        .doc('weight')
        .collection('weight')
        .doc(today);

    try {
      // Update user's currentWeight on user doc.
      await userDocRef.set({
        'currentWeight': currentWeight,
        if (goalWeight != null || initialWeight != null || targetDate != null)
          'weightGoal': {
            if (goalWeight != null) 'goalWeight': goalWeight,
            if (initialWeight != null) 'initialWeight': initialWeight,
            if (targetDate != null) 'targetDate': Timestamp.fromDate(targetDate),
          },
      }, SetOptions(merge: true));

      await weightDocRef.set({
        'date': today,
        'currentWeight': currentWeight,
        'goalWeight': goalWeight ?? 70.0,
        'initialWeight': initialWeight ?? 75.0,
        'targetDate': targetDate != null ? Timestamp.fromDate(targetDate) : null,
        'timestamp': Timestamp.fromDate(DateTime.parse('$today 00:00:00')),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  // Fetches weight data for a specific date.
  Future<WeightData?> getWeightData(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('weight')
        .collection('weight')
        .doc(date);

    try {
      final doc = await docRef.get();
      if (doc.exists) {
        return WeightData.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Fetches user's weight goal from profile.
  Future<WeightData?> getUserWeightGoal(String userId) async {
    final docRef = _firestore.collection('users').doc(userId);

    try {
      final doc = await docRef.get();
      if (doc.exists && doc.data()?['weightGoal'] != null) {
        return WeightData.fromMap({
          'date': DateTime.now().toIso8601String().split('T')[0],
          'currentWeight': 75.0,
          ...doc.data()!['weightGoal'],
        });
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Adds a weight entry for a specific date.
  Future<void> addWeightEntry(
    String userId,
    String date,
    double currentWeight,
    double goalWeight,
    double initialWeight,
    DateTime? targetDate,
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('weight')
        .collection('weight')
        .doc(date);

    try {
      await docRef.set({
        'date': date,
        'currentWeight': currentWeight,
        'goalWeight': goalWeight,
        'initialWeight': initialWeight,
        'targetDate': targetDate != null ? Timestamp.fromDate(targetDate) : null,
        'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  // Sets user's weight goal in profile.
  Future<void> setUserWeightGoal(
    String userId,
    double goalWeight,
    double initialWeight,
    DateTime? targetDate,
  ) async {
    final docRef = _firestore.collection('users').doc(userId);

    try {
      await docRef.set({
        'weightGoal': {
          'goalWeight': goalWeight,
          'initialWeight': initialWeight,
          'targetDate': targetDate != null ? Timestamp.fromDate(targetDate) : null,
        },
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  // Fetches weekly weight data within date range.
  Future<List<WeightData>> getWeeklyWeightData(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final querySnapshot = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('weight')
        .collection('weight')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate));

    try {
      final result = await querySnapshot.get();
      return result.docs.map((doc) => WeightData.fromMap(doc.data())).toList();
    } catch (e) {
      rethrow;
    }
  }
}