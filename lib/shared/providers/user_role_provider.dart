import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'auth_providers.dart';

/// Whether the signed-in user is a coach (`users/{uid}.role == 'admin'`).
/// Coaches schedule group sessions; Firestore rules enforce the same check.
final isAdminProvider = StreamProvider<bool>((ref) {
  final userId = ref.watch(authUserIdProvider);
  if (userId == null) return Stream.value(false);
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((doc) => doc.data()?['role'] == 'admin');
});
