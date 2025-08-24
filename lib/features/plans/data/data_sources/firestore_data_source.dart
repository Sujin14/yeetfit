import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/plan_model.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<PlanModel?> getPlan(String type) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
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
      final plan = PlanModel.fromFirestore(snapshot.docs.first);
      return plan;
    } catch (e) {
      throw Exception('Failed to fetch $type plan: $e');
    }
  }

  Future<List<PlanModel>> getFavoritePlans() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
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
      final plans = [
        ...dietSnapshot.docs.map((doc) => PlanModel.fromFirestore(doc)),
        ...workoutSnapshot.docs.map((doc) => PlanModel.fromFirestore(doc)),
      ];
      return plans;
    } catch (e) {
      throw Exception('Failed to fetch favorite plans: $e');
    }
  }

  Future<void> toggleFavorite(
    String planId,
    String type,
    bool isFavorite,
  ) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }
      final collection = type == 'diet' ? 'diets' : 'workouts';
      await _firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .doc(planId)
          .update({'isFavorite': isFavorite});
      
    } catch (e) {
      throw Exception('Failed to update favorite status: $e');
    }
  }
}
