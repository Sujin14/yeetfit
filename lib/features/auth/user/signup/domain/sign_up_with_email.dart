import '../../login/domain/repositories/auth_repository.dart';

class SignUpWithEmail {
  final AuthRepository repository;
  SignUpWithEmail(this.repository);

  Future<bool> call(String email, String password) async {
    final result = await repository.signUpWithEmail(email, password);
    return result != null;
  }
}
