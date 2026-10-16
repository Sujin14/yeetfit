import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import '../../data/datasources/account_functions_service.dart';
import '../../data/datasources/firestore_user_service.dart';
import '../../data/datasources/profile_completion_status.dart';
import '../../data/models/user_info_model.dart';
import '../../domain/validators/user_info_validators.dart';

final userInfoControllerProvider =
    AsyncNotifierProvider<UserInfoController, UserInfoModel>(
      UserInfoController.new,
    );

class UserInfoController extends AsyncNotifier<UserInfoModel> {
  final FirestoreUserService _userService = FirestoreUserService();
  final AccountFunctionsService _accountService = AccountFunctionsService();
  bool _isSaving = false;
  final Map<String, dynamic> _formValues = {};

  @override
  Future<UserInfoModel> build() {
    // Rebuilding recreates this notifier, so a new login never sees or saves
    // over the previous user's cached profile or form values.
    ref.watch(authStateProvider.select((user) => user.value?.uid));
    return _load();
  }

  void setFormValue(String key, dynamic value) {
    _formValues[key] = value;
  }

  dynamic formValue(String key) => _formValues[key];

  Future<UserInfoModel> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    final userData = await _userService.getUserData(uid);
    return userData ??
        UserInfoModel(
          uid: uid,
          email: FirebaseAuth.instance.currentUser?.email,
        );
  }

  Future<void> fetchUserData() async {
    final result = await AsyncValue.guard(_load);
    if (ref.mounted) state = result;
  }

  /// Replaces the cached profile after it was saved elsewhere (Settings).
  void setProfile(UserInfoModel profile) => state = AsyncData(profile);

  void _updateLoaded(UserInfoModel Function(UserInfoModel current) update) {
    final current = state.value;
    if (current != null) state = AsyncData(update(current));
  }

  void updateGender(String gender) =>
      _updateLoaded((userInfo) => userInfo.copyWith(gender: gender.trim()));

  void updateGoal(String goal) =>
      _updateLoaded((userInfo) => userInfo.copyWith(goal: goal));

  void updateActivityLevel(String activityLevel) => _updateLoaded(
    (userInfo) => userInfo.copyWith(activityLevel: activityLevel),
  );

  /// Uploads [image] (picked by the widget) and stores its URL on the profile.
  /// Throws [ProfileImageUploadException] on failure; the form state is kept.
  Future<void> updateProfileImage(XFile image) async {
    if (_isSaving) return;
    _isSaving = true;
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw const ProfileImageUploadException('User not authenticated');
      }
      final storageRef = FirebaseStorage.instance.ref().child(
        'profile_pictures/$uid/avatar.jpg',
      );
      await storageRef.putFile(File(image.path));
      final url = await storageRef.getDownloadURL();
      final current = state.value;
      if (current != null) {
        final updatedUserInfo = current.copyWith(profileImageUrl: url);
        await _userService.saveUserData(updatedUserInfo);
        if (ref.mounted) state = AsyncData(updatedUserInfo);
      }
    } on ProfileImageUploadException {
      rethrow;
    } catch (e) {
      throw ProfileImageUploadException(
        e.toString().contains('requires recent authentication')
            ? 'Session expired. Please log in again.'
            : 'Failed to upload image: $e',
        requiresReauthentication: e.toString().contains(
          'requires recent authentication',
        ),
      );
    } finally {
      _isSaving = false;
    }
  }

  /// Validates the collected values for [step]; returns an error message or
  /// `null`. Form-field validation is done by the widget beforehand.
  String? validateStep(int step) {
    final userInfo =
        state.value ??
        UserInfoModel(uid: FirebaseAuth.instance.currentUser?.uid ?? '');
    return switch (step) {
      0 =>
        UserInfoValidators.validateName(_formValues['name'] ?? userInfo.name) ??
            UserInfoValidators.validateGender(
              _formValues['gender'] ?? userInfo.gender,
            ),
      1 => UserInfoValidators.validateAge(
        _formValues['age']?.toString() ?? userInfo.age.toString(),
      ),
      2 => UserInfoValidators.validateGoal(
        _formValues['goal'] ?? userInfo.goal,
      ),
      3 =>
        UserInfoValidators.validateWeight(
              _formValues['currentWeight']?.toString() ??
                  userInfo.currentWeight.toString(),
            ) ??
            UserInfoValidators.validateWeight(
              _formValues['goalWeight']?.toString() ??
                  userInfo.goalWeight.toString(),
            ),
      4 => UserInfoValidators.validateHeight(
        _formValues['height']?.toString() ?? userInfo.height.toString(),
      ),
      5 => UserInfoValidators.validateActivityLevel(
        _formValues['activityLevel'] ?? userInfo.activityLevel,
      ),
      6 => UserInfoValidators.validateTimeDuration(
        _formValues['timeDurationWeeks']?.toString() ??
            userInfo.timeDurationWeeks?.toString() ??
            '',
      ),
      _ => null,
    };
  }

  /// Saves the values collected up to [step] and returns the next step.
  /// Throws [UserInfoSaveException] on invalid data or a failed save.
  Future<int> saveStepData(int step) async {
    await _save(
      validateStep: step,
      update: (userInfo) => userInfo.copyWith(
        name: _formValues['name'] ?? userInfo.name,
        gender: _formValues['gender'] ?? userInfo.gender,
        age: _formValues['age'] ?? userInfo.age,
        goal: _formValues['goal'] ?? userInfo.goal,
        currentWeight: _formValues['currentWeight'] ?? userInfo.currentWeight,
        goalWeight: _formValues['goalWeight'] ?? userInfo.goalWeight,
        height: _formValues['height'] ?? userInfo.height,
        activityLevel: _formValues['activityLevel'] ?? userInfo.activityLevel,
        timeDurationWeeks:
            _formValues['timeDurationWeeks'] ?? userInfo.timeDurationWeeks,
      ),
    );
    return step + 1;
  }

  /// Saves the final step. Throws [UserInfoSaveException] on failure.
  Future<void> submitUserData() {
    return _save(
      validateStep: 6,
      completesProfile: true,
      update: (userInfo) => userInfo.copyWith(
        timeDurationWeeks:
            _formValues['timeDurationWeeks'] ?? userInfo.timeDurationWeeks,
      ),
    );
  }

  /// On failure the in-memory profile is kept so the form isn't lost.
  /// [completesProfile] also creates the coach-discoverable client doc.
  Future<void> _save({
    int? validateStep,
    bool completesProfile = false,
    required UserInfoModel Function(UserInfoModel current) update,
  }) async {
    if (_isSaving) {
      throw const UserInfoSaveException('A save is already in progress');
    }
    if (validateStep != null) {
      final error = this.validateStep(validateStep);
      if (error != null) throw UserInfoSaveException(error);
    }

    _isSaving = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw const UserInfoSaveException('User not authenticated');
      }
      final current = state.value ?? UserInfoModel(uid: user.uid);
      final updated = update(
        current,
      ).copyWith(uid: user.uid, email: user.email);
      if (completesProfile) {
        await _userService.saveUserDataWithClient(updated);
      } else {
        await _userService.saveUserData(updated);
      }
      if (ref.mounted) state = AsyncData(updated);
    } on UserInfoSaveException {
      rethrow;
    } catch (e) {
      throw UserInfoSaveException('Error saving data: $e');
    } finally {
      _isSaving = false;
    }
  }

  /// Deletes the user's data and Auth account through the `deleteAccount`
  /// Cloud Function. Throws on failure, including
  /// [RecentLoginRequiredException]. The caller signs out afterwards.
  Future<void> deleteAccount() async {
    if (_isSaving) {
      throw StateError('Another profile update is in progress');
    }
    _isSaving = true;
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        throw Exception('User not authenticated');
      }
      await _accountService.deleteAccount();
      if (ref.mounted) state = AsyncData(UserInfoModel());
    } finally {
      _isSaving = false;
    }
  }

  /// Moves back one step and returns its index, or `null` when there is no
  /// previous step. The widget performs the navigation.
  int? previousStep(int step) {
    if (_isSaving || step <= 0) return null;
    return step - 1;
  }
}

