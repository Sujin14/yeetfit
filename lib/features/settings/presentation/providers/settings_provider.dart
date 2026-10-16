import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/painting.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yeetfit/core/services/notification_service.dart';
import '../../../user_info/data/datasources/account_functions_service.dart';
import '../../../user_info/data/datasources/firestore_user_service.dart';
import '../../../user_info/data/models/user_info_model.dart';
import '../../../user_info/domain/validators/user_info_validators.dart';
import '../../../user_info/presentation/providers/user_info_provider.dart';
import '../../../weight_tracking/presentation/providers/weight_provider.dart';

/// Settings operations that completed successfully; widgets map these to
/// feedback and navigation.
enum SettingsAction {
  basicInfoSaved,
  foodPreferencesSaved,
  fitnessGoalUpdated,
  profileImageUpdated,
  accountDeleted,
  loggedOut,
}

/// User-facing failure for a settings operation.
class SettingsFailure implements Exception {
  final String message;

  const SettingsFailure(this.message);

  @override
  String toString() => message;
}

/// Account deletion needs a fresh sign-in. Shown as a snackbar; the account
/// stays signed in.
class ReauthenticationRequiredFailure extends SettingsFailure {
  const ReauthenticationRequiredFailure()
    : super('Please sign out and sign in again before deleting your account.');
}

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, SettingsAction?>(
      SettingsController.new,
    );

class SettingsController extends AsyncNotifier<SettingsAction?> {
  final FirestoreUserService _userService = FirestoreUserService();

  @override
  FutureOr<SettingsAction?> build() => null;

