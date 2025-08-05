import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/firestore_user_service.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/models/user_info_model.dart';
import '../../domain/usecases/save_user_info.dart';

final userInfoControllerProvider =
    StateNotifierProvider<UserInfoController, AsyncValue<UserInfoModel>>((ref) {
  final repository = UserRepositoryImpl(
    userService: FirestoreUserService(),
  );
  return UserInfoController(SaveUserInfo(repository), repository);
});

class UserInfoController extends StateNotifier<AsyncValue<UserInfoModel>> {
  final SaveUserInfo saveUserInfo;
  final UserRepositoryImpl repository;

  UserInfoController(this.saveUserInfo, this.repository)
      : super(const AsyncValue.loading()) {
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      state = AsyncValue.error('User not authenticated', StackTrace.current);
      return;
    }
    try {
      print('UserInfoController: Fetching user data for uid=$uid');
      final userData = await repository.getUserData(uid);
      state = AsyncValue.data(userData ?? UserInfoModel(uid: uid));
      print('UserInfoController: Fetched user data: ${userData?.toMap()}');
    } catch (e, stackTrace) {
      print('UserInfoController: Error fetching user data: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void updateName(String name, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(name: name));
    });
  }

  void updateGender(String gender, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(gender: gender));
    });
  }

  void updateAge(int age, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(age: age));
    });
  }

  void updateGoal(String goal, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(goal: goal));
    });
  }

  void updateWeights({
    double? current,
    double? goal,
    required BuildContext context,
  }) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(
        currentWeight: current ?? userInfo.currentWeight,
        goalWeight: goal ?? userInfo.goalWeight,
      ));
    });
  }

  void updateHeight(double height, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(height: height));
    });
  }

  void updateActivityLevel(String activityLevel, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(activityLevel: activityLevel));
    });
  }

  void updateTimeDuration(int duration, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(timeDurationWeeks: duration));
    });
  }

  void updateProfileImageUrl(String? profileImageUrl, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(profileImageUrl: profileImageUrl));
    });
  }

  void updateDietPreference(String? dietPreference, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(dietPreference: dietPreference));
    });
  }

  void updateAllergies(Map<String, bool>? allergies, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(allergies: allergies));
    });
  }

  void updateOtherAllergy(String? otherAllergy, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(otherAllergy: otherAllergy));
    });
  }

  void updateCuisines(Map<String, bool>? cuisines, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(cuisines: cuisines));
    });
  }

  void updateWaterGoal(double? waterGoal, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(waterGoal: waterGoal));
    });
  }

  void updateStepsGoal(double? stepsGoal, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(stepsGoal: stepsGoal));
    });
  }

  void updateSleepGoal(double? sleepGoal, BuildContext context) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(sleepGoal: sleepGoal));
    });
  }

  Future<void> saveUserData(BuildContext context) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User not authenticated',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      state.whenData((userInfo) async {
        final updatedUserInfo = userInfo.copyWith(uid: uid);
        await saveUserInfo(updatedUserInfo);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Information updated',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        if (context.mounted) context.go('/user-dashboard');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error saving user data: $e',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deleteUserData(BuildContext context) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User not authenticated',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      print('UserInfoController: Deleting user data for uid=$uid');
      await repository.deleteUserData(uid);
      await FirebaseAuth.instance.currentUser?.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account deleted successfully',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      if (context.mounted) context.go('/login');
    } catch (e) {
      print('UserInfoController: Error deleting user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error deleting account: $e',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}