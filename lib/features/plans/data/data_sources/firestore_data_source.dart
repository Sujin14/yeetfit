import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/plan_model.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreDataSource({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _plans(
    String userId,
    String collection,
  ) => _firestore.collection('users').doc(userId).collection(collection);

  /// [collection] is `diets` or `workouts`; [type] is `diet` or `workout`.
  Stream<List<PlanModel>> watchPlans(
    String userId, {
    required String collection,
    required String type,
  }) {
    return _plans(userId, collection)
        .where('type', isEqualTo: type)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(PlanModel.fromFirestore).toList());
  }

  Stream<PlanModel?> watchPlan(
    String userId, {
    required String collection,
    required String? planId,
  }) {
    return _plans(userId, collection)
        .doc(planId)
        .snapshots()
        .map((doc) => doc.exists ? PlanModel.fromFirestore(doc) : null);
  }

  Future<List<PlanModel>> getFavoritePlans() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw const UnauthorizedException('User not logged in');
    }
    try {
      final dietSnapshot = await _plans(userId, 'diets')
          .where('isFavorite', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();
      final workoutSnapshot = await _plans(userId, 'workouts')
          .where('isFavorite', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();
      return [
        ...dietSnapshot.docs.map(PlanModel.fromFirestore),
        ...workoutSnapshot.docs.map(PlanModel.fromFirestore),
      ];
    } catch (e) {
      throw DataException('Failed to fetch favorite plans: $e');
    }
  }

  Future<void> toggleFavorite(
    String planId,
    String type,
    bool isFavorite,
  ) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw const UnauthorizedException('User not logged in');
    }
    try {
      final collection = type == 'diet' ? 'diets' : 'workouts';
      await _plans(
        userId,
        collection,
      ).doc(planId).update({'isFavorite': isFavorite});
    } catch (e) {
      throw DataException('Failed to update favorite status: $e');
    }
  }
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException(this.message);

  @override
  String toString() => message;
}

class DataException implements Exception {
  final String message;
  const DataException(this.message);

  @override
  String toString() => message;
}
