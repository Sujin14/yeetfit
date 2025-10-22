import '../repositories/auth_repository.dart';
import '../entities/auth_result.dart';

// Use case for sending password reset email.
class SendPasswordResetEmail {
  final AuthRepository repository;

  const SendPasswordResetEmail(this.repository);

  // Executes the password reset.
  Future<AuthResult> call(String email) {
    return repository.sendPasswordResetEmail(email);
  }
}