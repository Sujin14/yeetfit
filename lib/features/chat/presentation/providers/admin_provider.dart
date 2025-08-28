import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasource/admin_service.dart';
import '../../data/model/admin_model.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/use_cases/get_admins.dart';

class AdminState {
  final List<AdminModel> admins;
  final bool isLoading;
  final String? error;

  AdminState({
    this.admins = const [],
    this.isLoading = true,
    this.error,
  });

  AdminState copyWith({
    List<AdminModel>? admins,
    bool? isLoading,
    String? error,
  }) {
    return AdminState(
      admins: admins ?? this.admins,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AdminController extends StateNotifier<AdminState> {
  final GetAdmins getAdmins;

  AdminController(this.getAdmins) : super(AdminState()) {
    _fetchAdmins();
  }

  void _fetchAdmins() {
    getAdmins().listen(
      (admins) {
        state = state.copyWith(admins: admins, isLoading: false);
      },
      onError: (e) {
        state = state.copyWith(isLoading: false, error: 'Failed to load admins: $e');
      },
    );
  }

  void selectAdmin(BuildContext context, String adminId) {
    context.go('/chat', extra: adminId);
  }

  void navigateBack(BuildContext context) {
    context.go('/user-dashboard');
  }
}

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