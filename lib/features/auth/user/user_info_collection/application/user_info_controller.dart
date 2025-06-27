import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/user_info_model.dart';

final userInfoModelProvider =
    StateNotifierProvider<UserInfoNotifier, UserInfoModel>((ref) {
      return UserInfoNotifier();
    });

class UserInfoNotifier extends StateNotifier<UserInfoModel> {
  UserInfoNotifier() : super(UserInfoModel());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void updateAge(int age) {
    state = state.copyWith(age: age);
  }

  void updateGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  void updateWeights({double? current, double? goal}) {
    state = state.copyWith(
      currentWeight: current ?? state.currentWeight,
      goalWeight: goal ?? state.goalWeight,
    );
  }

  void updateHeight(double height) {
    state = state.copyWith(height: height);
  }

  void updateActivityLevel(String level) {
    state = state.copyWith(activityLevel: level);
  }

  void reset() {
    state = UserInfoModel();
  }
}
