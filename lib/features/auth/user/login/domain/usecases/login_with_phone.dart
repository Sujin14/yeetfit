import '../repositories/auth_repository.dart';

class LoginWithPhone {
  final AuthRepository repository;
  LoginWithPhone(this.repository);

  Future<bool> call(
    String phone,
    Function(String) onCodeSent,
    Function(String) onError,
  ) {
    return repository.signinWithPhone(phone, onCodeSent, onError);
  }
}
