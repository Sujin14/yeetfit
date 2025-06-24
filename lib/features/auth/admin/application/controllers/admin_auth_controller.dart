import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/admin_auth_repository_impl.dart';
import '../../data/services/admin_auth_services.dart';
import '../../domain/usecases/admin_login.dart';

final adminAuthControllerProvider =
    StateNotifierProvider<AdminAuthController, bool>((ref) {
      return AdminAuthController(
        loginUseCase: AdminLogin(AdminAuthRepositoryImpl(AdminAuthService())),
      );
    });

class AdminAuthController extends StateNotifier<bool> {
  final AdminLogin loginUseCase;

  AdminAuthController({required this.loginUseCase}) : super(false);

  Future<void> loginAsAdmin({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final isValid = await loginUseCase(username, password);
    state = false;

    if (isValid) {
      context.go('/admin-dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid admin credentials")),
      );
    }
  }
}
