import '../../domain/entities/auth_result.dart';
import '../datasources/email_auth_service.dart';
import '../datasources/google_auth_service.dart';
import '../../domain/repositories/auth_repository.dart';

// Implementation of [AuthRepository] using Firebase services.
class AuthRepositoryImpl implements AuthRepository {
  final EmailAuthService emailService;
  final GoogleAuthService googleService;

  const AuthRepositoryImpl({
    required this.emailService,
    required this.googleService,
  });

  @override
  Future<AuthResult> signInWithEmail(String email, String password) {
    return emailService.signInWithEmail(email, password);
  }

  @override
  Future<AuthResult> signUpWithEmail(String email, String password) {
    return emailService.signUpWithEmail(email, password);
  }

  @override
  Future<AuthResult> sendPasswordResetEmail(String email) {
    return emailService.sendPasswordResetEmail(email);
  }

  @override
  Future<AuthResult> signInWithGoogle() {
    return googleService.signInWithGoogle();
  }
}