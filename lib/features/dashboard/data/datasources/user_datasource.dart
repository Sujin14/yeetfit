import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    print('UserDataSource: Fetching user data for userId=$userId');
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        print('UserDataSource: User data found for userId=$userId: ${doc.data()}');
        return doc.data();
      }
      print('UserDataSource: No user data found for userId=$userId');
      return null;
    } catch (e) {
      print('UserDataSource: Error fetching user data for userId=$userId: $e');
      rethrow;
    }
  }
}