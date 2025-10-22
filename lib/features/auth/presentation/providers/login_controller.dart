import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../../user_info/domain/repositories/user_repository.dart';
import '../../utils/auth_strings.dart';

class LoginController extends StateNotifier<bool> {
  final LoginWithEmail loginWithEmail;
  final UserRepository userRepository;

  LoginController({
    required this.loginWithEmail,
    required this.userRepository,
  }) : super(false);

  Future<AuthResult> login(String email, String password) async {
    state = true;
    final authResult = await loginWithEmail(email, password);
    state = false;

    if (authResult.success) {
      final uid = authResult.uid;
      if (uid == null) return AuthResult.failure(AuthStrings.noUserIdError);

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