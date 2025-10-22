
import '../entities/auth_result.dart';

// Abstract repository for authentication operations.
abstract class AuthRepository {
  // Signs in with email and password.
  Future<AuthResult> signInWithEmail(String email, String password);

  // Signs up with email and password.
  Future<AuthResult> signUpWithEmail(String email, String password);

  // Sends password reset email.
  Future<AuthResult> sendPasswordResetEmail(String email);

  // Signs in with Google.
  Future<AuthResult> signInWithGoogle();
}