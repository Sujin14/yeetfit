import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/user_info_model.dart';

final userInfoControllerProvider =
    StateNotifierProvider<UserInfoNotifier, UserInfoModel>((ref) {
      return UserInfoNotifier();
    });

class UserInfoNotifier extends StateNotifier<UserInfoModel> {
  UserInfoNotifier() : super(UserInfoModel());

  void updateName(String name) => state = state.copyWith(name: name);
  void updateGender(String gender) => state = state.copyWith(gender: gender);
  void updateAge(int age) => state = state.copyWith(age: age);
  void updateGoal(String goal) => state = state.copyWith(goal: goal);

  void updateWeights({double? current, double? goal}) {
    state = state.copyWith(
      currentWeight: current ?? state.currentWeight,
      goalWeight: goal ?? state.goalWeight,
    );
  }

  void updateHeight(double height) => state = state.copyWith(height: height);
  void updateActivityLevel(String level) =>
      state = state.copyWith(activityLevel: level);

  void reset() => state = UserInfoModel();

  Future<void> saveUserData(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(state.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User info saved successfully')),
      );

      context.go('/user-dashboard');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving user info: $e')));
    }
  }
}
