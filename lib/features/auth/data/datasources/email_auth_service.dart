import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/auth_error_mapper.dart';
import '../../domain/entities/auth_result.dart';

class EmailAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthResult> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success(uid: credential.user?.uid);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(AuthErrorMapper.mapFirebaseError(e.code));
    } catch (_) {
      return AuthResult.failure('Something went wrong. Please try again.');
    }
  }

  Future<AuthResult> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success(uid: credential.user?.uid);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(AuthErrorMapper.mapFirebaseError(e.code));
    } catch (_) {
      return AuthResult.failure('Something went wrong. Please try again.');
    }
  }

  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult.success(message: 'Password reset link sent to your email.');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(AuthErrorMapper.mapFirebaseError(e.code));
    } catch (_) {
      return AuthResult.failure('Something went wrong. Please try again.');
    }
  }
}
