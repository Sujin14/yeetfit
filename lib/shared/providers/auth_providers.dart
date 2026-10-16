import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Emits on sign-in and sign-out only.
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

/// Emits on sign-in/out and on profile changes (display name, photo URL).
final currentUserProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.userChanges(),
);

/// The signed-in user's uid. Follows sign-in/out, so screens and their
/// user-keyed providers never keep querying a previous account's data.
final authUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  // Before the first auth event arrives, use the restored session.
  return authState.hasValue
      ? authState.value?.uid
      : FirebaseAuth.instance.currentUser?.uid;
});
