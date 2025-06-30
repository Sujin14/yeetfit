import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_info_model.dart';

class FirestoreUserService {
  final FirebaseFirestore _firestore;

  FirestoreUserService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _users => _firestore.collection('users');

  Future<bool> checkUserExists(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.exists;
  }

  Future<void> saveUserData(UserInfoModel userInfo) async {
    await _users.doc(userInfo.uid).set({
      ...userInfo.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'role': 'user',
    });
  }

  Future<UserInfoModel?> getUserData(String uid) async {
    final doc = await _users.doc(uid).get();
    if (doc.exists) {
      return UserInfoModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
