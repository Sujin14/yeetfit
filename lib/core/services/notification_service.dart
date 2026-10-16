import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'package:yeetfit/core/constants/function_regions.dart';
import 'package:yeetfit/core/constants/notification_constants.dart';
import 'package:yeetfit/firebase_options.dart';

/// FCM entry point for messages received while the app is in the background
/// or terminated. Registered in `main()` before `Firebase.initializeApp()`.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Notification messages are displayed by FCM itself on Android/iOS while
  // the app is backgrounded. An incoming call is also remembered, so opening
  // the app from the launcher (not the notification) still shows it.
  if (message.data['type'] == NotificationConstants.typeIncomingCall) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      NotificationConstants.pendingCallIdKey,
      message.data['callId'] as String? ?? '',
    );
  }
}

/// A tapped coach chat push: the chat it belongs to and the coach who sent it.
typedef ChatNotificationTap = ({String chatId, String senderId});

/// A tapped challenge assignment push; [challengeId] is null when the push
/// doesn't name one.
typedef ChallengeNotificationTap = ({String? challengeId});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Push (FCM) and local notifications.
///
/// A single instance is shared per isolate so the main app, data sources and
/// Workmanager background tasks reuse one initialised plugin.
class NotificationService {
  static final NotificationService _instance = NotificationService._();

  factory NotificationService() => _instance;

  NotificationService._();

  static const String _waterReminderShownKey = 'water_reminder_last_shown';
  static const int _waterReminderNotificationId = 1001;
  static const int _streakNotificationId = 1002;
  static const String _sessionReminderPayloadPrefix = 'session:';
  static const Duration sessionReminderLeadTime = Duration(minutes: 15);
  static const String _notifyNewSessionFunction = 'notifyNewSession';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void>? _localNotificationsInit;
  Future<void>? _timezoneInit;
  Future<RemoteMessage?>? _launchMessage;
  Future<Map<String, dynamic>?>? _localLaunchData;
  final StreamController<ChatNotificationTap> _localChatTaps =
      StreamController<ChatNotificationTap>.broadcast();
  final StreamController<ChallengeNotificationTap> _localChallengeTaps =
      StreamController<ChallengeNotificationTap>.broadcast();
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _preferencesSubscription;
  Map<String, dynamic> _preferences = const {};

  static bool get _isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Call after sign-in. Safe to call again for another account.
  Future<void> init(String userId) async {
    if (!_isSupportedPlatform) return;
    await _initLocalNotifications();
    await _requestPermission();
    await _saveFcmToken(userId);
    _setupForegroundHandler();
    _watchPreferences(userId);
    final preferences = await _readPreferences(userId);
    bool enabled(String key) => preferences[key] as bool? ?? true;

    await _syncTopics(
      dailyTips: enabled(NotificationConstants.prefDailyTips),
      challenges: enabled(NotificationConstants.prefChallengeUpdates),
      sessions: enabled(NotificationConstants.prefLiveSessions),
    );
    if (enabled(NotificationConstants.prefWaterReminder)) {
      await scheduleWaterReminderCheck(userId);
    } else {
      await cancelWaterReminderCheck();
    }
  }

