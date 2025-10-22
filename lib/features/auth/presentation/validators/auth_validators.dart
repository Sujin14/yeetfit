// Utility class for authentication-related validations.
class AuthValidators {
  // Validates email format.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email format';
    }
    return null;
  }

  // Validates password strength.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Minimum 8 characters';
    
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'At least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'At least one lowercase letter';
    }
    
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'At least one special character (e.g., !@#\$%)';
    }
    
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'At least one number';
    }
    
    return null;
  }

  // Validates password confirmation.
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirm Password';
    if (value.length < 8) return 'Minimum 8 characters';
    if (value != password) return 'Passwords do not match';
    return null;
  }
}