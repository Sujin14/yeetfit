import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../explore/domain/use_cases/get_plans_use_case.dart';
import '../../../plans/data/models/plan_model.dart';
import '../../../plans/domain/repositories/plan_repository.dart';
import '../../../plans/data/repositories/plan_repository_impl.dart';
import '../../../plans/domain/use_cases/get_favorite_plans_use_case.dart';
import '../../../plans/domain/use_cases/toggle_favorite_use_case.dart';

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

class FavoritePlansState {
  final List<PlanModel> plans;
  final bool isLoading;
  final String? error;

  FavoritePlansState({
    this.plans = const [],
    this.isLoading = false,
    this.error,
  });

  FavoritePlansState copyWith({
    List<PlanModel>? plans,
    bool? isLoading,
    String? error,
  }) {
    return FavoritePlansState(
      plans: plans ?? this.plans,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class FavoritePlansNotifier extends StateNotifier<FavoritePlansState> {
  final Ref ref;

  FavoritePlansNotifier(this.ref) : super(FavoritePlansState()) {
    _loadFavoritePlans();
  }

  Future<void> _loadFavoritePlans() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final plans = await ref.read(getFavoritePlansUseCaseProvider).execute();
      state = state.copyWith(plans: plans, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleFavorite(String planId, String type, bool isFavorite) async {
    try {
      // Optimistically update local state
      final updatedPlans = state.plans.map((plan) {
        if (plan.id == planId && plan.type == type) {
          return PlanModel(
            id: plan.id,
            title: plan.title,
            type: plan.type,
            userId: plan.userId,
            assignedBy: plan.assignedBy,
            details: plan.details,
            isFavorite: isFavorite,
            createdAt: plan.createdAt,
            totalCalories: plan.totalCalories,
            totalMacronutrients: plan.totalMacronutrients,
          );
        }
        return plan;
      }).toList();

      if (!isFavorite) {
        updatedPlans.removeWhere((plan) => plan.id == planId && plan.type == type);
      }

      state = state.copyWith(plans: updatedPlans);

      // Update Firestore
      await ref.read(toggleFavoriteUseCaseProvider).execute(planId, type, isFavorite);

      // Invalidate providers to refresh streams
      ref.invalidate(dietPlanProvider);
      ref.invalidate(workoutPlanProvider);
      ref.invalidate(favoritePlansProvider);
    } catch (e) {
      // Revert optimistic update on error
      await _loadFavoritePlans();
      rethrow;
    }
  }
}

final favoritePlansProvider = StateNotifierProvider<FavoritePlansNotifier, FavoritePlansState>((ref) {
  return FavoritePlansNotifier(ref);
});

final planDetailProvider = StreamProvider.family<PlanModel?, Map<String, dynamic>>((ref, extra) {
  final plan = extra['plan'] as PlanModel;
  final category = extra['category'] as String?;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    return Stream.value(null);
  }
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection(category == 'diet' ? 'diets' : 'workouts')
      .doc(plan.id)
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists) return plan;
    return PlanModel.fromFirestore(snapshot);
  });
});