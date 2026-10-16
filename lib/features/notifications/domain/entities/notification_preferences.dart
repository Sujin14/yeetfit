enum NotificationPreferenceType {
  waterReminder,
  streakAlerts,
  dailyTips,
  challengeUpdates,
  coachMessages,
  liveSessions,
}

class NotificationPreferences {
  final bool waterReminder;
  final bool streakAlerts;
  final bool dailyTips;
  final bool challengeUpdates;
  final bool coachMessages;
  final bool liveSessions;

  const NotificationPreferences({
    this.waterReminder = true,
    this.streakAlerts = true,
    this.dailyTips = true,
    this.challengeUpdates = true,
    this.coachMessages = true,
    this.liveSessions = true,
  });

  bool isEnabled(NotificationPreferenceType type) => switch (type) {
    NotificationPreferenceType.waterReminder => waterReminder,
    NotificationPreferenceType.streakAlerts => streakAlerts,
    NotificationPreferenceType.dailyTips => dailyTips,
    NotificationPreferenceType.challengeUpdates => challengeUpdates,
    NotificationPreferenceType.coachMessages => coachMessages,
    NotificationPreferenceType.liveSessions => liveSessions,
  };

  NotificationPreferences withPreference(
    NotificationPreferenceType type,
    bool enabled,
  ) => switch (type) {
    NotificationPreferenceType.waterReminder => copyWith(
      waterReminder: enabled,
    ),
    NotificationPreferenceType.streakAlerts => copyWith(streakAlerts: enabled),
    NotificationPreferenceType.dailyTips => copyWith(dailyTips: enabled),
    NotificationPreferenceType.challengeUpdates => copyWith(
      challengeUpdates: enabled,
    ),
    NotificationPreferenceType.coachMessages => copyWith(
      coachMessages: enabled,
    ),
    NotificationPreferenceType.liveSessions => copyWith(liveSessions: enabled),
  };

  NotificationPreferences copyWith({
    bool? waterReminder,
    bool? streakAlerts,
    bool? dailyTips,
    bool? challengeUpdates,
    bool? coachMessages,
    bool? liveSessions,
  }) {
    return NotificationPreferences(
      waterReminder: waterReminder ?? this.waterReminder,
      streakAlerts: streakAlerts ?? this.streakAlerts,
      dailyTips: dailyTips ?? this.dailyTips,
      challengeUpdates: challengeUpdates ?? this.challengeUpdates,
      coachMessages: coachMessages ?? this.coachMessages,
      liveSessions: liveSessions ?? this.liveSessions,
    );
  }
}
