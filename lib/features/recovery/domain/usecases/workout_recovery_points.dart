import 'dart:math';
import 'package:yeetfit/features/workout_log/domain/entities/workout_intensity.dart';
import 'package:yeetfit/features/workout_log/domain/entities/workout_log.dart';
import '../entities/recovery_score.dart';

const double _lightPoints = 8;
const double _moderatePoints = 12;
const double _intensePoints = 15;
const double _longSessionBonus = 3;
const int _longSessionMinutes = 45;

/// 0–15: by intensity, plus a bonus for a long non-light session.
double workoutRecoveryPoints(WorkoutLog? log) {
  if (log == null) return 0;
  final base = switch (log.intensity) {
    WorkoutIntensity.light => _lightPoints,
    WorkoutIntensity.moderate => _moderatePoints,
    WorkoutIntensity.intense => _intensePoints,
  };
  final earnsBonus =
      log.durationMinutes >= _longSessionMinutes &&
      log.intensity != WorkoutIntensity.light;
  return min(base + (earnsBonus ? _longSessionBonus : 0), RecoveryScore.maxWorkout);
}
