// Represents the result of an authentication operation.
class AuthResult {
  final bool success;
  final String? message;
  final String? uid;
  final bool? userExists;

  const AuthResult({
    required this.success,
    this.message,
    this.uid,
    this.userExists,
  });

  factory AuthResult.success({
    String? uid,
    bool? userExists,
    String? message = 'Authentication successful',
  }) {
    return AuthResult(
      success: true,
      uid: uid,
      userExists: userExists,
      message: message,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult(success: false, message: message);
  }
}