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
      final snapshot = await _firestore
          .collection(type == 'diet' ? 'diets' : 'workouts')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return PlanModel.fromFirestore(snapshot.docs.first);
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
          .collection('diets')
          .where('userId', isEqualTo: userId)
          .where('isFavorite', isEqualTo: true)
          .limit(1)
          .get();
      final workoutSnapshot = await _firestore
          .collection('workouts')
          .where('userId', isEqualTo: userId)
          .where('isFavorite', isEqualTo: true)
          .limit(1)
          .get();
      return [
        ...dietSnapshot.docs.map((doc) => PlanModel.fromFirestore(doc)),
        ...workoutSnapshot.docs.map((doc) => PlanModel.fromFirestore(doc)),
      ];
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
      await _firestore
          .collection(type == 'diet' ? 'diets' : 'workouts')
          .doc(planId)
          .update({'isFavorite': isFavorite});
    } catch (e) {
      throw Exception('Failed to update favorite status: $e');
    }
  }
}
