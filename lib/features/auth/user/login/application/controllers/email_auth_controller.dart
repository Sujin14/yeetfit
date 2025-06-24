import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../signup/domain/sign_up_with_email.dart';
import '../../data/datasources/email_auth_service.dart';
import '../../data/datasources/google_auth_service.dart';
import '../../data/datasources/phone_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/reset_password.dart';

final emailAuthControllerProvider =
    StateNotifierProvider<EmailAuthController, bool>((ref) {
      final repo = AuthRepositoryImpl(
        emailService: EmailAuthService(),
        googleService: GoogleAuthService(),
        phoneService: PhoneAuthService(),
      );

      return EmailAuthController(
        loginWithEmail: LoginWithEmail(repo),
        resetPasswordUseCase: SendPasswordResetEmail(repo),
        signUpWithEmail: SignUpWithEmail(repo),
      );
    });

class EmailAuthController extends StateNotifier<bool> {
  final LoginWithEmail loginWithEmail;
  final SendPasswordResetEmail resetPasswordUseCase;
  final SignUpWithEmail signUpWithEmail;

  EmailAuthController({
    required this.loginWithEmail,
    required this.resetPasswordUseCase,
    required this.signUpWithEmail,
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
}
