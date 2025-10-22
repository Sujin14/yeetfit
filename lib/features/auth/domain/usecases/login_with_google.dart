import '../repositories/auth_repository.dart';
import '../entities/auth_result.dart';

// Use case for logging in with Google.
class LoginWithGoogle {
  final AuthRepository repository;

  const LoginWithGoogle(this.repository);

  // Executes the Google login.
  Future<AuthResult> call() {
    return repository.signInWithGoogle();
  }
}