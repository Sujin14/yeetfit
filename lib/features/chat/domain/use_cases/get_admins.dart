import '../../data/model/admin_model.dart';
import '../repositories/admin_repository.dart';

class GetAdmins {
  final AdminRepository repository;

  GetAdmins(this.repository);

  Stream<List<AdminModel>> call() {
    return repository.getAdmins();
  }
}