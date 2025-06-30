import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/services/firestore_user_service.dart';
import '../../../user_info_collection/application/user_info_controller.dart';
import '../../data/datasources/email_auth_service.dart';
import '../../data/datasources/google_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_with_google.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleAuthControllerProvider =
    StateNotifierProvider<GoogleAuthController, bool>((ref) {
      final repo = AuthRepositoryImpl(
        emailService: EmailAuthService(),
        googleService: GoogleAuthService(),
      );
      return GoogleAuthController(
        loginWithGoogle: LoginWithGoogle(repo),
        ref: ref,
      );
    });

class GoogleAuthController extends StateNotifier<bool> {
  final LoginWithGoogle loginWithGoogle;
  final Ref ref;

  GoogleAuthController({required this.loginWithGoogle, required this.ref})
    : super(false);

  Future<void> login(BuildContext context) async {
    state = true;
    try {
      final success = await loginWithGoogle();
      if (success) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          final exists = await ref
              .read(firestoreUserServiceProvider)
              .checkUserExists(uid);
          if (exists) {
            context.go('/user-dashboard');
          } else {
            ref.read(userInfoControllerProvider.notifier).reset();
            context.go('/user-info-step/0');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not authenticated')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google login canceled or failed')),
        );
        await GoogleSignIn().signOut();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google Sign-In error: $e')));
      await GoogleSignIn().signOut();
    } finally {
      state = false;
    }
  }
}

final firestoreUserServiceProvider = Provider<FirestoreUserService>((ref) {
  return FirestoreUserService();
});
