import '../entities/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> signInWithEmail(String email, String password);
  Future<AuthResult> signUpWithEmail(String email, String password);
  Future<AuthResult> sendPasswordResetEmail(String email);
  Future<AuthResult> signInWithGoogle();
}