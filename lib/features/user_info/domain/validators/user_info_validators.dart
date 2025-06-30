class UserInfoValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.trim().isEmpty) return 'Gender is required';
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) return 'Age is required';
    final age = int.tryParse(value);
    if (age == null || age < 1 || age > 150) return 'Enter a valid age';
    return null;
  }

  static String? validateGoal(String? value) {
    if (value == null || value.trim().isEmpty) return 'Goal is required';
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) return 'Weight is required';
    final weight = double.tryParse(value);
    if (weight == null || weight <= 0) return 'Enter a valid weight';
    return null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) return 'Height is required';
    final height = double.tryParse(value);
    if (height == null || height <= 0) return 'Enter a valid height';
    return null;
  }

  static String? validateActivityLevel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Activity level is required';
    }
    return null;
  }
}
