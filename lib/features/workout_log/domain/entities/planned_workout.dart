import 'workout_intensity.dart';
import 'workout_type.dart';

/// A coach-assigned plan scheduled for today, with the values it suggests
/// for the log form.
class PlannedWorkout {
  final String planId;
  final String title;
  final WorkoutType type;

  /// Null when the plan gives no usable duration.
  final int? durationMinutes;
  final WorkoutIntensity intensity;

  const PlannedWorkout({
    required this.planId,
    required this.title,
    required this.type,
    required this.durationMinutes,
    required this.intensity,
  });
}
