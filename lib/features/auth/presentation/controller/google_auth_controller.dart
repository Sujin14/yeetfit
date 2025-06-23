import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/auth/presentation/services/google_auth_service.dart';

final googleAuthControllerProvider =
    StateNotifierProvider<GoogleAuthController, bool>(
      (ref) => GoogleAuthController(ref),
    );

class GoogleAuthController extends StateNotifier<bool> {
  final Ref ref;
  final GoogleAuthService _service = GoogleAuthService();

  GoogleAuthController(this.ref) : super(false);

  Future<void> login(BuildContext context) async {
    state = true;
    final result = await _service.signInWithGoogle();
    state = false;

    if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Google login successful")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Google login failed")));
    }
  }
}
