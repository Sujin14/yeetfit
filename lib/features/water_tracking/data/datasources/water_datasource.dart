import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeetfit/core/services/streak_service.dart';
import '../model/water_model.dart';

// Data source for water tracking using Firestore.
class WaterDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _water(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('water')
      .collection('water');

  // Fetches water data for a date.
  Future<WaterModel?> getWaterData(String userId, String date) async {
    final doc = await _water(userId).doc(date).get();
    return doc.exists ? WaterModel.fromMap(doc.data()!) : null;
  }

  // Updates water data for a date.
  Future<void> updateWaterData(
    String userId,
    String date,
    int glassesConsumed,
    int goalGlasses,
  ) async {
    await _water(userId).doc(date).set({
      'date': date,
      'glassesConsumed': glassesConsumed,
      'goalGlasses': goalGlasses,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    }, SetOptions(merge: true));
    if (glassesConsumed > 0) unawaited(StreakService().checkAfterLog(userId));
    if (date == StreakService.todayKey()) {
      unawaited(
        StreakService().updateChallengeProgress(
          userId,
          'water',
          glassesConsumed.toDouble(),
        ),
      );
    }
  }

  // Fetches weekly water data in range.
  Future<List<WaterModel>> getWeeklyWaterData(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final querySnapshot = await _water(userId)
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();
    return querySnapshot.docs
        .map((doc) => WaterModel.fromMap(doc.data()))
        .toList();
  }
}
