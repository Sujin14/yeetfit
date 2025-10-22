import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/auth_result.dart';
import '../../utils/auth_strings.dart';
import 'auth_service.dart';
import 'auth_utils.dart';

class GoogleAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult.failure(AuthStrings.googleSignInCancelled);
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return AuthResult.success(uid: userCredential.user?.uid);
    } catch (e) {
      return handleFirebaseAuthError(e);
    }
  }

  @override
  Future<AuthResult> signInWithEmail(String email, String password) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthResult> signUpWithEmail(String email, String password) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    throw UnimplementedError();
  }
}