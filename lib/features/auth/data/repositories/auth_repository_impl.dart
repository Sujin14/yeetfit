import 'package:firebase_auth/firebase_auth.dart';
import '../datasources/email_auth_service.dart';
import '../datasources/google_auth_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final EmailAuthService emailService;
  final GoogleAuthService googleService;

  AuthRepositoryImpl({required this.emailService, required this.googleService});

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

  @override
  Future<UserCredential?> signInWithGoogle() {
    return googleService.signInWithGoogle();
  }
}
