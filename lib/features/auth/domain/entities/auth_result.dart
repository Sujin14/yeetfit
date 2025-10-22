// Represents the result of an authentication operation.
class AuthResult {
  final bool success;
  final String? message; // User-friendly message (error or success)
  final String? uid; // UID if successful
  final bool? userExists; // Whether user profile exists (for post-auth checks)

  const AuthResult({
    required this.success,
    this.message,
    this.uid,
    this.userExists,
  });

  // Creates a successful result.
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

  // Creates a failure result with a predefined error message.
  factory AuthResult.failure(String message) {
    return AuthResult(success: false, message: message);
  }
}