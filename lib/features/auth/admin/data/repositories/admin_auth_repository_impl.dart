import '../../domain/repositories/admin_auth_repository.dart';
import '../services/admin_auth_services.dart';

class AdminAuthRepositoryImpl implements AdminAuthRepository {
  final AdminAuthService service;
  AdminAuthRepositoryImpl(this.service);

  @override
  Future<bool> login(String username, String password) {
    return service.validateAdminCredentials(username, password);
  }
}
