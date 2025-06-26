import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/email_auth_service.dart';
import '../datasources/google_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final EmailAuthService emailService;
  final GoogleAuthService googleService;
  //final PhoneAuthService phoneService;

  AuthRepositoryImpl({
    required this.emailService,
    required this.googleService,
    //required this.phoneService,
  });

  // Email Auth
  @override
  Future<UserCredential?> signInWithEmail(String email, String password) {
    return emailService.signInWithEmail(email, password);
  }

  @override
  Future<UserCredential?> signUpWithEmail(String email, String password) {
    return emailService.signUpWithEmail(email, password);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return emailService.sendPasswordResetEmail(email);
  }

  // Google Auth
  @override
  Future<UserCredential?> signInWithGoogle() {
    return googleService.signInWithGoogle();
  }

  // // Phone Auth
  // @override
  // Future<void> verifyPhoneNumber({
  //   required String phoneNumber,
  //   required Function(String verificationId) onCodeSent,
  //   required Function(String error) onFailed,
  // }) {
  //   return phoneService.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     onCodeSent: onCodeSent,
  //     onFailed: onFailed,
  //   );
  // }

  // @override
  // Future<UserCredential?> signInWithOTP({
  //   required String verificationId,
  //   required String smsCode,
  // }) {
  //   return phoneService.signInWithOTP(
  //     verificationId: verificationId,
  //     smsCode: smsCode,
  //   );
  // }

  // @override
  // Future<bool> signinWithPhone(
  //   String phone,
  //   Function(String verificationId) onCodeSent,
  //   Function(String error) onError,
  // ) async {
  //   try {
  //     await phoneService.verifyPhoneNumber(
  //       phoneNumber: phone,
  //       onCodeSent: onCodeSent,
  //       onFailed: onError,
  //     );
  //     return true;
  //   } catch (e) {
  //     onError(e.toString());
  //     return false;
  //   }
  // }
}
