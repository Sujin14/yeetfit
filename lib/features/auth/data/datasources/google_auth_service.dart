import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/auth_result.dart';
import '../../utils/auth_strings.dart';
import 'auth_utils.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // GoogleSignIn.initialize must be called exactly once per app lifetime.
  static Future<void>? _initialization;

  Future<AuthResult> signInWithGoogle() async {
    try {
      await (_initialization ??= _googleSignIn.initialize());
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return AuthResult.success(uid: userCredential.user?.uid);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return AuthResult.failure(AuthStrings.googleSignInCancelled);
      }
      return handleFirebaseAuthError(e);
    } catch (e) {
      return handleFirebaseAuthError(e);
    }
  }
}
