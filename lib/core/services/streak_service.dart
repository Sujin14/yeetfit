import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeetfit/core/constants/notification_constants.dart';
import 'package:yeetfit/core/services/notification_service.dart';

/// Counts consecutive days (ending today) with at least one tracking entry
/// across steps, water, sleep and meals.
class StreakService {
  static final StreakService _instance = StreakService._();

  factory StreakService() => _instance;

  StreakService._();

  static const int _minimumStreakForAlert = 3;
  static const int _windowDays = 30;
  static const int _maxStreakDays = 365;
  static const String _lastCheckedKey = 'streak_alert_last_checked';

  static const Duration _challengeCacheTtl = Duration(minutes: 10);

  /// Joined, active challenges per `userId|metric`, so frequent step syncs
  /// don't re-query Firestore on every write.
  final Map<
    String,
    ({DateTime fetchedAt, List<({String id, double goal})> challenges})
  >
  _joinedChallengeCache = {};

  /// Last progress written per `userId|challengeId`; skips no-op writes.
  final Map<String, double> _syncedChallengeProgress = {};

  static String _dateKey(DateTime day) => day.toIso8601String().split('T')[0];

  /// Date key (`yyyy-MM-dd`) used by the tracking collections for today.
  static String todayKey() => _dateKey(DateTime.now());

  CollectionReference<Map<String, dynamic>> _progress(
    String userId,
    String metric,
  ) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(metric)
        .collection(metric);
  }

  /// Current streak length; 0 when nothing has been logged today.
  Future<int> currentStreak(String userId) async {
    final now = DateTime.now();
    var windowEnd = DateTime(now.year, now.month, now.day);
    var streak = 0;

    // Read in 30-day windows so typical streaks cost one query per metric.
    while (streak < _maxStreakDays) {
      final windowStart = DateTime(
        windowEnd.year,
        windowEnd.month,
        windowEnd.day - (_windowDays - 1),
      );
      final activeDays = await _activeDays(userId, windowStart, windowEnd);
      for (var offset = 0; offset < _windowDays; offset++) {
        final day = DateTime(
          windowEnd.year,
          windowEnd.month,
          windowEnd.day - offset,
        );
        if (!activeDays.contains(_dateKey(day))) return streak;
        streak++;
      }
      windowEnd = DateTime(
        windowStart.year,
        windowStart.month,
        windowStart.day - 1,
      );
    }
    return streak;
  }

  Future<Set<String>> _activeDays(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final startKey = _dateKey(start);
    final endKey = _dateKey(end);

    // Steps, water and sleep documents are keyed by their date.
    Future<Iterable<String>> datedDocs(String metric, String valueField) async {
      final snapshot = await _progress(userId, metric)
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: startKey)
          .where(FieldPath.documentId, isLessThanOrEqualTo: endKey)
          .get();
      return snapshot.docs
          .where((doc) => ((doc.data()[valueField] as num?) ?? 0) > 0)
          .map((doc) => doc.id);
    }

    // Meal entries have generated IDs and a `date` field.
    Future<Iterable<String>> mealDays() async {
      final snapshot = await _progress(userId, 'food')
          .where('date', isGreaterThanOrEqualTo: startKey)
          .where('date', isLessThanOrEqualTo: endKey)
          .get();
      return snapshot.docs
          .where((doc) => !doc.id.endsWith('-goal'))
          .map((doc) => doc.data()['date'] as String?)
          .whereType<String>();
    }

    final results = await Future.wait([
      datedDocs('steps', 'steps'),
      datedDocs('water', 'glassesConsumed'),
      datedDocs('sleep', 'duration'),
      mealDays(),
    ]);
    return {for (final days in results) ...days};
  }

  /// Called by tracking data sources after a successful write. Fires the
  /// streak notification at most once per day and never throws.
  Future<void> checkAfterLog(String userId) async {
    try {
      final today = _dateKey(DateTime.now());
      final marker = '$userId|$today';
      final prefs = await SharedPreferences.getInstance();
      // Today's streak can't change after its first entry, so one check a day
      // is enough; this also keeps frequent step syncs from hitting Firestore.
      if (prefs.getString(_lastCheckedKey) == marker) return;

      final notifications = NotificationService();
      if (!await notifications.isPreferenceEnabled(
        userId,
        NotificationConstants.prefStreakAlerts,
      )) {
        await prefs.setString(_lastCheckedKey, marker);
        return;
      }

      final streak = await currentStreak(userId);
      if (streak == 0) return;
      await prefs.setString(_lastCheckedKey, marker);
      if (streak >= _minimumStreakForAlert) {
        await notifications.showStreakNotification(streak);
      }
    } catch (e) {
      debugPrint('Streak check failed: $e');
    }
  }

  /// Writes [newValue] (today's total for [metric]) to every active
  /// challenge for that metric the user has joined, marking it completed
  /// once the goal is reached. Called after successful tracking writes;
  /// never throws.
  Future<void> updateChallengeProgress(
    String userId,
    String metric,
    double newValue,
  ) async {
    try {
      final challenges = await _joinedActiveChallenges(userId, metric);
      for (final challenge in challenges) {
        final syncKey = '$userId|${challenge.id}';
        if (_syncedChallengeProgress[syncKey] == newValue) continue;

        // Each user only writes their own participant doc, so a plain update
        // is enough; `completed` is never reset once earned.
        await FirebaseFirestore.instance
            .collection('challenges')
            .doc(challenge.id)
            .collection('participants')
            .doc(userId)
            .update({
              'currentProgress': newValue,
              if (newValue >= challenge.goal) 'completed': true,
            });
        _syncedChallengeProgress[syncKey] = newValue;
      }
    } catch (e) {
      debugPrint('Challenge progress update failed: $e');
    }
  }

  /// Call after joining or leaving a challenge so the next update sees it.
  void invalidateChallengeCache(String userId) {
    _joinedChallengeCache.removeWhere((key, _) => key.startsWith('$userId|'));
    _syncedChallengeProgress.removeWhere(
      (key, _) => key.startsWith('$userId|'),
    );
  }

  Future<List<({String id, double goal})>> _joinedActiveChallenges(
    String userId,
    String metric,
  ) async {
    final cacheKey = '$userId|$metric';
    final now = DateTime.now();
    final cached = _joinedChallengeCache[cacheKey];
    if (cached != null &&
        now.difference(cached.fetchedAt) < _challengeCacheTtl) {
      return cached.challenges;
    }

    final firestore = FirebaseFirestore.instance;
    // Equality-only query avoids a composite index; the handful of
    // challenges per metric is date-filtered here.
    final snapshot = await firestore
        .collection('challenges')
        .where('metric', isEqualTo: metric)
        .get();
    final active = snapshot.docs.where((doc) {
      final start = doc.data()['startDate'];
      final end = doc.data()['endDate'];
      return start is Timestamp &&
          end is Timestamp &&
          !start.toDate().isAfter(now) &&
          !end.toDate().isBefore(now);
    });

    final memberships = await Future.wait(
      active.map((doc) async {
        final participant = await doc.reference
            .collection('participants')
            .doc(userId)
            .get();
        if (!participant.exists) return null;
        return (
          id: doc.id,
          goal: (doc.data()['goal'] as num?)?.toDouble() ?? double.infinity,
        );
      }),
    );
    final joined = memberships.nonNulls.toList();
    _joinedChallengeCache[cacheKey] = (fetchedAt: now, challenges: joined);
    return joined;
  }
}
