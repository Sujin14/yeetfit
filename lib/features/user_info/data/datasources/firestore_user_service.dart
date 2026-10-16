import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeetfit/core/entities/nutrition_targets.dart';
import 'package:yeetfit/core/utils/nutrition_targets_calculator.dart';
import 'package:yeetfit/core/utils/nutrition_targets_fields.dart';
import '../models/user_info_model.dart';

class FirestoreUserService {
  final FirebaseFirestore _firestore;

  FirestoreUserService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  /// Coach-discoverable client profiles. Only the coach app writes
  /// `currentCoachId` after creation, and the rules reject client writes
  /// that touch it.
  CollectionReference<Map<String, dynamic>> get _clients =>
      _firestore.collection('clients');

  /// Whether the user has started profile setup. The doc alone isn't enough:
  /// the FCM token and weight writes can create it before onboarding runs.
  Future<bool> checkUserExists(String uid) async {
    final doc = await _users.doc(_requireUid(uid)).get();
    final name = doc.data()?['name'];
    return doc.exists && name is String && name.trim().isNotEmpty;
  }

  Future<void> saveUserData(UserInfoModel userInfo) async {
    final docRef = _users.doc(_requireUid(userInfo.uid));
    final existing = await docRef.get();
    await docRef.set(_userData(userInfo, existing), SetOptions(merge: true));
  }

  /// Saves the profile and its `clients/{uid}` mirror in one batch, so both
  /// writes succeed or fail together. The client doc is created on first
  /// save; afterwards only its name and photo are updated.
  Future<void> saveUserDataWithClient(UserInfoModel userInfo) async {
    final uid = _requireUid(userInfo.uid);
    final userRef = _users.doc(uid);
    final clientRef = _clients.doc(uid);
    final (existingUser, existingClient) = await (
      userRef.get(),
      clientRef.get(),
    ).wait;

    final batch = _firestore.batch()
      ..set(
        userRef,
        _userData(userInfo, existingUser),
        SetOptions(merge: true),
      );
    final profilePicture = userInfo.profileImageUrl?.trim();
    final hasPicture = profilePicture != null && profilePicture.isNotEmpty;
    if (existingClient.exists) {
      batch.update(clientRef, {
        'name': userInfo.name,
        if (hasPicture) 'profilePicture': profilePicture,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      batch.set(clientRef, {
        'uid': uid,
        'name': userInfo.name,
        if (hasPicture) 'profilePicture': profilePicture,
        'email': userInfo.email ?? '',
        'currentCoachId': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<UserInfoModel?> getUserData(String uid) async {
    final doc = await _users.doc(_requireUid(uid)).get();
    final data = doc.data();
    if (data == null) return null;
    return UserInfoModel.fromMap(data, documentId: doc.id);
  }

  /// Writes only the four daily target fields.
  Future<void> saveNutritionTargets(String uid, NutritionTargets targets) =>
      _users
          .doc(_requireUid(uid))
          .set(NutritionTargetsFields.toMap(targets), SetOptions(merge: true));

  /// Targets are recalculated on every save; when a body field is missing
  /// they're left out so the saved ones stay unchanged.
  static Map<String, dynamic> _userData(
    UserInfoModel userInfo,
    DocumentSnapshot<Map<String, dynamic>> existing,
  ) {
    final targets = NutritionTargetsCalculator.calculate(
      gender: userInfo.gender,
      age: userInfo.age,
      weightKg: userInfo.currentWeight,
      heightCm: userInfo.height,
      activityLevel: userInfo.activityLevel,
      goal: userInfo.goal,
    );
    return {
      ...userInfo.toMap(),
      if (targets != null) ...NutritionTargetsFields.toMap(targets),
      if (existing.data()?['createdAt'] == null)
        'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Firestore throws an opaque "document path must be a non-empty string"
  // for doc(''); fail with a message that names the actual problem.
  static String _requireUid(String uid) {
    if (uid.trim().isEmpty) {
      throw ArgumentError.value(uid, 'uid', 'User ID is missing');
    }
    return uid;
  }
}
