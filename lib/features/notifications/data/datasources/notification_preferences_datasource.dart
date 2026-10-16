import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeetfit/core/constants/notification_constants.dart';
import '../../domain/entities/notification_preferences.dart';

/// Reads and writes `users/{uid}/settings/notifications`.
class NotificationPreferencesDataSource {
  final FirebaseFirestore _firestore;

  NotificationPreferencesDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _document(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection(NotificationConstants.settingsCollection)
        .doc(NotificationConstants.preferencesDocument);
  }

  static String _field(NotificationPreferenceType type) => switch (type) {
    NotificationPreferenceType.waterReminder =>
      NotificationConstants.prefWaterReminder,
    NotificationPreferenceType.streakAlerts =>
      NotificationConstants.prefStreakAlerts,
    NotificationPreferenceType.dailyTips => NotificationConstants.prefDailyTips,
    NotificationPreferenceType.challengeUpdates =>
      NotificationConstants.prefChallengeUpdates,
    NotificationPreferenceType.coachMessages =>
      NotificationConstants.prefCoachMessages,
    NotificationPreferenceType.liveSessions =>
      NotificationConstants.prefLiveSessions,
  };

  /// Missing fields default to enabled.
  Future<NotificationPreferences> getPreferences(String userId) async {
    final snapshot = await _document(userId).get();
    final data = snapshot.data() ?? const {};
    bool read(NotificationPreferenceType type) =>
        data[_field(type)] as bool? ?? true;

    return NotificationPreferences(
      waterReminder: read(NotificationPreferenceType.waterReminder),
      streakAlerts: read(NotificationPreferenceType.streakAlerts),
      dailyTips: read(NotificationPreferenceType.dailyTips),
      challengeUpdates: read(NotificationPreferenceType.challengeUpdates),
      coachMessages: read(NotificationPreferenceType.coachMessages),
      liveSessions: read(NotificationPreferenceType.liveSessions),
    );
  }

  Future<void> setPreference(
    String userId,
    NotificationPreferenceType type,
    bool enabled,
  ) {
    return _document(
      userId,
    ).set({_field(type): enabled}, SetOptions(merge: true));
  }
}
