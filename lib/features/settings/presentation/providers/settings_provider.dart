import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/data/datasources/firestore_user_service.dart';
import '../../../user_info/data/models/user_info_model.dart';
import '../../../user_info/data/repositories/user_repository_impl.dart';
import '../../../user_info/domain/usecases/save_user_info.dart';
import '../../../user_info/domain/validators/user_info_validators.dart';
import '../../../user_info/presentation/providers/user_info_controller.dart';
import '../../../water_tracking/presentation/providers/water_provider.dart';
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
    required int age,
    required double height,
    required double currentWeight,
    required double goalWeight,
    required String activityLevel,
    required GlobalKey<FormState> formKey,
  }) async {
    if (_isSaving) return false;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      // Validate inputs
      final nameError = UserInfoValidators.validateName(name);
      final genderError = UserInfoValidators.validateGender(gender);
      final ageError = UserInfoValidators.validateAge(age.toString());
      final heightError = UserInfoValidators.validateHeight(height.toString());
      final currentWeightError = UserInfoValidators.validateWeight(currentWeight.toString());
      final goalWeightError = UserInfoValidators.validateWeight(goalWeight.toString());
      final activityLevelError = UserInfoValidators.validateActivityLevel(activityLevel);

      if (nameError != null || genderError != null || ageError != null || heightError != null ||
          currentWeightError != null || goalWeightError != null || activityLevelError != null) {
        throw Exception('Invalid input: ${[
          nameError,
          genderError,
          ageError,
          heightError,
          currentWeightError,
          goalWeightError,
          activityLevelError
        ].where((e) => e != null).join(', ')}');
      }

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      // Update UserInfoModel and save to Firebase
      final userInfoController = ref.read(userInfoControllerProvider.notifier);
      final currentUserInfo = ref.read(userInfoControllerProvider).value ?? UserInfoModel(uid: uid);
      final updatedUserInfo = currentUserInfo.copyWith(
        name: name,
        gender: gender,
        age: age,
        height: height,
        currentWeight: currentWeight,
        goalWeight: goalWeight,
        activityLevel: activityLevel,
        email: FirebaseAuth.instance.currentUser?.email,
      );

      await saveUserInfo(updatedUserInfo);
      userInfoController.state = AsyncValue.data(updatedUserInfo);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Basic information saved',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.green,
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
            backgroundColor: AppTheme.colors['error'] ?? Colors.red,
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
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      // Validate inputs
      formKey.currentState?.save();
      if (!formKey.currentState!.validate()) {
        throw Exception('Invalid input');
      }

      // Update UserInfoModel and save to Firebase
      final userInfoController = ref.read(userInfoControllerProvider.notifier);
      final currentUserInfo = ref.read(userInfoControllerProvider).value ?? UserInfoModel(uid: uid);
      final updatedUserInfo = currentUserInfo.copyWith(
        dietPreference: dietPreference,
        allergies: allergies,
        otherAllergy: otherAllergy,
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
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.green,
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
            backgroundColor: AppTheme.colors['error'] ?? Colors.red,
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }

  Future<bool> saveGoals({
    required BuildContext context,
    required double? weightGoal,
    required double? waterGoal,
    required double? stepsGoal,
    required double? sleepGoal,
  }) async {
    if (_isSaving) return false;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      // Validate inputs
      if (weightGoal != null && UserInfoValidators.validateWeight(weightGoal.toString()) != null) {
        throw Exception('Invalid weight goal');
      }
      if (waterGoal != null && (waterGoal <= 0 || waterGoal > 20)) {
        throw Exception('Water goal must be between 1 and 20 glasses');
      }
      if (stepsGoal != null && (stepsGoal <= 0 || stepsGoal > 100000)) {
        throw Exception('Steps goal must be between 1 and 100,000 steps');
      }
      if (sleepGoal != null && (sleepGoal <= 0 || sleepGoal > 24)) {
        throw Exception('Sleep goal must be between 1 and 24 hours');
      }

      // Update UserInfoModel and save to Firebase
      final userInfoController = ref.read(userInfoControllerProvider.notifier);
      final currentUserInfo = ref.read(userInfoControllerProvider).value ?? UserInfoModel(uid: uid);
      final updatedUserInfo = currentUserInfo.copyWith(
        goalWeight: weightGoal ?? currentUserInfo.goalWeight,
        waterGoal: waterGoal ?? currentUserInfo.waterGoal,
        stepsGoal: stepsGoal ?? currentUserInfo.stepsGoal,
        sleepGoal: sleepGoal ?? currentUserInfo.sleepGoal,
        email: FirebaseAuth.instance.currentUser?.email,
      );

      // Save to Firebase
      await saveUserInfo(updatedUserInfo);
      userInfoController.state = AsyncValue.data(updatedUserInfo);

      // Update weight and water goals in their respective providers
      if (weightGoal != null) {
        await ref.read(setWeightGoalProvider).call(
              uid,
              weightGoal,
              currentUserInfo.currentWeight,
              null,
            );
      }
      if (waterGoal != null) {
        await ref.read(setWaterGoalProvider).call(uid, waterGoal.toInt());
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Goals saved',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.green,
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
            content: Text('Error saving goals: $e'),
            backgroundColor: AppTheme.colors['error'] ?? Colors.red,
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
          backgroundColor: AppTheme.colors['lightBackground'],
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
      state = const AsyncValue.data(null);
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: $e'),
            backgroundColor: AppTheme.colors['error'] ?? Colors.red,
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
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        context.go('/login');
      }
      state = const AsyncValue.data(null);
      _isSaving = false;
      return true;
    } catch (e, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: AppTheme.colors['error'] ?? Colors.red,
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }
}