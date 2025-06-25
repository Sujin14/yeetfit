import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  // Email Auth
  Future<UserCredential?> signInWithEmail(String email, String password);
  Future<UserCredential?> signUpWithEmail(String email, String password);
  Future<void> sendPasswordResetEmail(String email);

  // Google Auth
  Future<UserCredential?> signInWithGoogle();
}

  /* Phone Auth
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onFailed,
  });
  Future<UserCredential?> signInWithOTP({
    required String verificationId,
    required String smsCode,
  });

  Future<bool> signinWithPhone(
    String phone,
    Function(String verificationId) onCodeSent,
    Function(String error) onError,
  );
  */

