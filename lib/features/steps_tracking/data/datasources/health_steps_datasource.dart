import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Step counts from Health Connect (Android) or HealthKit (iOS).
class HealthStepsDataSource {
  static const _types = [HealthDataType.STEPS];
  static const _promptedKey = 'health_connect_steps_prompted';

  final Health _health;
  Future<void>? _configured;

  HealthStepsDataSource({Health? health}) : _health = health ?? Health();

  bool get _isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Always true on iOS; on Android, whether Health Connect is installed.
  Future<bool> _isAvailable() async {
    if (!_isSupported) return false;
    await (_configured ??= _health.configure());
    return _health.isHealthConnectAvailable();
  }

  /// Shows the permission screen automatically once per install; after that
  /// only [requestAccess] (a user action) asks again.
  Future<void> requestAccessOnce() async {
    if (!await _isAvailable()) return;
    if (await _health.hasPermissions(_types) == true) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_promptedKey) ?? false) return;
    await prefs.setBool(_promptedKey, true);
    await _health.requestAuthorization(_types);
  }

  /// Opens the permission screen, or the store listing when Health Connect
  /// isn't installed.
  Future<void> requestAccess() async {
    if (!_isSupported) return;
    if (!await _isAvailable()) {
      await _health.installHealthConnect();
      return;
    }
    await _health.requestAuthorization(_types);
  }

  /// Steps in [start]–[end], or null when the health store is missing or
  /// access was denied. HealthKit never reveals read access (`null`), so on
  /// iOS a denial reads as 0 steps.
  Future<int?> getSteps(DateTime start, DateTime end) async {
    if (!await _isAvailable()) return null;
    if (await _health.hasPermissions(_types) == false) return null;
    return await _health.getTotalStepsInInterval(start, end) ?? 0;
  }
}
