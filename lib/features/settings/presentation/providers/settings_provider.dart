import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    required String age,
    required String height,
    required String currentWeight,
    required String goalWeight,
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

      // Parse inputs
      final parsedAge = int.tryParse(age);
      final parsedHeight = double.tryParse(height);
      final parsedCurrentWeight = double.tryParse(currentWeight);
      final parsedGoalWeight = double.tryParse(goalWeight);

      // Validate inputs
      final nameError = UserInfoValidators.validateName(name);
      final genderError = UserInfoValidators.validateGender(gender);
      final ageError = UserInfoValidators.validateAge(age);
      final heightError = UserInfoValidators.validateHeight(height);
      final currentWeightError = UserInfoValidators.validateWeight(currentWeight);
      final goalWeightError = UserInfoValidators.validateWeight(goalWeight);
      final activityLevelError = UserInfoValidators.validateActivityLevel(activityLevel);

      if (nameError != null || genderError != null || ageError != null || heightError != null ||
          currentWeightError != null || goalWeightError != null || activityLevelError != null ||
          parsedAge == null || parsedHeight == null || parsedCurrentWeight == null || parsedGoalWeight == null) {
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
        name: name.trim(),
        gender: gender,
        age: parsedAge,
        height: parsedHeight,
        currentWeight: parsedCurrentWeight,
        goalWeight: parsedGoalWeight,
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
      formKey.currentState?.save();
      if (!formKey.currentState!.validate()) {
        throw Exception('Invalid input');
      }

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      // Update UserInfoModel and save to Firebase
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

  Future<bool> saveGoal({
    required BuildContext context,
    required String? value,
    required String type,
  }) async {
    if (_isSaving) return false;
    _isSaving = true;
    state = const AsyncValue.loading();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      // Validate input
      final parsedValue = double.tryParse(value ?? '');
      if (parsedValue == null || parsedValue <= 0) {
        throw Exception('Invalid $type goal');
      }
      if (type == 'Water' && (parsedValue <= 0 || parsedValue > 20)) {
        throw Exception('Water goal must be between 1 and 20 glasses');
      }
      if (type == 'Steps' && (parsedValue <= 0 || parsedValue > 100000)) {
        throw Exception('Steps goal must be between 1 and 100,000 steps');
      }
      if (type == 'Sleep' && (parsedValue <= 0 || parsedValue > 24)) {
        throw Exception('Sleep goal must be between 1 and 24 hours');
      }
      if (type == 'Weight' && UserInfoValidators.validateWeight(value!) != null) {
        throw Exception('Invalid weight goal');
      }

      // Update UserInfoModel and save to Firebase
      final userInfoController = ref.read(userInfoControllerProvider.notifier);
      final currentUserInfo = ref.read(userInfoControllerProvider).value ?? UserInfoModel(uid: uid);
      final updatedUserInfo = currentUserInfo.copyWith(
        goalWeight: type == 'Weight' ? parsedValue : currentUserInfo.goalWeight,
        waterGoal: type == 'Water' ? parsedValue : currentUserInfo.waterGoal,
        stepsGoal: type == 'Steps' ? parsedValue : currentUserInfo.stepsGoal,
        sleepGoal: type == 'Sleep' ? parsedValue : currentUserInfo.sleepGoal,
        email: FirebaseAuth.instance.currentUser?.email,
      );

      // Save to Firebase
      await saveUserInfo(updatedUserInfo);
      userInfoController.state = AsyncValue.data(updatedUserInfo);

      // Update specific providers
      if (type == 'Weight') {
        await ref.read(setWeightGoalProvider).call(
              uid,
              parsedValue,
              currentUserInfo.currentWeight,
              null,
            );
      }
      if (type == 'Water') {
        await ref.read(setWaterGoalProvider).call(uid, parsedValue.toInt());
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$type goal saved',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.green,
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
            content: Text('Error saving $type goal: $e'),
            backgroundColor: AppTheme.colors['error'] ?? Colors.red,
          ),
        );
      }
      state = AsyncValue.error(e, stackTrace);
      _isSaving = false;
      return false;
    }
  }

  Future<bool> showEditGoalDialog({
    required BuildContext context,
    required String label,
    required String initialValue,
    required String type,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.colors['lightBackground'],
        title: Text(
          'Edit $label',
          style: AppTheme.textStyles['title']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            keyboardType: TextInputType.number,
            style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
            validator: (value) {
              if (value == null || value.isEmpty) return '$label is required';
              final numValue = double.tryParse(value);
              if (numValue == null || numValue <= 0) return 'Enter a valid $label';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText'])),
          ),
          TextButton(
            onPressed: _isSaving
                ? null
                : () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, true);
                    }
                  },
            child: _isSaving
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(
                      color: AppTheme.colors['primaryText'],
                    ),
                  )
                : Text(
                    'Save',
                    style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                  ),
          ),
        ],
      ),
    );

    if (confirmed != true) return false;
    return await saveGoal(
      context: context,
      value: controller.text,
      type: type,
    );
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Account deleted successfully',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.green,
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
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.colors['lightBackground'],
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
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.green,
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