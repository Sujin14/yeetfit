import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../user_info/data/datasources/firestore_user_service.dart';
import '../../../user_info/data/datasources/profile_completion_status.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../utils/auth_strings.dart';
import 'auth_providers.dart';

/// Runs one auth operation at a time; the state is `true` while it's running.
class AuthController extends Notifier<bool> {
  final FirestoreUserService _userService = FirestoreUserService();

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  bool build() => false;

  Future<AuthResult> loginWithEmail(String email, String password) =>
      _signIn(() => _repository.signInWithEmail(email, password));

  Future<AuthResult> signUpWithEmail(String email, String password) =>
      _signIn(() => _repository.signUpWithEmail(email, password));

  Future<AuthResult> loginWithGoogle() => _signIn(_repository.signInWithGoogle);

  Future<AuthResult> resetPassword(String email) async {
    state = true;
    final result = await _repository.sendPasswordResetEmail(email);
    if (ref.mounted) state = false;
    return result;
  }

  /// Signs in, then reports whether the user has already set up a profile.
  Future<AuthResult> _signIn(Future<AuthResult> Function() signIn) async {
    state = true;
    final authResult = await signIn();
    if (ref.mounted) state = false;

    if (!authResult.success) return authResult;
    final uid = authResult.uid;
    if (uid == null) return AuthResult.failure(AuthStrings.noUserIdError);

    final exists = await _userService.checkUserExists(uid);
    if (exists) ProfileCompletionStatus.markComplete(uid);
    return AuthResult.success(
      uid: uid,
      userExists: exists,
      message: authResult.message,
    );
  }
}
