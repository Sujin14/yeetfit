import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmail {
  final AuthRepository repository;

  const LoginWithEmail(this.repository);

  Future<AuthResult> call(String email, String password) {
    return repository.signInWithEmail(email, password);
  }
}