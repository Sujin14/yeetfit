import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/auth_result.dart';
import '../../utils/auth_strings.dart';
import 'auth_service.dart';
import 'auth_utils.dart';

class EmailAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<AuthResult> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success(uid: credential.user?.uid);
    } catch (e) {
      return handleFirebaseAuthError(e);
    }
  }

  @override
  Future<AuthResult> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success(uid: credential.user?.uid);
    } catch (e) {
      return handleFirebaseAuthError(e);
    }
  }

  @override
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult.success(message: AuthStrings.passwordResetSuccess);
    } catch (e) {
      return handleFirebaseAuthError(e);
    }
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    throw UnimplementedError();
  }
}