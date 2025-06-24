import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/email_auth_service.dart';
import '../../data/datasources/google_auth_service.dart';
import '../../data/datasources/phone_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_with_google.dart';

final googleAuthControllerProvider =
    StateNotifierProvider<GoogleAuthController, bool>((ref) {
      final repo = AuthRepositoryImpl(
        emailService: EmailAuthService(),
        googleService: GoogleAuthService(),
        phoneService: PhoneAuthService(),
      );
      return GoogleAuthController(loginWithGoogle: LoginWithGoogle(repo));
    });

class GoogleAuthController extends StateNotifier<bool> {
  final LoginWithGoogle loginWithGoogle;

  GoogleAuthController({required this.loginWithGoogle}) : super(false);

  Future<void> login(BuildContext context) async {
    state = true;
    final success = await loginWithGoogle();
    state = false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Google login successful" : "Google login failed",
        ),
      ),
    );
  }
}
