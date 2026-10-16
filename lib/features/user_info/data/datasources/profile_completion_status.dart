import 'package:flutter/foundation.dart';
import 'firestore_user_service.dart';

/// Whether an account has finished profile setup, cached per uid so the
/// router redirect only queries Firestore once per session.
class ProfileCompletionStatus {
  ProfileCompletionStatus._();

  static final FirestoreUserService _userService = FirestoreUserService();

  // Only positive results are cached: an incomplete profile can become
  // complete at any moment while the user is in the setup flow.
  static final Set<String> _completeUids = {};

  /// `true` once known complete, otherwise `null` (unknown).
  static bool? cachedComplete(String uid) =>
      _completeUids.contains(uid) ? true : null;

  static void markComplete(String uid) => _completeUids.add(uid);

  /// Fails open: if Firestore is unreachable with nothing cached, the user
  /// isn't locked out of the app.
  static Future<bool> isComplete(String uid) async {
    if (_completeUids.contains(uid)) return true;
    try {
      final complete = await _userService.checkUserExists(uid);
      if (complete) _completeUids.add(uid);
      return complete;
    } catch (error) {
      debugPrint('Profile completion check failed: $error');
      return true;
    }
  }
}
