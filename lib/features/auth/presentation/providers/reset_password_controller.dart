import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/usecases/reset_password.dart';

class ResetPasswordController extends StateNotifier<bool> {
  final SendPasswordResetEmail resetPasswordUseCase;

  ResetPasswordController({required this.resetPasswordUseCase}) : super(false);

  Future<AuthResult> resetPassword(String email) async {
    state = true;
    final result = await resetPasswordUseCase(email);
    state = false;
    return result;
  }
}
