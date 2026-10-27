class NotificationConstants {
  static const String waterReminderTask = 'water_reminder_check';
  static const String channelId = 'yeetfit_channel';
  static const String channelName = 'Yeetfit Notifications';
  static const String callChannelId = 'yeetfit_calls';
  static const String callChannelName = 'Incoming calls';
  static const int incomingCallNotificationId = 2002;
  static const String topicDailyTips = 'daily_tips';
  static const String topicChallenges = 'challenges';
  static const String topicSessions = 'sessions';

  // Firestore: users/{uid}/settings/notifications
  static const String settingsCollection = 'settings';
  static const String preferencesDocument = 'notifications';
  static const String prefWaterReminder = 'waterReminder';
  static const String prefStreakAlerts = 'streakAlerts';
  static const String prefDailyTips = 'dailyTips';
  static const String prefChallengeUpdates = 'challengeUpdates';
  static const String prefCoachMessages = 'coachMessages';
  static const String prefLiveSessions = 'liveSessions';

  // FCM data payload `type` values.
  static const String typeChatMessage = 'chat_message';
  static const String typeWorkoutReminder = 'workout_reminder';
  static const String typeWaterReminder = 'water_reminder';
  static const String typeStreakAlert = 'streak_alert';
  static const String typeChallengeUpdate = 'challenge_update';
  static const String typeChallengeAssigned = 'challenge_assigned';
  static const String typeNewSession = 'new_session';
  static const String typeIncomingCall = 'incoming_call';

  // SharedPreferences key written by the background message handler.
  static const String pendingCallIdKey = 'pending_call_id';

  // Android tag on incoming call pushes (functions/index.js), used to
  // dismiss the tray notification once the call is handled in the app.
  static String incomingCallTag(String callId) => 'call_$callId';
}
