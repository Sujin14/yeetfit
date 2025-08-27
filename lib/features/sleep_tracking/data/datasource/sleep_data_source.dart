import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/sleep_model.dart';

class SleepDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<SleepData?> getSleepData(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('sleep')
        .collection('sleep')
        .doc(date);

    final doc = await docRef.get();

    if (doc.exists) {
      return SleepData.fromMap(doc.data()!);
    }
    return null;
  }

  Future<double> getSleepGoal(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('sleep')
        .collection('sleep')
        .doc(date);

    final doc = await docRef.get();
    return doc.exists ? (doc.data()!['goalHours'] as num?)?.toDouble() ?? 8.0 : 8.0;
  }

  Future<void> addSleepEntry(
    String userId,
    String date,
    DateTime bedtime,
    DateTime wakeUpTime,
    double duration,
    double goalHours,
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('sleep')
        .collection('sleep')
        .doc(date);

    await docRef.set({
      'date': date,
      'bedtime': Timestamp.fromDate(bedtime),
      'wakeUpTime': Timestamp.fromDate(wakeUpTime),
      'duration': duration,
      'goalHours': goalHours,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    }, SetOptions(merge: true));
  }

  Future<List<SleepData>> getWeeklySleepData(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('sleep')
        .collection('sleep')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    return querySnapshot.docs.map((doc) => SleepData.fromMap(doc.data())).toList();
  }
}