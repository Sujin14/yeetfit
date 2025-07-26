import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/water_model.dart';

class WaterDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<WaterData?> getWaterData(String userId, String date) async {
  final docRef = _firestore
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('water')
      .collection('water')
      .doc(date);

  final doc = await docRef.get();

  if (doc.exists) {
    return WaterData.fromMap(doc.data()!);
  } else {
    return null;
  }
}


    getWaterGoal(String userId, String date) async {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc('water')
          .collection('water')
          .doc(date);

      final doc = await docRef.get();
      return doc.exists ? doc.data()!['goalGlasses'] ?? 8 : 8;
    }

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

      await docRef.set({
        'date': date,
        'glassesConsumed': glassesConsumed,
        'goalGlasses': goalGlasses,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      }, SetOptions(merge: true));
    }

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
          .where(
            'timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
          )
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      return querySnapshot.docs
          .map((doc) => WaterData.fromMap(doc.data()))
          .toList();
    }
  }

