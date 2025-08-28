import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/data/datasources/firestore_user_service.dart';
import '../../../user_info/data/models/user_info_model.dart';
import '../../../user_info/data/repositories/user_repository_impl.dart';
import '../../../user_info/domain/usecases/save_user_info.dart';
import '../../../user_info/domain/validators/user_info_validators.dart';
import '../../../user_info/presentation/providers/user_info_provider.dart';
import '../../../weight_tracking/presentation/providers/weight_provider.dart';

final settingsControllerProvider = StateNotifierProvider<SettingsController, AsyncValue<void>>((ref) {
  final repository = UserRepositoryImpl(userService: FirestoreUserService());
  return SettingsController(ref, SaveUserInfo(repository));
});

class SettingsController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final SaveUserInfo saveUserInfo;
  bool _isSaving = false;

  SettingsController(this.ref, this.saveUserInfo) : super(const AsyncValue.data(null));

  bool get isSaving => _isSaving;

  Future<bool> saveBasicInformation({
    required BuildContext context,
    required String name,
    required String gender,
    required String age,
    required String height,
    required String currentWeight,
    required String activityLevel,
    required GlobalKey<FormState> formKey,
  }) async {
    if (_isSaving) return false;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      formKey.currentState?.save();
      if (!formKey.currentState!.validate()) {
        throw Exception('Invalid input');
      }

      final parsedAge = int.tryParse(age);
      final parsedHeight = double.tryParse(height);
      final parsedCurrentWeight = double.tryParse(currentWeight);

      final nameError = UserInfoValidators.validateName(name);
      final genderError = UserInfoValidators.validateGender(gender);
      final ageError = UserInfoValidators.validateAge(age);
      final heightError = UserInfoValidators.validateHeight(height);
      final currentWeightError = UserInfoValidators.validateWeight(currentWeight);
      final activityLevelError = UserInfoValidators.validateActivityLevel(activityLevel);

      if (nameError != null ||
          genderError != null ||
          ageError != null ||
          heightError != null ||
          currentWeightError != null ||
          activityLevelError != null ||
          parsedAge == null ||
          parsedHeight == null ||
          parsedCurrentWeight == null) {
        throw Exception('Invalid input: ${[
          nameError,
          genderError,
          ageError,
          heightError,
          currentWeightError,
          activityLevelError
        ].where((e) => e != null).join(', ')}');
      }

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      final userInfoController = ref.read(userInfoControllerProvider.notifier);
      final currentUserInfo = ref.read(userInfoControllerProvider).value ?? UserInfoModel(uid: uid);
      final updatedUserInfo = currentUserInfo.copyWith(
        name: name.trim(),
        gender: gender,
        age: parsedAge,
        height: parsedHeight,
        currentWeight: parsedCurrentWeight,
        activityLevel: activityLevel,
        email: FirebaseAuth.instance.currentUser?.email,
      );

      await saveUserInfo(updatedUserInfo);
      userInfoController.state = AsyncValue.data(updatedUserInfo);

      await ref.read(weightRepositoryProvider).updateCurrentWeight(uid, parsedCurrentWeight);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Basic information saved',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['primaryText'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'],
          ),
        );
        context.go('/account');
      }
      state = const AsyncValue.data(null);
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving basic information: $e'),
            backgroundColor: AppTheme.colors['error'],
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }

  Future<bool> saveFoodPreferences({
    required BuildContext context,
    required String? dietPreference,
    required Map<String, bool> allergies,
    required String? otherAllergy,
    required Map<String, bool> cuisines,
    required GlobalKey<FormState> formKey,
  }) async {
    if (_isSaving) return false;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      formKey.currentState?.save();
      if (!formKey.currentState!.validate()) {
        throw Exception('Invalid input');
      }

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      final userInfoController = ref.read(userInfoControllerProvider.notifier);
      final currentUserInfo = ref.read(userInfoControllerProvider).value ?? UserInfoModel(uid: uid);
      final updatedUserInfo = currentUserInfo.copyWith(
        dietPreference: dietPreference,
        allergies: allergies,
        otherAllergy: otherAllergy?.trim(),
        cuisines: cuisines,
        email: FirebaseAuth.instance.currentUser?.email,
      );

      await saveUserInfo(updatedUserInfo);
      userInfoController.state = AsyncValue.data(updatedUserInfo);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Food preferences saved',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['primaryText'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'],
          ),
        );
        context.go('/account');
      }
      state = const AsyncValue.data(null);
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving food preferences: $e'),
            backgroundColor: AppTheme.colors['error'],
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }

  Future<bool> updateFitnessGoal({
    required BuildContext context,
    required String goal,
  }) async {
    if (_isSaving) return false;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      final userInfoController = ref.read(userInfoControllerProvider.notifier);
      final currentUserInfo = ref.read(userInfoControllerProvider).value ?? UserInfoModel(uid: uid);
      final updatedUserInfo = currentUserInfo.copyWith(
        goal: goal,
        email: FirebaseAuth.instance.currentUser?.email,
      );

      await saveUserInfo(updatedUserInfo);
      userInfoController.state = AsyncValue.data(updatedUserInfo);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Fitness goal updated',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['primaryText'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'],
          ),
        );
      }
      state = const AsyncValue.data(null);
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating fitness goal: $e'),
            backgroundColor: AppTheme.colors['error'],
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }

  Future<bool> updateProfileImage({
    required BuildContext context,
    required XFile image,
  }) async {
    if (_isSaving) return false;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      print('Uploading to: users/$uid/profile.jpg');
      final storageRef = FirebaseStorage.instance.ref().child('users/$uid/profile.jpg');
      final uploadTask = await storageRef.putFile(File(image.path));
      final imageUrl = await uploadTask.ref.getDownloadURL();
      final userInfoController = ref.read(userInfoControllerProvider.notifier);
      final currentUserInfo = ref.read(userInfoControllerProvider).value ?? UserInfoModel(uid: uid);
      final updatedUserInfo = currentUserInfo.copyWith(
        profileImageUrl: imageUrl,
        email: FirebaseAuth.instance.currentUser?.email,
      );

      await saveUserInfo(updatedUserInfo);
      userInfoController.state = AsyncValue.data(updatedUserInfo);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile image updated',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['primaryText'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'],
          ),
        );
      }
      state = const AsyncValue.data(null);
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      String errorMessage = 'Error updating profile image';
      if (e is FirebaseException) {
        if (e.code == 'permission-denied') {
          errorMessage = 'Permission denied: Unable to upload profile image. Please check your account permissions.';
        } else {
          errorMessage = 'Firebase error: ${e.message}';
        }
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.colors['error'],
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }

  Future<bool> deleteAccount(BuildContext context) async {
    if (_isSaving) return false;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.colors['cardBackground'],
          title: Text('Delete Account', style: AppTheme.textStyles['title']),
          content: Text(
            'Are you sure you want to permanently delete your account? This action cannot be undone.',
            style: AppTheme.textStyles['body'],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel', style: AppTheme.textStyles['body']),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Delete',
                style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['error']),
              ),
            ),
          ],
        ),
      );
      if (confirmed != true) {
        state = const AsyncValue.data(null);
        _isSaving = false;
        return false;
      }

      await ref.read(userInfoControllerProvider.notifier).deleteUserData(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Account deleted successfully',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['primaryText'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'],
          ),
        );
        context.go('/login');
      }
      state = const AsyncValue.data(null);
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: $e'),
            backgroundColor: AppTheme.colors['error'],
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }

  Future<bool> logout(BuildContext context) async {
    if (_isSaving) return false;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.colors['cardBackground'],
          title: Text('Logout', style: AppTheme.textStyles['title']),
          content: Text(
            'Are you sure you want to log out?',
            style: AppTheme.textStyles['body'],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel', style: AppTheme.textStyles['body']),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Logout',
                style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['error']),
              ),
            ),
          ],
        ),
      );
      if (confirmed != true) {
        state = const AsyncValue.data(null);
        _isSaving = false;
        return false;
      }

      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Logged out successfully',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['primaryText'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'],
          ),
        );
      }
      state = const AsyncValue.data(null);
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: AppTheme.colors['error'],
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }
}