/// Outcome of a profile-setup save, consumed once by the stepper widget.
sealed class UserInfoSaveResult {
  const UserInfoSaveResult();
}

class UserInfoStepSaved extends UserInfoSaveResult {
  final int nextStep;

  const UserInfoStepSaved(this.nextStep);
}

class UserInfoSubmitted extends UserInfoSaveResult {
  const UserInfoSubmitted();
}

/// Save status for the profile-setup stepper: loading while saving, data
/// with the result on success, error with a [UserInfoSaveException].
final userInfoSaveControllerProvider =
    AsyncNotifierProvider.autoDispose<
      UserInfoSaveController,
      UserInfoSaveResult?
    >(UserInfoSaveController.new);

class UserInfoSaveController extends AsyncNotifier<UserInfoSaveResult?> {
  @override
  FutureOr<UserInfoSaveResult?> build() => null;

  UserInfoController get _userInfoController =>
      ref.read(userInfoControllerProvider.notifier);

  Future<void> saveStep(int step) {
    final userInfoController = _userInfoController;
    return _run(
      () async =>
          UserInfoStepSaved(await userInfoController.saveStepData(step)),
    );
  }

  Future<void> submit() {
    final userInfoController = _userInfoController;
    return _run(() async {
      await userInfoController.submitUserData();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) ProfileCompletionStatus.markComplete(uid);
      return const UserInfoSubmitted();
    });
  }

  /// Clears a handled result so it isn't acted on twice.
  void consume() => state = const AsyncData(null);

  Future<void> _run(Future<UserInfoSaveResult> Function() action) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      final result = await action();
      if (ref.mounted) state = AsyncData(result);
    } on UserInfoSaveException catch (e, stackTrace) {
      if (ref.mounted) state = AsyncError(e, stackTrace);
    }
  }
}

class UserInfoSaveException implements Exception {
  final String message;

  const UserInfoSaveException(this.message);

  @override
  String toString() => message;
}

class ProfileImageUploadException implements Exception {
  final String message;
  final bool requiresReauthentication;

  const ProfileImageUploadException(
    this.message, {
    this.requiresReauthentication = false,
  });

  @override
  String toString() => message;
}
