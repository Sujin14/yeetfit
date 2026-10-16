import 'package:yeetfit/features/workout_log/domain/entities/workout_log.dart';

/// One day's tracking values that feed the recovery calculation.
class RecoveryInputs {
  final double hoursSlept;
  final double sleepGoal;
  final int glassesConsumed;
  final int waterGoal;

  /// Null when the day has no step data at all.
  final int? stepsToday;
  final int stepsGoal;

  /// Null when no workout is logged for the day.
  final WorkoutLog? workout;

  const RecoveryInputs({
    required this.hoursSlept,
    required this.sleepGoal,
    required this.glassesConsumed,
    required this.waterGoal,
    required this.stepsToday,
    required this.stepsGoal,
    required this.workout,
  });
}
