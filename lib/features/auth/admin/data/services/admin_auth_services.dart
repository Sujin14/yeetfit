import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> validateAdminCredentials(
    String username,
    String password,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('admins')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return false;

      final adminData = snapshot.docs.first.data();
      return adminData['password'] == password;
    } catch (e) {
      print("Admin login error: $e");
      return false;
    }
  }
}
