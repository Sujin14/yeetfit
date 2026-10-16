import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:yeetfit/features/workout_log/domain/entities/workout_log.dart';
import '../../domain/entities/recovery_inputs.dart';
import '../../domain/entities/recovery_score.dart';

class RecoveryDataSource {
  static const int _historyWindowDays = 30;
  static const double _defaultSleepGoalHours = 8;
  static const int _defaultWaterGoalGlasses = 8;
  static const int _defaultStepsGoal = 8000;

  final FirebaseFirestore _firestore;

  RecoveryDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _user(String userId) =>
      _firestore.collection('users').doc(userId);

  CollectionReference<Map<String, dynamic>> _progress(
    String userId,
    String metric,
  ) => _user(userId).collection('progress').doc(metric).collection(metric);

  DocumentReference<Map<String, dynamic>> _recoveryDoc(
    String userId,
    String date,
  ) => _user(userId).collection('recovery').doc(date);

  /// Reads the day's sleep, water and steps entries; [workout] is the day's
  /// logged workout. Steps count as untracked when the day has no steps
  /// document at all.
  Future<RecoveryInputs> getInputs(
    String userId,
    String date, {
    required WorkoutLog? workout,
  }) async {
    final results = await Future.wait([
      _progress(userId, 'sleep').doc(date).get(),
      _progress(userId, 'water').doc(date).get(),
      _progress(userId, 'steps').doc(date).get(),
    ]);

    num? read(int index, String field) => results[index].data()?[field] as num?;
    final stepsDoc = results[2];

    return RecoveryInputs(
      hoursSlept: read(0, 'duration')?.toDouble() ?? 0,
      sleepGoal: read(0, 'goalHours')?.toDouble() ?? _defaultSleepGoalHours,
      glassesConsumed: read(1, 'glassesConsumed')?.toInt() ?? 0,
      waterGoal: read(1, 'goalGlasses')?.toInt() ?? _defaultWaterGoalGlasses,
      stepsToday: stepsDoc.exists ? read(2, 'steps')?.toInt() ?? 0 : null,
      stepsGoal: read(2, 'goalSteps')?.toInt() ?? _defaultStepsGoal,
      workout: workout,
    );
  }

  /// Distinct days (up to [date], within the last 30 days) with any sleep,
  /// water, steps or workout logged.
  Future<int> countTrackedDays(String userId, String date) async {
    final end = DateTime.parse(date);
    final start = end.subtract(const Duration(days: _historyWindowDays - 1));
    final startKey = start.toIso8601String().split('T')[0];

    Future<Iterable<String>> activeDays(String metric, String field) async {
      final snapshot = await _progress(userId, metric)
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: startKey)
          .where(FieldPath.documentId, isLessThanOrEqualTo: date)
          .get();
      return snapshot.docs
          .where((doc) => ((doc.data()[field] as num?) ?? 0) > 0)
          .map((doc) => doc.id);
    }

    final results = await Future.wait([
      activeDays('sleep', 'duration'),
      activeDays('water', 'glassesConsumed'),
      activeDays('steps', 'steps'),
      activeDays('workout', 'durationMinutes'),
    ]);
    return {for (final days in results) ...days}.length;
  }

  /// Whether a score was ever saved; once unlocked the history check is
  /// skipped.
  Future<bool> hasAnyScore(String userId) async {
    final snapshot = await _user(userId).collection('recovery').limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Stream<RecoveryScore?> watchScore(String userId, String date) {
    return _recoveryDoc(userId, date).snapshots().map((doc) {
      final data = doc.data();
      return data == null ? null : _fromMap(data, date);
    });
  }

  /// Saves the score, then mirrors it onto `clients/{uid}` for YeetCoach.
  Future<void> saveScore(String userId, RecoveryScore score) async {
    await _recoveryDoc(userId, score.date).set({
      'date': score.date,
      'score': score.score,
      'sleepContribution': score.sleepContrib,
      'waterContribution': score.waterContrib,
      'stepsContribution': score.stepsContrib,
      'workoutContribution': score.workoutContrib,
      'stepsTracked': score.stepsTracked,
      'recommendation': switch (score.recommendation) {
        RecoveryRecommendation.push => 'push',
        RecoveryRecommendation.activeRecovery => 'active_recovery',
        RecoveryRecommendation.rest => 'rest',
      },
      'calculatedAt': FieldValue.serverTimestamp(),
    });
    await _mirrorToClient(userId, score);
    // Per-day fields YeetCoach reads for its 7-day chart.
    await _recoveryDoc(userId, score.date).set({
      'score': score.score,
      'level': _levelName(score.level),
      'savedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static String _levelName(RecoveryLevel level) => switch (level) {
    RecoveryLevel.excellent => 'Excellent',
    RecoveryLevel.good => 'Good',
    RecoveryLevel.fair => 'Fair',
    RecoveryLevel.needsRest => 'Needs Rest',
  };

  /// Skipped when the user has no client profile yet: a merge write would
  /// create a partial one that the profile save then never completes. A
  /// failure is logged so it can't fail the recovery save itself.
  Future<void> _mirrorToClient(String userId, RecoveryScore score) async {
    try {
      final clientRef = _firestore.collection('clients').doc(userId);
      if (!(await clientRef.get()).exists) return;
      await clientRef.set({
        'recoveryScore': score.score,
        'recoveryLevel': _levelName(score.level),
        'recoveryUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Mirroring recovery score to clients/$userId failed: $e');
    }
  }

  static RecoveryScore _fromMap(Map<String, dynamic> map, String date) {
    double asDouble(String key) => (map[key] as num?)?.toDouble() ?? 0;
    return RecoveryScore(
      date: map['date'] as String? ?? date,
      score: (map['score'] as num?)?.toInt() ?? 0,
      sleepContrib: asDouble('sleepContribution'),
      waterContrib: asDouble('waterContribution'),
      stepsContrib: asDouble('stepsContribution'),
      workoutContrib: asDouble('workoutContribution'),
      // Scores saved before steps could be untracked always counted them.
      stepsTracked: map['stepsTracked'] as bool? ?? true,
      recommendation: switch (map['recommendation'] as String?) {
        'push' => RecoveryRecommendation.push,
        'active_recovery' => RecoveryRecommendation.activeRecovery,
        _ => RecoveryRecommendation.rest,
      },
    );
  }
}
