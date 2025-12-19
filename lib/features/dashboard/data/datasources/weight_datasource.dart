// lib/features/dashboard/data/datasources/weight_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/weight_data.dart';

class WeightDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      return doc.exists ? WeightData.fromMap(doc.data()!) : null;
    } catch (e) {
      rethrow;
    }
  }

  Stream<WeightData?> getWeightStream(String userId, String date) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('weight')
        .collection('weight')
        .doc(date)
        .snapshots()
        .map((doc) => doc.exists ? WeightData.fromMap(doc.data()!) : null)
        .handleError((e) => throw e);
  }
}
