import 'planned_workout.dart';
import 'workout_log.dart';

/// Today's logged workout alongside today's coach plan, if any.
class TodayWorkoutStatus {
  final WorkoutLog? log;
  final PlannedWorkout? plan;

  /// Title of the plan [log] was logged from; null for manual logs or when
  /// that plan no longer exists.
  final String? logPlanTitle;

  const TodayWorkoutStatus({this.log, this.plan, this.logPlanTitle});

  bool get isLogged => log != null;

  /// A coach plan is waiting for today and nothing is logged yet.
  bool get hasPendingPlan => log == null && plan != null;
}
