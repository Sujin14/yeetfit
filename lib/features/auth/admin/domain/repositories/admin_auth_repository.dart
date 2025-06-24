abstract class AdminAuthRepository {
  Future<bool> login(String username, String password);
}
