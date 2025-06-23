import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/auth/presentation/services/email_auth_service.dart';

final emailAuthControllerProvider =
    StateNotifierProvider<EmailAuthController, bool>(
      (ref) => EmailAuthController(ref),
    );

class EmailAuthController extends StateNotifier<bool> {
  final Ref ref;
  final EmailAuthService _service = EmailAuthService();

  EmailAuthController(this.ref) : super(false);

  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = true;
    final result = await _service.signInWithEmail(email, password);
    state = false;
    return result != null;
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    await _service.sendPasswordResetEmail(email);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Password reset link sent")));
  }
}
