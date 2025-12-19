import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogle {
  final AuthRepository repository;

  const LoginWithGoogle(this.repository);

  Future<AuthResult> call() {
    return repository.signInWithGoogle();
  }
}
