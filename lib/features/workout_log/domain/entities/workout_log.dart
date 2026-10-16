import 'workout_intensity.dart';
import 'workout_type.dart';

/// The one workout logged for a day; logging again replaces it.
class WorkoutLog {
  static const int minDurationMinutes = 10;
  static const int maxDurationMinutes = 180;

  final String date; // 'yyyy-MM-dd'
  final WorkoutType type;
  final int durationMinutes;
  final WorkoutIntensity intensity;

  /// Logged as completion of a coach-assigned plan ([planId]).
  final bool fromPlan;
  final String? planId;

  /// Null until the server timestamp of a fresh write resolves.
  final DateTime? loggedAt;

  const WorkoutLog({
    required this.date,
    required this.type,
    required this.durationMinutes,
    required this.intensity,
    this.fromPlan = false,
    this.planId,
    this.loggedAt,
  });

  static bool isValidDuration(int minutes) =>
      minutes >= minDurationMinutes && minutes <= maxDurationMinutes;
}
