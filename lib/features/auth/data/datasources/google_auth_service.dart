import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/utils/auth_error_mapper.dart';
import '../../domain/entities/auth_result.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult.failure('Google sign-in was cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return AuthResult.success(uid: userCredential.user?.uid);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(AuthErrorMapper.mapFirebaseError(e.code));
    } catch (e) {
      if (e.toString().contains('network-request-failed')) {
        return AuthResult.failure(
          'Network error: Please check your internet connection and try again.',
        );
      }
      return AuthResult.failure('Google sign-in failed. Please try again.');
    }
  }
}
