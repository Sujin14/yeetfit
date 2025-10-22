import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/sign_up_with_email.dart';
import '../../../user_info/domain/repositories/user_repository.dart';

// Controller for email-based authentication operations.
class EmailAuthController extends StateNotifier<bool> {
  final LoginWithEmail loginWithEmail;
  final SendPasswordResetEmail resetPasswordUseCase;
  final SignUpWithEmail signUpWithEmail;
  final UserRepository userRepository;

  EmailAuthController({
    required this.loginWithEmail,
    required this.resetPasswordUseCase,
    required this.signUpWithEmail,
    required this.userRepository,
  }) : super(false);

  // Logs in with email and password, checks user existence.
  Future<AuthResult> login(String email, String password) async {
    state = true;
    final authResult = await loginWithEmail(email, password);
    state = false;

    if (authResult.success) {
      final uid = authResult.uid;
      if (uid == null) return AuthResult.failure('No user ID received.');

      final exists = await userRepository.checkUserExists(uid);
      return AuthResult.success(
        uid: uid,
        userExists: exists,
        message: authResult.message,
      );
    }
    return authResult;
  }

  // Sends password reset email.
  Future<AuthResult> resetPassword(String email) async {
    return resetPasswordUseCase(email);
  }

  // Signs up with email and password, checks user existence.
  Future<AuthResult> signUp(String email, String password) async {
    state = true;
    final authResult = await signUpWithEmail(email, password);
    state = false;

    if (authResult.success) {
      final uid = authResult.uid;
      if (uid == null) return AuthResult.failure('No user ID received.');

      final exists = await userRepository.checkUserExists(uid);
      return AuthResult.success(
        uid: uid,
        userExists: exists,
        message: authResult.message,
      );
    }
    return authResult;
  }
}