import '../repositories/auth_repository.dart';
import '../entities/auth_result.dart';

// Use case for signing up with email.
class SignUpWithEmail {
  final AuthRepository repository;

  const SignUpWithEmail(this.repository);

  // Executes the signup.
  Future<AuthResult> call(String email, String password) {
    return repository.signUpWithEmail(email, password);
  }
}