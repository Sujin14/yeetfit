// Constants for authentication routes.
class AuthRouteConstants {
  static const String root = '/login';
  static const String signup = '/signup';
  static const String userInfoStepPrefix = '/user-info-step/';
  static const String userInfoStep = '$userInfoStepPrefix:step';

  static String userInfoStepPath(int step) => '$userInfoStepPrefix$step';
}
