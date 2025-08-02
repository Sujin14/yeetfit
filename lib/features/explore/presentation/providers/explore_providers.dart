import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../../plans/data/models/plan_model.dart';
import '../../../plans/domain/repositories/plan_repository.dart';
import '../../../plans/data/repositories/plan_repository_impl.dart';
import '../../../plans/domain/use_cases/get_favorite_plans_use_case.dart';
import '../../../plans/domain/use_cases/toggle_favorite_use_case.dart';
import '../../domain/use_cases/get_plans_use_case.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepositoryImpl();
});

final getPlanUseCaseProvider = Provider<GetPlansUseCase>((ref) {
  return GetPlansUseCase(ref.read(planRepositoryProvider));
});

final getFavoritePlansUseCaseProvider = Provider<GetFavoritePlansUseCase>((ref) {
  return GetFavoritePlansUseCase(ref.read(planRepositoryProvider));
});

final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>((ref) {
  return ToggleFavoriteUseCase(ref.read(planRepositoryProvider));
});

final dietPlanProvider = StreamProvider<PlanModel?>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    return Stream.value(null);
  }
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('diets')
      .where('type', isEqualTo: 'diet')
      .orderBy('createdAt', descending: true)
      .limit(1)
      .snapshots()
      .map((snapshot) {
    if (snapshot.docs.isEmpty) return null;
    return PlanModel.fromFirestore(snapshot.docs.first);
  });
});

final workoutPlanProvider = StreamProvider<PlanModel?>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    return Stream.value(null);
  }
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('workouts')
      .where('type', isEqualTo: 'workout')
      .orderBy('createdAt', descending: true)
      .limit(1)
      .snapshots()
      .map((snapshot) {
    if (snapshot.docs.isEmpty) return null;
    return PlanModel.fromFirestore(snapshot.docs.first);
  });
});

final favoritePlansProvider = StreamProvider<List<PlanModel>>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    return Stream.value([]);
  }
  final dietStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('diets')
      .where('isFavorite', isEqualTo: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => PlanModel.fromFirestore(doc)).toList());

  final workoutStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('workouts')
      .where('isFavorite', isEqualTo: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => PlanModel.fromFirestore(doc)).toList());

  return CombineLatestStream.combine2(
    dietStream,
    workoutStream,
    (List<PlanModel> diets, List<PlanModel> workouts) => [...diets, ...workouts],
  );
});