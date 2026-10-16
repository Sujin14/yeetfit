import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/workout_intensity.dart';
import '../../domain/entities/workout_log.dart';
import '../../domain/entities/workout_type.dart';

/// Firestore shape of users/{uid}/progress/workout/workout/{date}.
class WorkoutLogModel {
  static WorkoutLog fromMap(Map<String, dynamic> map, String date) {
    return WorkoutLog(
      date: date,
      type: WorkoutType.fromValue(map['type'] as String?),
      durationMinutes: (map['durationMinutes'] as num?)?.toInt() ?? 0,
      intensity: WorkoutIntensity.fromValue(map['intensity'] as String?),
      fromPlan: map['fromPlan'] as bool? ?? false,
      planId: map['planId'] as String?,
      loggedAt: (map['loggedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// [WorkoutLog.loggedAt] is ignored; the server stamps the write time.
  static Map<String, dynamic> toMap(WorkoutLog log) {
    return {
      'type': log.type.value,
      'durationMinutes': log.durationMinutes,
      'intensity': log.intensity.value,
      'fromPlan': log.fromPlan,
      'planId': log.fromPlan ? log.planId : null,
      'loggedAt': FieldValue.serverTimestamp(),
    };
  }
}
