import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/steps_model.dart';

class StepsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<StepsData?> getStepsData(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .doc(date);

    final doc = await docRef.get();
    if (doc.exists) {
      return StepsData.fromMap(doc.data()!);
    }
    return null;
  }

  Future<int> getStepsGoal(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .doc(date);

    final doc = await docRef.get();
    return doc.exists ? (doc.data()!['goalSteps'] as num?)?.toInt() ?? 10000 : 10000;
  }

  Future<void> addStepsEntry(
    String userId,
    String date,
    int steps,
    int goalSteps,
    double caloriesBurned,
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .doc(date);

    await docRef.set({
      'date': date,
      'steps': steps,
      'goalSteps': goalSteps,
      'caloriesBurned': caloriesBurned,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    }, SetOptions(merge: true));
  }

  Future<List<StepsData>> getWeeklyStepsData(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    return querySnapshot.docs.map((doc) => StepsData.fromMap(doc.data())).toList();
  }
}