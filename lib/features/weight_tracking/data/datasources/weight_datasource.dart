import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/weight_model.dart';

class WeightDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Centralized method to update both users.currentWeight and today's weight entry
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
      // 1️⃣ Update user's currentWeight on user doc
      await userDocRef.set({
        'currentWeight': currentWeight,
        // Optionally keep goal info in users doc as well
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
      print('WeightDataSource.updateWeight: Error=$e');
      rethrow;
    }
  }
  Future<WeightData?> getWeightData(String userId, String date) async {
    print('getWeightData: userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}, date=$date');
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('weight')
        .collection('weight')
        .doc(date);
    print('getWeightData: Querying path=users/$userId/progress/weight/weight/$date');

    try {
      final doc = await docRef.get();
      if (doc.exists) {
        print('getWeightData: Data found for userId=$userId, date=$date');
        return WeightData.fromMap(doc.data()!);
      } else {
        print('getWeightData: No data found for userId=$userId, date=$date');
      }
      return null;
    } catch (e) {
      print('getWeightData: Error for userId=$userId, date=$date: $e');
      rethrow;
    }
  }

  Future<WeightData?> getUserWeightGoal(String userId) async {
    print('getUserWeightGoal: userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}');
    final docRef = _firestore.collection('users').doc(userId);
    print('getUserWeightGoal: Querying path=users/$userId');

    try {
      final doc = await docRef.get();
      if (doc.exists && doc.data()!['weightGoal'] != null) {
        print('getUserWeightGoal: Goal found for userId=$userId');
        return WeightData.fromMap({
          'date': DateTime.now().toIso8601String().split('T')[0],
          'currentWeight': 75.0, // Default for goal fetch
          ...doc.data()!['weightGoal'],
        });
      } else {
        print('getUserWeightGoal: No goal found for userId=$userId');
      }
      return null;
    } catch (e) {
      print('getUserWeightGoal: Error for userId=$userId: $e');
      rethrow;
    }
  }

  Future<void> addWeightEntry(
    String userId,
    String date,
    double currentWeight,
    double goalWeight,
    double initialWeight,
    DateTime? targetDate,
  ) async {
    print('addWeightEntry: userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}, date=$date, currentWeight=$currentWeight, goalWeight=$goalWeight, initialWeight=$initialWeight, targetDate=$targetDate');
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('weight')
        .collection('weight')
        .doc(date);
    print('addWeightEntry: Writing to path=users/$userId/progress/weight/weight/$date');

    try {
      await docRef.set({
        'date': date,
        'currentWeight': currentWeight,
        'goalWeight': goalWeight,
        'initialWeight': initialWeight,
        'targetDate': targetDate != null ? Timestamp.fromDate(targetDate) : null,
        'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
      }, SetOptions(merge: true));
      print('addWeightEntry: Successfully wrote data for userId=$userId, date=$date');
    } catch (e) {
      print('addWeightEntry: Error for userId=$userId, date=$date: $e');
      rethrow;
    }
  }

  Future<void> setUserWeightGoal(
    String userId,
    double goalWeight,
    double initialWeight,
    DateTime? targetDate,
  ) async {
    print('setUserWeightGoal: userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}, goalWeight=$goalWeight, initialWeight=$initialWeight, targetDate=$targetDate');
    final docRef = _firestore.collection('users').doc(userId);
    print('setUserWeightGoal: Writing to path=users/$userId');

    try {
      await docRef.set({
        'weightGoal': {
          'goalWeight': goalWeight,
          'initialWeight': initialWeight,
          'targetDate': targetDate != null ? Timestamp.fromDate(targetDate) : null,
        },
      }, SetOptions(merge: true));
      print('setUserWeightGoal: Successfully wrote goal for userId=$userId');
    } catch (e) {
      print('setUserWeightGoal: Error for userId=$userId: $e');
      rethrow;
    }
  }

  Future<List<WeightData>> getWeeklyWeightData(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    print('getWeeklyWeightData: userId=$userId, authUid=${FirebaseAuth.instance.currentUser?.uid}, startDate=$startDate, endDate=$endDate');
    final querySnapshot = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('weight')
        .collection('weight')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    print('getWeeklyWeightData: Querying path=users/$userId/progress/weight/weight with timestamp range');

    try {
      final result = await querySnapshot.get();
      final data = result.docs.map((doc) => WeightData.fromMap(doc.data())).toList();
      print('getWeeklyWeightData: Retrieved ${data.length} entries for userId=$userId');
      return data;
    } catch (e) {
      print('getWeeklyWeightData: Error for userId=$userId: $e');
      rethrow;
    }
  }
} 