// lib/features/dashboard/data/datasources/progress_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getProgressData(
    String userId,
    String type,
    String date,
  ) async {
    try {
      final docPath = type == 'meal'
          ? _firestore
                .collection('users')
                .doc(userId)
                .collection('progress')
                .doc('food')
                .collection('daily_goals')
                .doc(date)
          : _firestore
                .collection('users')
                .doc(userId)
                .collection('progress')
                .doc(type)
                .collection(type)
                .doc(date);
      final doc = await docPath.get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      rethrow;
    }
  }

  Stream<Map<String, dynamic>?> getProgressStream(
    String userId,
    String type,
    String date,
  ) {
    final stream = type == 'meal'
        ? _firestore
              .collection('users')
              .doc(userId)
              .collection('progress')
              .doc('food')
              .collection('daily_goals')
              .doc(date)
              .snapshots()
        : _firestore
              .collection('users')
              .doc(userId)
              .collection('progress')
              .doc(type)
              .collection(type)
              .doc(date)
              .snapshots();
    return stream
        .map((doc) => doc.exists ? doc.data() : null)
        .handleError((e) => throw e);
  }
}
