import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeetfit/core/services/streak_service.dart';
import '../model/sleep_model.dart';

// Data source for sleep tracking using Firestore.
class SleepDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _sleep(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('sleep')
      .collection('sleep');

  // Fetches sleep data for a date.
  Future<SleepModel?> getSleepData(String userId, String date) async {
    final doc = await _sleep(userId).doc(date).get();
    return doc.exists ? SleepModel.fromMap(doc.data()!) : null;
  }

  // Streams sleep data for a date; `null` while no entry exists.
  Stream<SleepModel?> watchSleepData(String userId, String date) {
    return _sleep(userId)
        .doc(date)
        .snapshots()
        .map((doc) => doc.exists ? SleepModel.fromMap(doc.data()!) : null);
  }

  // Adds or updates sleep entry for a date.
  Future<void> addSleepEntry(
    String userId,
    String date,
    DateTime bedtime,
    DateTime wakeUpTime,
    double duration,
    double goalHours,
  ) async {
    await _sleep(userId).doc(date).set({
      'date': date,
      'bedtime': Timestamp.fromDate(bedtime),
      'wakeUpTime': Timestamp.fromDate(wakeUpTime),
      'duration': duration,
      'goalHours': goalHours,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    }, SetOptions(merge: true));
    if (duration > 0) unawaited(StreakService().checkAfterLog(userId));
    if (date == StreakService.todayKey()) {
      unawaited(
        StreakService().updateChallengeProgress(userId, 'sleep', duration),
      );
    }
  }

  // Updates only the sleep goal for a date, leaving logged times untouched.
  Future<void> setSleepGoal(String userId, String date, double goalHours) {
    return _sleep(userId).doc(date).set({
      'date': date,
      'goalHours': goalHours,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    }, SetOptions(merge: true));
  }

  // Fetches weekly sleep data in range.
  Future<List<SleepModel>> getWeeklySleepData(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final querySnapshot = await _sleep(userId)
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();
    return querySnapshot.docs
        .map((doc) => SleepModel.fromMap(doc.data()))
        .toList();
  }
}
