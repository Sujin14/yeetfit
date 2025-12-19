import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../../user_info/domain/repositories/user_repository.dart';

// Controller for Google-based authentication operations.
class GoogleAuthController extends StateNotifier<bool> {
  final LoginWithGoogle loginWithGoogle;
  final UserRepository userRepository;

  GoogleAuthController({
    required this.loginWithGoogle,
    required this.userRepository,
  }) : super(false);

  // Logs in with Google, checks user existence.
  Future<AuthResult> login() async {
    state = true;
    final authResult = await loginWithGoogle();
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