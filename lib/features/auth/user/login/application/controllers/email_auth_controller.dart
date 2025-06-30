import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../signup/domain/sign_up_with_email.dart';
import '../../data/datasources/email_auth_service.dart';
import '../../data/datasources/google_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/firestore_user_service.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/reset_password.dart';

final emailAuthControllerProvider =
    StateNotifierProvider<EmailAuthController, bool>((ref) {
      final repo = AuthRepositoryImpl(
        emailService: EmailAuthService(),
        googleService: GoogleAuthService(),
        // phoneService: PhoneAuthService(), // removed temporarily
      );

      return EmailAuthController(
        loginWithEmail: LoginWithEmail(repo),
        resetPasswordUseCase: SendPasswordResetEmail(repo),
        signUpWithEmail: SignUpWithEmail(repo),
        ref: ref,
      );
    });

class EmailAuthController extends StateNotifier<bool> {
  final LoginWithEmail loginWithEmail;
  final SendPasswordResetEmail resetPasswordUseCase;
  final SignUpWithEmail signUpWithEmail;
  final Ref ref;

  EmailAuthController({
    required this.loginWithEmail,
    required this.resetPasswordUseCase,
    required this.signUpWithEmail,
    required this.ref,
  }) : super(false);

  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = true;
    final success = await loginWithEmail(email, password);
    state = false;
    return success;
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    await resetPasswordUseCase(email);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Password reset link sent")));
  }

  Future<bool> signUp(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = true;
    final success = await signUpWithEmail(email, password);
    state = false;
    return success;
  }

  Future<void> handlePostSignup(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final exists = await ref.read(userServiceProvider).checkUserExists(uid);

    if (exists) {
      context.go('/user-dashboard');
    } else {
      context.go('/onboarding-info');
    }
  }
}