  /// Call before `FirebaseAuth.signOut()` so this device stops receiving
  /// [userId]'s pushes. Never throws: sign-out must not be blocked.
  Future<void> onSignOut(String userId) async {
    if (!_isSupportedPlatform) return;
    // Stop the refresh listener first so a new token isn't written back.
    await stopUserSession();
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
      });
    } catch (e) {
      debugPrint('Removing FCM token from profile failed: $e');
    }
    await _deleteDeviceToken();
  }

  /// Local-only cleanup once the account is deleted server-side: the profile
  /// document is gone, so unlike [onSignOut] nothing is written to it.
  Future<void> onAccountDeleted() async {
    if (!_isSupportedPlatform) return;
    await stopUserSession();
    await _deleteDeviceToken();
  }

  Future<void> _deleteDeviceToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      debugPrint('Deleting FCM token failed: $e');
    }
  }

  /// Stops per-user listeners and background checks. Idempotent; also runs
  /// when the session ends without [onSignOut] (e.g. revoked credentials).
  Future<void> stopUserSession() async {
    if (!_isSupportedPlatform) return;
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    await _preferencesSubscription?.cancel();
    _preferencesSubscription = null;
    _preferences = const {};
    await cancelWaterReminderCheck();
  }

  Future<void> _initLocalNotifications() {
    return _localNotificationsInit ??= () async {
      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      );
      await _localNotifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onLocalNotificationTapped,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              NotificationConstants.channelId,
              NotificationConstants.channelName,
              importance: Importance.high,
              enableVibration: true,
            ),
          );
    }();
  }

  Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _saveFcmToken(String userId) async {
    Future<void> write(String token) => FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'fcmToken': token}, SetOptions(merge: true));

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await write(token);
    } catch (e) {
      // iOS returns no token until APNs registration completes (and never on
      // simulators); onTokenRefresh delivers it later.
      debugPrint('FCM token unavailable: $e');
    }

    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
        .listen(
          (token) => write(token).catchError(
            (Object e) => debugPrint('FCM token refresh save failed: $e'),
          ),
        );
  }

  void _setupForegroundHandler() {
    _foregroundSubscription ??= FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      // In the foreground the in-app incoming call screen is already ringing.
      if (message.data['type'] == NotificationConstants.typeIncomingCall) {
        return;
      }
      if (_isMutedByPreferences(message)) return;
      _showLocalNotification(message);
    });
  }

  void _watchPreferences(String userId) {
    _preferencesSubscription?.cancel();
    _preferencesSubscription = _preferencesDocument(userId).snapshots().listen(
      (snapshot) => _preferences = snapshot.data() ?? const {},
      onError: (Object e) => debugPrint('Notification prefs listen failed: $e'),
    );
  }

  /// Server-sent messages carry a `type` in their data payload; topic
  /// messages are identified by their sender.
  bool _isMutedByPreferences(RemoteMessage message) {
    final preferenceKey = switch (message.data['type']) {
      NotificationConstants.typeChatMessage =>
        NotificationConstants.prefCoachMessages,
      NotificationConstants.typeWaterReminder =>
        NotificationConstants.prefWaterReminder,
      NotificationConstants.typeStreakAlert =>
        NotificationConstants.prefStreakAlerts,
      NotificationConstants.typeChallengeUpdate ||
      NotificationConstants.typeChallengeAssigned =>
        NotificationConstants.prefChallengeUpdates,
      NotificationConstants.typeNewSession =>
        NotificationConstants.prefLiveSessions,
      _ =>
        message.from == '/topics/${NotificationConstants.topicDailyTips}'
            ? NotificationConstants.prefDailyTips
            : null,
    };
    return preferenceKey != null && _preferences[preferenceKey] == false;
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _show(
      // Plugin IDs must fit in a signed 32-bit int.
      id: notification.hashCode & 0x7fffffff,
      title: notification.title,
      body: notification.body,
      payload: jsonEncode(message.data),
    );
  }

  Future<void> _show({
    required int id,
    required String? title,
    required String? body,
    String? payload,
  }) async {
    await _initLocalNotifications();
    await _localNotifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationConstants.channelId,
          NotificationConstants.channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  Future<void> subscribeToTopic(String topic) =>
      FirebaseMessaging.instance.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      FirebaseMessaging.instance.unsubscribeFromTopic(topic);

  /// Topic subscriptions belong to the FCM token, which [onSignOut] deletes,
  /// so they are re-applied from the user's preferences on every sign-in.
  /// All default to subscribed for new users.
  Future<void> _syncTopics({
    required bool dailyTips,
    required bool challenges,
    required bool sessions,
  }) async {
    Future<void> apply(String topic, bool subscribe) =>
        subscribe ? subscribeToTopic(topic) : unsubscribeFromTopic(topic);
    try {
      await apply(NotificationConstants.topicDailyTips, dailyTips);
      await apply(NotificationConstants.topicChallenges, challenges);
      await apply(NotificationConstants.topicSessions, sessions);
    } catch (e) {
      // iOS rejects topic calls until the APNs token exists; retried next init.
      debugPrint('Topic sync deferred: $e');
    }
  }

  DocumentReference<Map<String, dynamic>> _preferencesDocument(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(NotificationConstants.settingsCollection)
        .doc(NotificationConstants.preferencesDocument);
  }

  /// One-off read for contexts without a live listener (background isolates,
  /// data sources). Missing preferences default to enabled.
  Future<bool> isPreferenceEnabled(String userId, String preferenceKey) async {
    final preferences = await _readPreferences(userId);
    return preferences[preferenceKey] as bool? ?? true;
  }

  Future<Map<String, dynamic>> _readPreferences(String userId) async {
    try {
      final snapshot = await _preferencesDocument(userId).get();
      return snapshot.data() ?? const {};
    } catch (_) {
      return const {};
    }
  }

  // Water reminder

  Future<void> scheduleWaterReminderCheck(String userId) async {
    if (!_isSupportedPlatform) return;
    await Workmanager().registerPeriodicTask(
      NotificationConstants.waterReminderTask,
      NotificationConstants.waterReminderTask,
      frequency: const Duration(hours: 1),
      inputData: {'userId': userId},
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  Future<void> cancelWaterReminderCheck() async {
    if (!_isSupportedPlatform) return;
    await Workmanager().cancelByUniqueName(
      NotificationConstants.waterReminderTask,
    );
  }

  /// Workmanager task body: reminds at most once per day, from 11:00, when no
  /// water has been logged today.
  Future<bool> runWaterReminderCheck(String userId) async {
    final now = DateTime.now();
    if (now.hour < 11) return true;

    final today = now.toIso8601String().split('T')[0];
    final prefs = await SharedPreferences.getInstance();
    final shownMarker = '$userId|$today';
    if (prefs.getString(_waterReminderShownKey) == shownMarker) return true;

    if (!await isPreferenceEnabled(
      userId,
      NotificationConstants.prefWaterReminder,
    )) {
      return true;
    }

    final waterDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('water')
        .collection('water')
        .doc(today)
        .get();
    final glassesConsumed =
        (waterDoc.data()?['glassesConsumed'] as num?)?.toInt() ?? 0;
    if (glassesConsumed > 0) return true;

    await _show(
      id: _waterReminderNotificationId,
      title: 'Stay hydrated 💧',
      body: "You haven't logged any water today. Time to drink up!",
    );
    await prefs.setString(_waterReminderShownKey, shownMarker);
    return true;
  }

  // Streak alert

  Future<void> showStreakNotification(int streak) {
    return _show(
      id: _streakNotificationId,
      title: '🔥 $streak-day streak!',
      body: "Keep it going — you're on a roll.",
    );
  }

  // Incoming calls

  /// Call ids from incoming call notifications tapped while the app was in
  /// the background.
  Stream<String> get openedIncomingCalls => FirebaseMessaging.onMessageOpenedApp
      .map(_incomingCallId)
      .where((callId) => callId != null)
      .cast<String>();

  /// The call that launched the app from a notification tap, or else one
  /// the background handler remembered. Either is consumed by this call.
  Future<String?> takePendingIncomingCallId() async {
    if (!_isSupportedPlatform) return null;
    final callId = _incomingCallId(
      await _takeLaunchMessage(NotificationConstants.typeIncomingCall),
    );

    final prefs = await SharedPreferences.getInstance();
    // The background handler writes from another isolate.
    await prefs.reload();
    final stored = prefs.getString(NotificationConstants.pendingCallIdKey);
    if (stored != null) {
      await prefs.remove(NotificationConstants.pendingCallIdKey);
    }
    if (callId != null) return callId;
    return stored == null || stored.isEmpty ? null : stored;
  }

  /// Removes the ringing push from the Android tray once the call screen
  /// handles it. FCM posts it with notification id 0 and the call's tag.
  Future<void> dismissIncomingCallNotification(String callId) async {
    if (!_isSupportedPlatform || !Platform.isAndroid) return;
    try {
      await _initLocalNotifications();
      await _localNotifications.cancel(
        0,
        tag: NotificationConstants.incomingCallTag(callId),
      );
    } catch (e) {
      debugPrint('Dismissing call notification failed: $e');
    }
  }

  static String? _incomingCallId(RemoteMessage? message) {
    if (message?.data['type'] != NotificationConstants.typeIncomingCall) {
      return null;
    }
    final callId = message!.data['callId'] as String?;
    return callId == null || callId.isEmpty ? null : callId;
  }

  // Coach chat messages

  /// Coach chat pushes tapped while the app was in the background.
  Stream<ChatNotificationTap> get openedChatMessages => FirebaseMessaging
      .onMessageOpenedApp
      .map(_chatNotificationTap)
      .where((tap) => tap != null)
      .cast<ChatNotificationTap>();

  /// The coach chat notification that launched the app, if any: an FCM push,
  /// or a foreground one left in the tray. Consumed by this call.
  Future<ChatNotificationTap?> takePendingChatNotification() async {
    if (!_isSupportedPlatform) return null;
    const type = NotificationConstants.typeChatMessage;
    return _chatTapFromData((await _takeLaunchMessage(type))?.data) ??
        _chatTapFromData(await _takeLocalLaunchData(type));
  }

  /// Coach chat pushes shown as local notifications in the foreground, then
  /// tapped.
  Stream<ChatNotificationTap> get tappedLocalChatMessages =>
      _localChatTaps.stream;

  static ChatNotificationTap? _chatNotificationTap(RemoteMessage? message) =>
      _chatTapFromData(message?.data);

  static ChatNotificationTap? _chatTapFromData(Map<String, dynamic>? data) {
    if (data?['type'] != NotificationConstants.typeChatMessage) return null;
    final chatId = data!['chatId'];
    final senderId = data['senderId'];
    if (chatId is! String || chatId.isEmpty) return null;
    if (senderId is! String || senderId.isEmpty) return null;
    return (chatId: chatId, senderId: senderId);
  }

  // Assigned challenges

  /// Challenge assignment pushes tapped while the app was in the background.
  Stream<ChallengeNotificationTap> get openedChallengeAssignments =>
      FirebaseMessaging.onMessageOpenedApp
          .map((message) => _challengeTapFromData(message.data))
          .where((tap) => tap != null)
          .cast<ChallengeNotificationTap>();

  /// Challenge assignment pushes shown as local notifications in the
  /// foreground, then tapped.
  Stream<ChallengeNotificationTap> get tappedLocalChallengeAssignments =>
      _localChallengeTaps.stream;

  /// The challenge assignment notification that launched the app, if any.
  /// Consumed by this call.
  Future<ChallengeNotificationTap?> takePendingChallengeNotification() async {
    if (!_isSupportedPlatform) return null;
    const type = NotificationConstants.typeChallengeAssigned;
    return _challengeTapFromData((await _takeLaunchMessage(type))?.data) ??
        _challengeTapFromData(await _takeLocalLaunchData(type));
  }

  static ChallengeNotificationTap? _challengeTapFromData(
    Map<String, dynamic>? data,
  ) {
    if (data?['type'] != NotificationConstants.typeChallengeAssigned) {
      return null;
    }
    final challengeId = data!['challengeId'];
    return (
      challengeId: challengeId is String && challengeId.isNotEmpty
          ? challengeId
          : null,
    );
  }

  // Local notification taps

  void _onLocalNotificationTapped(NotificationResponse response) {
    final data = _payloadData(response.payload);
    final chatTap = _chatTapFromData(data);
    if (chatTap != null) _localChatTaps.add(chatTap);
    final challengeTap = _challengeTapFromData(data);
    if (challengeTap != null) _localChallengeTaps.add(challengeTap);
  }

  /// Foreground pushes carry their FCM data as a JSON payload; other local
  /// notifications (e.g. session reminders) use plain-text payloads.
  static Map<String, dynamic>? _payloadData(String? payload) {
    if (payload == null || !payload.startsWith('{')) return null;
    try {
      final data = jsonDecode(payload);
      return data is Map<String, dynamic> ? data : null;
    } on FormatException catch (e) {
      debugPrint('Unreadable notification payload: $e');
      return null;
    }
  }

  // Launch notification

  /// getInitialMessage() yields the launch message only once, so it is read
  /// once and handed to whichever caller handles its [type].
  Future<RemoteMessage?> _takeLaunchMessage(String type) async {
    final message = await (_launchMessage ??= _readInitialMessage());
    if (message?.data['type'] != type) return null;
    _launchMessage = Future.value();
    return message;
  }

  /// A local notification that launches the app never reaches
  /// onDidReceiveNotificationResponse; like [_takeLaunchMessage], its data
  /// goes to whichever caller handles its [type].
  Future<Map<String, dynamic>?> _takeLocalLaunchData(String type) async {
    final data = await (_localLaunchData ??= _readLocalLaunchData());
    if (data?['type'] != type) return null;
    _localLaunchData = Future.value();
    return data;
  }

  Future<Map<String, dynamic>?> _readLocalLaunchData() async {
    try {
      // Readable before initialize(), which would prompt for permission on iOS.
      final launchDetails = await _localNotifications
          .getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp != true) return null;
      return _payloadData(launchDetails!.notificationResponse?.payload);
    } catch (e) {
      debugPrint('Reading local launch notification failed: $e');
      return null;
    }
  }

  static Future<RemoteMessage?> _readInitialMessage() async {
    try {
      return await FirebaseMessaging.instance.getInitialMessage();
    } catch (e) {
      debugPrint('Reading launch notification failed: $e');
      return null;
    }
  }

  // Group training sessions

  /// Pushes the new session to every device subscribed to the sessions
  /// topic. The Cloud Function checks that the caller is a coach.
  Future<void> notifyNewSession(String sessionId) async {
    await FirebaseFunctions.instanceFor(region: FunctionRegions.general)
        .httpsCallable(_notifyNewSessionFunction)
        .call<void>({'sessionId': sessionId});
  }

  /// Schedules a local reminder [sessionReminderLeadTime] before [startsAt].
  /// Returns false when that moment has already passed.
  Future<bool> scheduleSessionReminder({
    required String sessionId,
    required String title,
    required DateTime startsAt,
  }) async {
    if (!_isSupportedPlatform) return false;
    final remindAt = startsAt.subtract(sessionReminderLeadTime);
    if (!remindAt.isAfter(DateTime.now())) return false;

    await _initLocalNotifications();
    await _initTimezone();
    await _localNotifications.zonedSchedule(
      _sessionReminderId(sessionId),
      'Starting in 15 minutes 🔴',
      '$title — open Explore to join.',
      tz.TZDateTime.from(remindAt, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationConstants.channelId,
          NotificationConstants.channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // Inexact avoids the SCHEDULE_EXACT_ALARM permission; Android may
      // deliver it a few minutes late in Doze.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '$_sessionReminderPayloadPrefix$sessionId',
    );
    return true;
  }

  /// Ids of sessions with a reminder still pending on this device.
  Future<Set<String>> pendingSessionReminderIds() async {
    if (!_isSupportedPlatform) return const {};
    await _initLocalNotifications();
    final pending = await _localNotifications.pendingNotificationRequests();
    return {
      for (final request in pending)
        if (request.payload?.startsWith(_sessionReminderPayloadPrefix) ?? false)
          request.payload!.substring(_sessionReminderPayloadPrefix.length),
    };
  }

  Future<void> _initTimezone() {
    return _timezoneInit ??= () async {
      tz_data.initializeTimeZones();
      try {
        final timezone = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timezone.identifier));
      } catch (e) {
        // tz.local stays UTC; TZDateTime.from still converts the instant
        // correctly, so the reminder fires at the right moment.
        debugPrint('Local timezone lookup failed: $e');
      }
    }();
  }

  /// Stable across app restarts (unlike String.hashCode, which isn't
  /// guaranteed to be), so a reminder can be found again by session id.
  static int _sessionReminderId(String sessionId) {
    var hash = 0x811c9dc5;
    for (final unit in sessionId.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
    }
    return hash & 0x7fffffff;
  }
}
