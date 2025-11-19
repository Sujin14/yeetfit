// lib/features/dashboard/data/datasources/user_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      rethrow;
    }
  }
}