  Future<void> _run(
    SettingsAction action,
    String errorPrefix,
    Future<void> Function() operation,
  ) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      await operation();
      if (ref.mounted) state = AsyncData(action);
    } on SettingsFailure catch (e, stackTrace) {
      if (ref.mounted) state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      if (ref.mounted) {
        state = AsyncError(SettingsFailure('$errorPrefix: $e'), stackTrace);
      }
    }
  }

  String _requireUid() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw const SettingsFailure('User not authenticated');
    return uid;
  }

  /// [update] receives the cached profile with `currentWeight` replaced by
  /// the latest saved value: the weight screen writes it straight to
  /// Firestore, so the cached one can be stale.
  Future<void> _saveProfile(
    String uid,
    UserInfoModel Function(UserInfoModel current) update,
  ) async {
    final cached =
        ref.read(userInfoControllerProvider).value ?? UserInfoModel(uid: uid);
    final latestWeight = (await _userService.getUserData(uid))?.currentWeight;
    final current = latestWeight != null && latestWeight > 0
        ? cached.copyWith(currentWeight: latestWeight)
        : cached;
    // The cached profile's uid can be empty (loaded from a doc without a
    // `uid` field), so always write to the signed-in user's document.
    final updated = update(
      current,
    ).copyWith(uid: uid, email: FirebaseAuth.instance.currentUser?.email);
    final clientFieldsChanged =
        updated.name != current.name ||
        updated.profileImageUrl != current.profileImageUrl;
    if (clientFieldsChanged) {
      await _userService.saveUserDataWithClient(updated);
    } else {
      await _userService.saveUserData(updated);
    }
    ref.read(userInfoControllerProvider.notifier).setProfile(updated);
  }

  /// [editedWeight] is null unless the user changed the weight field; the
  /// latest saved weight is kept otherwise.
  Future<void> saveBasicInformation({
    required String name,
    required String gender,
    required String age,
    required String height,
    required String? editedWeight,
    required String activityLevel,
  }) {
    return _run(
      SettingsAction.basicInfoSaved,
      'Error saving basic information',
      () async {
        final errors = [
          UserInfoValidators.validateName(name),
          UserInfoValidators.validateGender(gender),
          UserInfoValidators.validateAge(age),
          UserInfoValidators.validateHeight(height),
          if (editedWeight != null)
            UserInfoValidators.validateWeight(editedWeight),
          UserInfoValidators.validateActivityLevel(activityLevel),
        ].whereType<String>();
        final parsedAge = int.tryParse(age);
        final parsedHeight = double.tryParse(height);
        final parsedWeight = editedWeight == null
            ? null
            : double.tryParse(editedWeight);
        if (errors.isNotEmpty ||
            parsedAge == null ||
            parsedHeight == null ||
            (editedWeight != null && parsedWeight == null)) {
          throw SettingsFailure('Invalid input: ${errors.join(', ')}');
        }

        final uid = _requireUid();
        await _saveProfile(
          uid,
          (current) => current.copyWith(
            name: name.trim(),
            gender: gender,
            age: parsedAge,
            height: parsedHeight,
            currentWeight: parsedWeight,
            activityLevel: activityLevel,
          ),
        );
        if (parsedWeight != null) {
          await ref
              .read(weightRepositoryProvider)
              .updateCurrentWeight(uid, parsedWeight);
        }
      },
    );
  }

  Future<void> saveFoodPreferences({
    required String? dietPreference,
    required Map<String, bool> allergies,
    required String? otherAllergy,
    required Map<String, bool> cuisines,
  }) {
    return _run(
      SettingsAction.foodPreferencesSaved,
      'Error saving food preferences',
      () => _saveProfile(
        _requireUid(),
        (current) => current.copyWith(
          dietPreference: dietPreference,
          allergies: allergies,
          otherAllergy: otherAllergy?.trim(),
          cuisines: cuisines,
        ),
      ),
    );
  }

  /// Saves the fitness goal and target weight on the profile and mirrors the
  /// target into the weight-tracking goal, keeping its start weight and date.
  Future<void> updateGoals({required String goal, required double goalWeight}) {
    return _run(
      SettingsAction.fitnessGoalUpdated,
      'Error updating goals',
      () async {
        final errors = [
          UserInfoValidators.validateGoal(goal),
          UserInfoValidators.validateWeight(goalWeight.toString()),
        ].whereType<String>();
        if (errors.isNotEmpty) throw SettingsFailure(errors.join(', '));

        final uid = _requireUid();
        await _saveProfile(
          uid,
          (current) => current.copyWith(goal: goal, goalWeight: goalWeight),
        );
        final weightGoal = await ref
            .read(weightRepositoryProvider)
            .getUserWeightGoal(uid);
        final profile = ref.read(userInfoControllerProvider).value;
        await ref
            .read(weightRepositoryProvider)
            .setUserWeightGoal(
              uid,
              goalWeight,
              weightGoal?.initialWeight ?? profile?.currentWeight ?? goalWeight,
              weightGoal?.targetDate,
            );
      },
    );
  }

  /// Uploads a cropped photo to `profile_pictures/{uid}/avatar.jpg`, writes
  /// `profileImageUrl`, and updates the in-memory profile. Throws on failure.
  Future<void> saveCroppedProfilePhoto(XFile image) async {
    final uid = _requireUid();
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        'profile_pictures/$uid/avatar.jpg',
      );
      final uploadTask = await storageRef.putFile(File(image.path));
      final imageUrl = await uploadTask.ref.getDownloadURL();
      await CachedNetworkImage.evictFromCache(imageUrl);
      PaintingBinding.instance.imageCache.evict(NetworkImage(imageUrl));
      await _saveProfile(
        uid,
        (current) => current.copyWith(profileImageUrl: imageUrl),
      );
    } on FirebaseException catch (e) {
      throw SettingsFailure(
        e.code == 'permission-denied'
            ? 'Permission denied: Unable to upload profile image. Please check your account permissions.'
            : 'Firebase error: ${e.message}',
      );
    }
  }

  Future<void> updateProfileImage(XFile image) {
    return _run(
      SettingsAction.profileImageUpdated,
      'Failed to update photo',
      () => saveCroppedProfilePhoto(image),
    );
  }

  /// Deletes the account, then signs out locally. A stale session surfaces
  /// [ReauthenticationRequiredFailure] and leaves the account signed in.
  Future<void> deleteAccount() {
    return _run(
      SettingsAction.accountDeleted,
      'Error deleting account',
      () async {
        _requireUid();
        try {
          await ref.read(userInfoControllerProvider.notifier).deleteAccount();
        } on RecentLoginRequiredException {
          throw const ReauthenticationRequiredFailure();
        }
        await ref.read(notificationServiceProvider).onAccountDeleted();
        await FirebaseAuth.instance.signOut();
      },
    );
  }

  Future<void> logout() {
    return _run(SettingsAction.loggedOut, 'Error logging out', () async {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await ref.read(notificationServiceProvider).onSignOut(userId);
      }
      await FirebaseAuth.instance.signOut();
    });
  }
}
