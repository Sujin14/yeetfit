import '../repositories/admin_auth_repository.dart';

class AdminLogin {
  final AdminAuthRepository repository;
  AdminLogin(this.repository);

  Future<bool> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
