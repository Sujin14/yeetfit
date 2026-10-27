// Constants for 1-to-1 coach call routes.
class CallRouteConstants {
  static const String activeCall = '/call/:callId';
  static const String joiningCall = '/joining-call/:callId';
  static const String callSetup = '/call-setup';

  static String activeCallPath(String callId) => '/call/$callId';
  static String joiningCallPath(String callId) => '/joining-call/$callId';
}
