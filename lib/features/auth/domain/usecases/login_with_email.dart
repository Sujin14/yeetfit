import '../repositories/auth_repository.dart';
import '../entities/auth_result.dart';

// Use case for logging in with email.
class LoginWithEmail {
  final AuthRepository repository;

  const LoginWithEmail(this.repository);

  // Executes the login.
  Future<AuthResult> call(String email, String password) {
    return repository.signInWithEmail(email, password);
  }
}