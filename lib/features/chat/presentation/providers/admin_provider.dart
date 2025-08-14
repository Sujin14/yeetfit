import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasource/admin_service.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/use_cases/get_admins.dart';
import '../controllers/admin_controller.dart';

final adminServiceProvider = Provider<AdminService>((ref) {
  return AdminService();
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final service = ref.read(adminServiceProvider);
  return AdminRepositoryImpl(service);
});

final getAdminsProvider = Provider<GetAdmins>((ref) {
  final repository = ref.read(adminRepositoryProvider);
  return GetAdmins(repository);
});

final adminControllerProvider =
    StateNotifierProvider<AdminController, AdminState>((ref) {
      final getAdmins = ref.read(getAdminsProvider);
      return AdminController(getAdmins);
    });
