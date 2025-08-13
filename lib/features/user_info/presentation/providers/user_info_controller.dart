import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/datasources/firestore_user_service.dart';
import '../../data/models/user_info_model.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/save_user_info.dart';
import '../../domain/validators/user_info_validators.dart';

final userInfoControllerProvider =
    StateNotifierProvider<UserInfoController, AsyncValue<UserInfoModel>>((ref) {
  final repository = UserRepositoryImpl(userService: FirestoreUserService());
  return UserInfoController(SaveUserInfo(repository), repository);
});

class UserInfoController extends StateNotifier<AsyncValue<UserInfoModel>> {
  final SaveUserInfo saveUserInfo;
  final UserRepositoryImpl repository;
  int _currentStep = 0;
  bool _isSaving = false;

  UserInfoController(this.saveUserInfo, this.repository)
      : super(const AsyncValue.loading()) {
    fetchUserData();
  }

  int get currentStep => _currentStep;
  bool get isSaving => _isSaving;

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      state = AsyncValue.error(Exception('User not authenticated'), StackTrace.current);
      return;
    }
    try {
      final userData = await repository.getUserData(uid);
      state = AsyncValue.data(userData ?? UserInfoModel(uid: uid, email: FirebaseAuth.instance.currentUser?.email));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void updateName(String name) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(name: name.trim()));
    });
  }

  void updateGender(String gender) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(gender: gender.trim()));
    });
  }

  void updateAge(int age) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(age: age));
    });
  }

  void updateGoal(String goal) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(goal: goal));
    });
  }

  void updateWeights({double? current, double? goal}) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(
        currentWeight: current ?? userInfo.currentWeight,
        goalWeight: goal ?? userInfo.goalWeight,
      ));
    });
  }

  void updateHeight(double height) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(height: height));
    });
  }

  void updateActivityLevel(String activityLevel) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(activityLevel: activityLevel));
    });
  }

  void updateTimeDuration(int duration) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(timeDurationWeeks: duration));
    });
  }

  Future<void> updateProfileImage(XFile image, BuildContext context) async {
    if (_isSaving) return;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }
      final storageRef = FirebaseStorage.instance.ref().child('users/$uid/profile.jpg');
      await storageRef.putFile(File(image.path));
      final url = await storageRef.getDownloadURL();
      final currentUserInfo = state.value ?? UserInfoModel(uid: uid);
      final updatedUserInfo = currentUserInfo.copyWith(profileImageUrl: url);
      await saveUserInfo(updatedUserInfo);
      state = AsyncValue.data(updatedUserInfo);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile image updated'),
            backgroundColor: AppTheme.colors['primaryButton'],
          ),
        );
      }
    } catch (e, stackTrace) {
      if (e.toString().contains('requires recent authentication')) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session expired. Please log in again.'),
              backgroundColor: Colors.red,
            ),
          );
          context.go('/login');
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image: $e'), backgroundColor: Colors.red),
          );
        }
      }
      state = AsyncValue.data(state.value ?? UserInfoModel(uid: FirebaseAuth.instance.currentUser?.uid ?? ''));
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _isSaving = false;
    }
  }

  void updateDietPreference(String? dietPreference) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(dietPreference: dietPreference));
    });
  }

  void updateAllergies(Map<String, bool>? allergies) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(allergies: allergies));
    });
  }

  void updateOtherAllergy(String? otherAllergy) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(otherAllergy: otherAllergy));
    });
  }

  void updateCuisines(Map<String, bool>? cuisines) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(cuisines: cuisines));
    });
  }

  void updateWaterGoal(double? waterGoal) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(waterGoal: waterGoal));
    });
  }

  void updateStepsGoal(double? stepsGoal) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(stepsGoal: stepsGoal));
    });
  }

  void updateSleepGoal(double? sleepGoal) {
    state.whenData((userInfo) {
      state = AsyncValue.data(userInfo.copyWith(sleepGoal: sleepGoal));
    });
  }

  Future<bool> validateStepData(int step, GlobalKey<FormState> formKey) async {
    formKey.currentState?.save();
    if (!formKey.currentState!.validate()) return false;

    final userInfo = state.valueOrNull ?? UserInfoModel(uid: FirebaseAuth.instance.currentUser?.uid ?? '');
    String? error;
    switch (step) {
      case 0:
        error = UserInfoValidators.validateName(userInfo.name) ??
                UserInfoValidators.validateGender(userInfo.gender);
        break;
      case 1:
        error = UserInfoValidators.validateAge(userInfo.age.toString());
        break;
      case 2:
        error = UserInfoValidators.validateGoal(userInfo.goal);
        break;
      case 3:
        error = UserInfoValidators.validateWeight(userInfo.currentWeight.toString()) ??
                UserInfoValidators.validateWeight(userInfo.goalWeight.toString());
        break;
      case 4:
        error = UserInfoValidators.validateHeight(userInfo.height.toString());
        break;
      case 5:
        error = UserInfoValidators.validateActivityLevel(userInfo.activityLevel);
        break;
      case 6:
        error = UserInfoValidators.validateTimeDuration(userInfo.timeDurationWeeks?.toString() ?? '');
        break;
    }
    return error == null;
  }

  Future<bool> saveStepData(BuildContext context, GlobalKey<FormState> formKey, int step) async {
    if (_isSaving) return false;
    final isValid = await validateStepData(step, formKey);
    if (!isValid) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields correctly'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }
      state.whenData((userInfo) async {
        final updatedUserInfo = userInfo.copyWith(uid: uid, email: FirebaseAuth.instance.currentUser?.email);
        await saveUserInfo(updatedUserInfo);
        state = AsyncValue.data(updatedUserInfo);
        _currentStep = step + 1;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Step saved successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/user-info-step/$_currentStep');
        }
      });
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }

  Future<bool> submitUserData(BuildContext context, GlobalKey<FormState> formKey) async {
    if (_isSaving) return false;
    final isValid = await validateStepData(6, formKey);
    if (!isValid) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields correctly'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }
      state.whenData((userInfo) async {
        final updatedUserInfo = userInfo.copyWith(uid: uid, email: FirebaseAuth.instance.currentUser?.email);
        await saveUserInfo(updatedUserInfo);
        state = AsyncValue.data(updatedUserInfo);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile created successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/user-dashboard');
        }
      });
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving user data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }

  Future<bool> saveUserData(BuildContext context) async {
    if (_isSaving) return false;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }
      state.whenData((userInfo) async {
        final updatedUserInfo = userInfo.copyWith(uid: uid, email: FirebaseAuth.instance.currentUser?.email);
        await saveUserInfo(updatedUserInfo);
        state = AsyncValue.data(updatedUserInfo);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Information updated'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/account');
        }
      });
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving user data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }

  Future<bool> deleteUserData(BuildContext context) async {
    if (_isSaving) return false;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }
      await repository.deleteUserData(uid);
      await FirebaseAuth.instance.currentUser?.delete();
      state = AsyncValue.data(UserInfoModel());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
      }
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }

  Future<void> previousStep(BuildContext context, int step) async {
    if (_isSaving || step <= 0) return;
    _currentStep = step - 1;
    if (context.mounted) context.go('/user-info-step/$_currentStep');
  }
}