// Constants for 1-to-1 coach call routes.
class CallRouteConstants {
  static const String activeCall = '/call/:callId';
  static const String incomingCall = '/incoming-call/:callId';

  static String activeCallPath(String callId) => '/call/$callId';
  static String incomingCallPath(String callId) => '/incoming-call/$callId';
}
