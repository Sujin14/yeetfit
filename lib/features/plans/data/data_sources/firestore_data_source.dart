import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/plan_model.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<PlanModel?> getPlan(String type) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw UnauthorizedException('User not logged in');
    }
    try {
      final collection = type == 'diets' ? 'diets' : 'workouts';
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .where('type', isEqualTo: type == 'diets' ? 'diet' : 'workout')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return PlanModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      throw DataException('Failed to fetch $type plan: $e');
    }
  }

  Future<List<PlanModel>> getAllPlans(String type) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw UnauthorizedException('User not logged in');
    }
    try {
      final collection = type == 'diets' ? 'diets' : 'workouts';
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .where('type', isEqualTo: type == 'diets' ? 'diet' : 'workout')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => PlanModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw DataException('Failed to fetch $type plans: $e');
    }
  }

  Future<List<PlanModel>> getFavoritePlans() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw UnauthorizedException('User not logged in');
    }
    try {
      final dietSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('diets')
          .where('isFavorite', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();
      final workoutSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .where('isFavorite', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();
      return [
        ...dietSnapshot.docs.map((doc) => PlanModel.fromFirestore(doc)),
        ...workoutSnapshot.docs.map((doc) => PlanModel.fromFirestore(doc)),
      ];
    } catch (e) {
      throw DataException('Failed to fetch favorite plans: $e');
    }
  }

  Future<void> toggleFavorite(String planId, String type, bool isFavorite) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw UnauthorizedException('User not logged in');
    }
    try {
      final collection = type == 'diet' ? 'diets' : 'workouts';
      await _firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .doc(planId)
          .update({'isFavorite': isFavorite});
    } catch (e) {
      throw DataException('Failed to update favorite status: $e');
    }
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class DataException implements Exception {
  final String message;
  DataException(this.message);
}