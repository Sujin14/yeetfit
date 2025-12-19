import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/auth_error_mapper.dart';
import '../../domain/entities/auth_result.dart';
import '../../utils/auth_strings.dart';

AuthResult handleFirebaseAuthError(dynamic e) {
  if (e is FirebaseAuthException) {
    return AuthResult.failure(AuthErrorMapper.mapFirebaseError(e.code));
  } else if (e.toString().contains('network-request-failed')) {
    return AuthResult.failure(AuthStrings.networkError);
  }
  return AuthResult.failure(AuthStrings.genericError);
}