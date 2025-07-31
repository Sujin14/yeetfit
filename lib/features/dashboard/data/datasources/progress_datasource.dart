import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getProgressData(String userId, String type, String date) async {
    print('ProgressDataSource: Fetching $type data for userId=$userId, date=$date');
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(type)
          .collection(type)
          .doc(date);
      final doc = await docRef.get();
      if (doc.exists) {
        print('ProgressDataSource: $type data found for userId=$userId, date=$date: ${doc.data()}');
        return doc.data();
      }
      print('ProgressDataSource: No $type data found for userId=$userId, date=$date');
      return null;
    } catch (e) {
      print('ProgressDataSource: Error fetching $type data for userId=$userId, date=$date: $e');
      rethrow;
    }
  }

  Stream<Map<String, dynamic>?> getProgressStream(String userId, String type, String date) {
    print('ProgressDataSource: Streaming $type data for userId=$userId, date=$date');
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(type)
        .collection(type)
        .doc(date)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        print('ProgressDataSource: $type stream update for userId=$userId, date=$date: ${doc.data()}');
        return doc.data();
      }
      print('ProgressDataSource: No $type stream data for userId=$userId, date=$date');
      return null;
    }).handleError((e) {
      print('ProgressDataSource: Error streaming $type data for userId=$userId, date=$date: $e');
      throw e;
    });
  }
}