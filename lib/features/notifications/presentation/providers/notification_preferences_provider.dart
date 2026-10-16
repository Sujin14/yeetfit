import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/constants/notification_constants.dart';
import 'package:yeetfit/core/services/notification_service.dart';
import '../../data/datasources/notification_preferences_datasource.dart';
import '../../domain/entities/notification_preferences.dart';

final notificationPreferencesDataSourceProvider =
    Provider<NotificationPreferencesDataSource>(
      (ref) => NotificationPreferencesDataSource(),
    );

final notificationPreferencesControllerProvider = AsyncNotifierProvider
    .autoDispose
    .family<NotificationPreferencesController, NotificationPreferences, String>(
      NotificationPreferencesController.new,
    );

class NotificationPreferencesController
    extends AsyncNotifier<NotificationPreferences> {
  final String userId;
  late NotificationPreferencesDataSource _dataSource;
  late NotificationService _notificationService;

  NotificationPreferencesController(this.userId);

  @override
  Future<NotificationPreferences> build() {
    _dataSource = ref.read(notificationPreferencesDataSourceProvider);
    _notificationService = ref.read(notificationServiceProvider);
    return _dataSource.getPreferences(userId);
  }

  Future<void> load() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => _dataSource.getPreferences(userId),
    );
    if (ref.mounted) state = result;
  }

  /// Applies the change optimistically. Returns an error message when the
  /// preference could not be saved (the switch is reverted).
  Future<String?> toggle(NotificationPreferenceType type, bool enabled) async {
    final previous = state.value;
    if (previous == null) return null;
    state = AsyncData(previous.withPreference(type, enabled));

    try {
      await _dataSource.setPreference(userId, type, enabled);
    } catch (e) {
      if (ref.mounted) state = AsyncData(previous);
      return 'Could not update notification settings. Please try again.';
    }

    await _applySideEffects(type, enabled);
    return null;
  }

  /// Device-side effects of a saved preference. Failures here don't undo the
  /// saved preference; the next app start re-applies the water reminder.
  Future<void> _applySideEffects(
    NotificationPreferenceType type,
    bool enabled,
  ) async {
    try {
      switch (type) {
        case NotificationPreferenceType.waterReminder:
          enabled
              ? await _notificationService.scheduleWaterReminderCheck(userId)
              : await _notificationService.cancelWaterReminderCheck();
        case NotificationPreferenceType.dailyTips:
          await _setTopic(NotificationConstants.topicDailyTips, enabled);
        case NotificationPreferenceType.challengeUpdates:
          await _setTopic(NotificationConstants.topicChallenges, enabled);
        case NotificationPreferenceType.liveSessions:
          await _setTopic(NotificationConstants.topicSessions, enabled);
        case NotificationPreferenceType.streakAlerts:
        case NotificationPreferenceType.coachMessages:
          // Read at delivery time by StreakService / the foreground handler.
          break;
      }
    } catch (e) {
      debugPrint('Applying notification preference $type failed: $e');
    }
  }

  Future<void> _setTopic(String topic, bool subscribe) {
    return subscribe
        ? _notificationService.subscribeToTopic(topic)
        : _notificationService.unsubscribeFromTopic(topic);
  }
}
