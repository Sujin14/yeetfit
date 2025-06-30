import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/firestore_user_service.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/models/user_info_model.dart';
import '../../domain/usecases/save_user_info.dart';

final userInfoControllerProvider =
    StateNotifierProvider<UserInfoController, UserInfoModel>((ref) {
      final repository = UserRepositoryImpl(
        userService: FirestoreUserService(),
      );
      return UserInfoController(SaveUserInfo(repository));
    });

class UserInfoController extends StateNotifier<UserInfoModel> {
  final SaveUserInfo saveUserInfo;

  UserInfoController(this.saveUserInfo) : super(UserInfoModel());

  void updateName(String name, BuildContext context) {
    state = state.copyWith(name: name);
  }

  void updateGender(String gender, BuildContext context) {
    state = state.copyWith(gender: gender);
  }

  void updateAge(int age, BuildContext context) {
    state = state.copyWith(age: age);
  }

  void updateGoal(String goal, BuildContext context) {
    state = state.copyWith(goal: goal);
  }

  void updateWeights({
    double? current,
    double? goal,
    required BuildContext context,
  }) {
    state = state.copyWith(
      currentWeight: current ?? state.currentWeight,
      goalWeight: goal ?? state.goalWeight,
    );
  }

  void updateHeight(double height, BuildContext context) {
    state = state.copyWith(height: height);
  }

  void updateActivityLevel(String activityLevel, BuildContext context) {
    state = state.copyWith(activityLevel: activityLevel);
  }

  Future<void> saveUserData(BuildContext context) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
        return;
      }
      final updatedUserInfo = state.copyWith(uid: uid);
      await saveUserInfo(updatedUserInfo);
      context.go('/user-dashboard');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving user data: $e')));
    }
  }
}
