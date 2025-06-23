import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/auth/presentation/services/admin_auth_services/admin_auth_service.dart';

final adminAuthControllerProvider =
    StateNotifierProvider<AdminAuthController, bool>(
      (ref) => AdminAuthController(ref),
    );

class AdminAuthController extends StateNotifier<bool> {
  final Ref ref;
  final AdminAuthService _service = AdminAuthService();

  AdminAuthController(this.ref) : super(false); // false = not loading

  Future<void> loginAsAdmin({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final isValid = await _service.validateAdminCredentials(username, password);
    state = false;

    if (isValid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid admin credentials")),
      );
    }
  }
}
