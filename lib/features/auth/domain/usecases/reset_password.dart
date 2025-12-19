import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class SendPasswordResetEmail {
  final AuthRepository repository;

  const SendPasswordResetEmail(this.repository);

  Future<AuthResult> call(String email) {
    return repository.sendPasswordResetEmail(email);
  }
}
