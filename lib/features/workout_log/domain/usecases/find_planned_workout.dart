import '../entities/planned_workout.dart';
import '../entities/workout_intensity.dart';
import '../entities/workout_log.dart';
import '../entities/workout_type.dart';

/// A coach workout plan as stored for the client: `details.exercises[]`
/// carry a free-text `day` label, and `details.duration` / `difficulty` /
/// `category` are optional.
typedef CoachWorkoutPlan = ({
  String id,
  String title,
  Map<String, dynamic> details,
});

/// Indexed by `DateTime.weekday - 1`; matches full names and common
/// abbreviations as whole words ("Monday", "Mon", "Thurs").
final _weekdayPatterns = [
  RegExp(r'\bmon(day)?\b', caseSensitive: false),
  RegExp(r'\btue(s(day)?)?\b', caseSensitive: false),
  RegExp(r'\bwed(nesday)?\b', caseSensitive: false),
  RegExp(r'\bthu(r(s(day)?)?)?\b', caseSensitive: false),
  RegExp(r'\bfri(day)?\b', caseSensitive: false),
  RegExp(r'\bsat(urday)?\b', caseSensitive: false),
  RegExp(r'\bsun(day)?\b', caseSensitive: false),
];

/// Checked in order; the first keyword hit wins.
final _typeKeywords = <(WorkoutType, RegExp)>[
  (WorkoutType.yoga, RegExp(r'\b(yoga|pilates|stretch|mobility)')),
  (WorkoutType.swimming, RegExp(r'\b(swim|pool)')),
  (WorkoutType.cycling, RegExp(r'\b(cycl|bike|biking|spin)')),
  (WorkoutType.running, RegExp(r'\b(run|jog|sprint|marathon|5k|10k)')),
  (
    WorkoutType.sports,
    RegExp(
      r'\b(sport|football|soccer|basketball|tennis|cricket|badminton|'
      r'volleyball|hockey)',
    ),
  ),
  (WorkoutType.homeWorkout, RegExp(r'\b(home|bodyweight|calisthenic|hiit)')),
  (
    WorkoutType.gym,
    RegExp(
      r'\b(gym|strength|weight|lift|push|pull|leg|chest|shoulder|upper|'
      r'lower|hypertroph|bodybuild|powerlift)',
    ),
  ),
];

/// The first of [plans] (newest first) with an exercise whose `day` label
/// names [day]'s weekday, or null when none is scheduled for that day.
PlannedWorkout? findPlannedWorkout(
  Iterable<CoachWorkoutPlan> plans,
  DateTime day,
) {
  final weekday = _weekdayPatterns[day.weekday - 1];
  for (final plan in plans) {
    final exercises = plan.details['exercises'];
    if (exercises is! List) continue;
    final todays = exercises
        .whereType<Map>()
        .where((exercise) => weekday.hasMatch('${exercise['day'] ?? ''}'))
        .toList();
    if (todays.isEmpty) continue;

    return PlannedWorkout(
      planId: plan.id,
      title: plan.title,
      type: _typeFor('${plan.title} ${plan.details['category'] ?? ''}'),
      durationMinutes: _durationFor(plan.details['duration'], todays),
      intensity: _intensityFor(plan.details['difficulty']),
    );
  }
  return null;
}

WorkoutType _typeFor(String text) {
  final lower = text.toLowerCase();
  for (final (type, pattern) in _typeKeywords) {
    if (pattern.hasMatch(lower)) return type;
  }
  return WorkoutType.other;
}

/// The plan-level duration (a number or text like "45 min"), else the total
/// of the day's timed exercises (`repsType: 'min'`, minutes per set).
/// Only values the log form accepts are returned.
int? _durationFor(Object? planDuration, List<Map> exercises) {
  final stated = switch (planDuration) {
    num minutes => minutes.round(),
    String text => int.tryParse(RegExp(r'\d+').stringMatch(text) ?? ''),
    _ => null,
  };
  if (stated != null && WorkoutLog.isValidDuration(stated)) return stated;

  var total = 0;
  for (final exercise in exercises) {
    if (exercise['repsType'] != 'min') continue;
    final minutes = exercise['reps'];
    final sets = exercise['sets'];
    if (minutes is! num) continue;
    total += (minutes * (sets is num && sets > 0 ? sets : 1)).round();
  }
  return WorkoutLog.isValidDuration(total) ? total : null;
}

WorkoutIntensity _intensityFor(Object? difficulty) {
  final text = '${difficulty ?? ''}'.toLowerCase();
  if (RegExp(r'beginner|easy|light|low').hasMatch(text)) {
    return WorkoutIntensity.light;
  }
  if (RegExp(r'advanced|expert|hard|intense|high').hasMatch(text)) {
    return WorkoutIntensity.intense;
  }
  return WorkoutIntensity.moderate;
}
