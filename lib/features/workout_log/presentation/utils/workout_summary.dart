import '../../domain/entities/workout_log.dart';

/// "[plan title or type] · 45 min · Moderate".
String workoutSummary(WorkoutLog log, {String? planTitle}) {
  final name = planTitle ?? log.type.label;
  return '$name · ${log.durationMinutes} min · ${log.intensity.label}';
}
