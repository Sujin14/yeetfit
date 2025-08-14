import '../../data/model/admin_model.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasource/admin_service.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminService service;

  AdminRepositoryImpl(this.service);

  @override
  Stream<List<AdminModel>> getAdmins() {
    return service.getAdmins();
  }
}