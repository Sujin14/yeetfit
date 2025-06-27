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

  Future<void> _updateFirestoreField(
    String uid,
    Map<String, dynamic> data,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Log error or handle as needed
      print('Error updating Firestore: $e');
    }
  }

  void updateName(String name, BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && name != state.name) {
      state = state.copyWith(name: name);
      _updateFirestoreField(uid, {'name': name});
    } else if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
    }
  }

  void updateGender(String gender, BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && gender != state.gender) {
      state = state.copyWith(gender: gender);
      _updateFirestoreField(uid, {'gender': gender});
    } else if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
    }
  }

  void updateAge(int age, BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && age != state.age) {
      state = state.copyWith(age: age);
      _updateFirestoreField(uid, {'age': age});
    } else if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
    }
  }

  void updateGoal(String goal, BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && goal != state.goal) {
      state = state.copyWith(goal: goal);
      _updateFirestoreField(uid, {'goal': goal});
    } else if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
    }
  }

  void updateWeights({
    double? current,
    double? goal,
    required BuildContext context,
  }) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null &&
        (current != state.currentWeight || goal != state.goalWeight)) {
      state = state.copyWith(
        currentWeight: current ?? state.currentWeight,
        goalWeight: goal ?? state.goalWeight,
      );
      _updateFirestoreField(uid, {
        'currentWeight': current ?? state.currentWeight,
        'goalWeight': goal ?? state.goalWeight,
      });
    } else if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
    }
  }

  void updateHeight(double height, BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && height != state.height) {
      state = state.copyWith(height: height);
      _updateFirestoreField(uid, {'height': height});
    } else if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
    }
  }

  void updateActivityLevel(String level, BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && level != state.activityLevel) {
      state = state.copyWith(activityLevel: level);
      _updateFirestoreField(uid, {'activityLevel': level});
    } else if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
    }
  }

  void reset() => state = UserInfoModel();

  Future<void> saveUserData(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
      return;
    }
    if (state.name.isEmpty ||
        state.gender.isEmpty ||
        state.goal.isEmpty ||
        state.activityLevel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        ...state.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'role': 'user',
      }, SetOptions(merge: false));
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
