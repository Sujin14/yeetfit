import '../../login/domain/repositories/auth_repository.dart';

class LoginWithGoogle {
  final AuthRepository repository;
  LoginWithGoogle(this.repository);

  Future<bool> call() async {
    final result = await repository.signInWithGoogle();
    return result != null;
  }
}
