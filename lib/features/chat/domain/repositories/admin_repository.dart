import '../../data/model/admin_model.dart';

abstract class AdminRepository {
  Stream<List<AdminModel>> getAdmins();
}