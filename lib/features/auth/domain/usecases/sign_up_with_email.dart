import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmail {
  final AuthRepository repository;

  const SignUpWithEmail(this.repository);

  Future<AuthResult> call(String email, String password) {
    return repository.signUpWithEmail(email, password);
  }
}
