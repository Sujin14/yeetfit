import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/water_model.dart';

// Data source for water tracking using Firestore.
class WaterDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetches water data for a date.
  Future<WaterData?> getWaterData(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('water')
        .collection('water')
        .doc(date);

    try {
      final doc = await docRef.get();
      if (doc.exists) {
        return WaterData.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Fetches water goal for a date.
  Future<int> getWaterGoal(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('water')
        .collection('water')
        .doc(date);

    try {
      final doc = await docRef.get();
      return doc.exists ? (doc.data()?['goalGlasses'] ?? 8) : 8;
    } catch (e) {
      rethrow;
    }
  }

  // Updates water data for a date.
  Future<void> updateWaterData(
    String userId,
    String date,
    int glassesConsumed,
    int goalGlasses,
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('water')
        .collection('water')
        .doc(date);

    try {
      await docRef.set({
        'date': date,
        'glassesConsumed': glassesConsumed,
        'goalGlasses': goalGlasses,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  // Fetches weekly water data in range.
  Future<List<WaterData>> getWeeklyWaterData(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('water')
        .collection('water')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    try {
      return querySnapshot.docs.map((doc) => WaterData.fromMap(doc.data())).toList();
    } catch (e) {
      rethrow;
    }
  }
}