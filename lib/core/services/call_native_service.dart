import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Snapshot of Android call-permission readiness from native [CallReadiness].
class CallReadiness {
  final bool notificationsEnabled;
  final bool channelOk;
  final bool fullScreenOk;
  final bool batteryOk;
  final bool needsOemSetup;
  final String manufacturer;
  final String oemInstructions;

  const CallReadiness({
    required this.notificationsEnabled,
    required this.channelOk,
    required this.fullScreenOk,
    required this.batteryOk,
    required this.needsOemSetup,
    required this.manufacturer,
    required this.oemInstructions,
  });

  factory CallReadiness.fromMap(Map<Object?, Object?> map) {
    bool asBool(Object? v) => v == true;
    return CallReadiness(
      notificationsEnabled: asBool(map['notificationsEnabled']),
      channelOk: asBool(map['channelOk']),
      fullScreenOk: asBool(map['fullScreenOk']),
      batteryOk: asBool(map['batteryOk']),
      needsOemSetup: asBool(map['needsOemSetup']),
      manufacturer: map['manufacturer']?.toString() ?? '',
      oemInstructions: map['oemInstructions']?.toString() ?? '',
    );
  }

  bool get coreOk =>
      notificationsEnabled && channelOk && fullScreenOk && batteryOk;
}

/// Dart bridge to YeetFit's native incoming-call UI
/// ([CallNotificationManager] / [MainActivity] MethodChannel).
class CallNativeService {
  static const MethodChannel _call = MethodChannel('com.yeetfit/call');
  static const MethodChannel _permissions = MethodChannel(
    'com.yeetfit/permissions',
  );

  static const String prefsCallSetupCompleted = 'call_setup_completed';
  static const String prefsCallSetupTestPassed = 'call_setup_test_passed';

  static Future<String?> consumePendingAcceptedCall() async {
    try {
      final id = await _call.invokeMethod<String>('consumePendingAcceptedCall');
      debugPrint('[YeetCall] consumePendingAcceptedCall: $id');
      return id;
    } catch (e) {
      debugPrint('[YeetCall] consumePendingAcceptedCall error: $e');
      return null;
    }
  }

  static Future<void> dismissIncomingCall(String? callId) async {
    try {
      await _call.invokeMethod<void>('dismissIncomingCall', callId);
      debugPrint('[YeetCall] dismissIncomingCall: $callId');
    } catch (e) {
      debugPrint('[YeetCall] dismissIncomingCall error: $e');
    }
  }

  static Future<String?> getActiveRingingCallId() async {
    try {
      final id = await _call.invokeMethod<String>('getActiveRingingCallId');
      debugPrint('[YeetCall] getActiveRingingCallId: $id');
      return id;
    } catch (e) {
      debugPrint('[YeetCall] getActiveRingingCallId error: $e');
      return null;
    }
  }

  static Future<void> clearLockScreenFlags() async {
    try {
      await _call.invokeMethod<void>('clearLockScreenFlags');
      debugPrint('[YeetCall] clearLockScreenFlags');
    } catch (e) {
      debugPrint('[YeetCall] clearLockScreenFlags error: $e');
    }
  }

  /// Warm-path accept from native. Always claims the id via
  /// [consumePendingAcceptedCall] so accepts are never handled twice.
  static void setOnCallAccepted(Future<void> Function(String callId) handler) {
    _call.setMethodCallHandler((call) async {
      if (call.method != 'callAccepted') return;
      final id = await consumePendingAcceptedCall();
      if (id == null) {
        debugPrint('[YeetCall] callAccepted with no pending id — ignored');
        return;
      }
      debugPrint('[YeetCall] callAccepted handler for $id');
      await handler(id);
    });
  }

  static Future<CallReadiness?> getCallReadiness() async {
    try {
      final raw = await _call.invokeMethod<Map<Object?, Object?>>(
        'getCallReadiness',
      );
      if (raw == null) {
        debugPrint('[YeetCall] getCallReadiness: null');
        return null;
      }
      final readiness = CallReadiness.fromMap(raw);
      debugPrint(
        '[YeetCall] getCallReadiness: coreOk=${readiness.coreOk} '
        'oem=${readiness.needsOemSetup}',
      );
      return readiness;
    } catch (e) {
      debugPrint('[YeetCall] getCallReadiness error: $e');
      return null;
    }
  }

  static Future<bool> openCallSetting(String which) async {
    try {
      final opened = await _call.invokeMethod<bool>('openCallSetting', which);
      debugPrint('[YeetCall] openCallSetting($which): $opened');
      return opened ?? false;
    } catch (e) {
      debugPrint('[YeetCall] openCallSetting($which) error: $e');
      return false;
    }
  }

  static Future<void> scheduleTestCall({int delayMs = 10000}) async {
    try {
      await _call.invokeMethod<void>('scheduleTestCall', delayMs);
      debugPrint('[YeetCall] scheduleTestCall delayMs=$delayMs');
    } catch (e) {
      debugPrint('[YeetCall] scheduleTestCall error: $e');
    }
  }

  static Future<bool> canUseFullScreenIntent() async {
    try {
      final result = await _permissions.invokeMethod<bool>(
        'canUseFullScreenIntent',
      );
      debugPrint('[YeetCall] canUseFullScreenIntent: $result');
      return result ?? true;
    } catch (e) {
      debugPrint('[YeetCall] canUseFullScreenIntent error: $e');
      return true;
    }
  }

  static Future<void> requestFullScreenIntentPermission() async {
    try {
      await _permissions.invokeMethod<void>('requestFullScreenIntent');
      debugPrint('[YeetCall] Opened full-screen intent settings');
    } catch (e) {
      debugPrint('[YeetCall] requestFullScreenIntent error: $e');
    }
  }
}
