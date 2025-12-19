import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/usecases/sign_up_with_email.dart';
import '../../../user_info/domain/repositories/user_repository.dart';
import '../../utils/auth_strings.dart';

class SignUpController extends StateNotifier<bool> {
  final SignUpWithEmail signUpWithEmail;
  final UserRepository userRepository;

  SignUpController({
    required this.signUpWithEmail,
    required this.userRepository,
  }) : super(false);

  Future<AuthResult> signUp(String email, String password) async {
    state = true;
    final authResult = await signUpWithEmail(email, password);
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