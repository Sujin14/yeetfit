import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:yeetfit/core/constants/function_regions.dart';

/// Server-side account operations (Cloud Functions, Admin SDK).
class AccountFunctionsService {
  static const _deleteAccountFunction = 'deleteAccount';
  static const _recentLoginReason = 'requires-recent-login';

  final FirebaseFunctions _functions;
  final FirebaseFirestore _firestore;

  AccountFunctionsService({
    FirebaseFunctions? functions,
    FirebaseFirestore? firestore,
  }) : _functions =
           functions ??
           FirebaseFunctions.instanceFor(region: FunctionRegions.general),
       _firestore = firestore ?? FirebaseFirestore.instance;

  /// Deletes the signed-in user's data and Auth account.
  ///
  /// The Cloud Function removes subcollections, storage, and related
  /// documents, which a single document delete cannot. The client then
  /// deletes `users/{uid}` with a [WriteBatch] and calls [User.delete].
  /// A stale session fails on [User.delete] before any client write when
  /// the function did not already finish the wipe.
  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    final uid = user.uid;

    var wipedOnServer = false;
    try {
      await _functions
          .httpsCallable(
            _deleteAccountFunction,
            options: HttpsCallableOptions(timeout: const Duration(minutes: 5)),
          )
          .call<Object?>();
      wipedOnServer = true;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('Functions error: ${e.code} — ${e.message} — ${e.details}');
      if (_needsRecentLogin(e)) throw const RecentLoginRequiredException();
      if (e.code != 'not-found' && e.code != 'unavailable') {
        throw Exception('Account deletion failed: ${e.message}');
      }
    }

    if (!wipedOnServer) {
      try {
        await user.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code == _recentLoginReason) {
          throw const RecentLoginRequiredException();
        }
        rethrow;
      }
    } else {
      try {
        await user.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code != 'user-not-found') {
          debugPrint('Auth delete after server wipe: ${e.code}');
        }
      }
    }

    final batch = _firestore.batch();
    batch.delete(_firestore.collection('users').doc(uid));
    try {
      await batch.commit();
    } on FirebaseException catch (e) {
      debugPrint('Batch delete users/$uid failed: ${e.code} — ${e.message}');
    }
  }

  static bool _needsRecentLogin(FirebaseFunctionsException error) {
    final details = error.details;
    return error.code == _recentLoginReason ||
        (details is Map && details['reason'] == _recentLoginReason);
  }
}

/// The server refused to delete the account until the user signs in again.
class RecentLoginRequiredException implements Exception {
  const RecentLoginRequiredException();

  @override
  String toString() =>
      'Please sign out and sign in again before deleting your account.';
}
