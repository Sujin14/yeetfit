import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/admin_model.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<AdminModel>> getAdmins() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AdminModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
