import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/plans/presentation/providers/plan_provider.dart';
import '../../domain/entities/planned_workout.dart';
import '../../domain/entities/workout_intensity.dart';
import '../../domain/entities/workout_log.dart';
import '../../domain/entities/workout_type.dart';
import 'workout_log_provider.dart';

/// Form state for the log-workout sheet, keyed by user id.
final workoutLogFormProvider = NotifierProvider.autoDispose
    .family<WorkoutLogFormNotifier, WorkoutLogForm, String>(
      WorkoutLogFormNotifier.new,
    );

class WorkoutLogForm {
  final WorkoutType? type;
  final int? durationMinutes;
  final WorkoutIntensity intensity;

  /// The coach plan this log completes; saved as `fromPlan` / `planId`.
  final String? planId;
  final String? planTitle;
  final bool isSubmitting;

  const WorkoutLogForm({
    this.type,
    this.durationMinutes,
    this.intensity = WorkoutIntensity.moderate,
    this.planId,
    this.planTitle,
    this.isSubmitting = false,
  });

  WorkoutLogForm copyWith({
    WorkoutType? type,
    int? Function()? durationMinutes,
    WorkoutIntensity? intensity,
    bool? isSubmitting,
  }) {
    return WorkoutLogForm(
      type: type ?? this.type,
      durationMinutes: durationMinutes != null
          ? durationMinutes()
          : this.durationMinutes,
      intensity: intensity ?? this.intensity,
      planId: planId,
      planTitle: planTitle,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class WorkoutLogFormNotifier extends Notifier<WorkoutLogForm> {
  final String userId;

  /// Set on the first edit; later-arriving data no longer re-seeds the form.
  bool _edited = false;

  WorkoutLogFormNotifier(this.userId);

  @override
  WorkoutLogForm build() {
    // The sheet can open before today's log or plans have loaded.
    ref.listen(todayWorkoutLogProvider(userId), (_, _) => _reseed());
    ref.listen(todayPlannedWorkoutProvider, (_, _) => _reseed());
    return _seed();
  }

  void _reseed() {
    if (!_edited && !state.isSubmitting) state = _seed();
  }

  /// Today's log wins (editing it); otherwise today's coach plan pre-fills.
  WorkoutLogForm _seed() {
    final log = ref.read(todayWorkoutLogProvider(userId)).value;
    final plan = ref.read(todayPlannedWorkoutProvider).value;
    if (log != null) {
      final planId = log.fromPlan ? log.planId : null;
      return WorkoutLogForm(
        type: log.type,
        durationMinutes: log.durationMinutes,
        intensity: log.intensity,
        planId: planId,
        planTitle: _titleFor(planId, plan),
      );
    }
    if (plan != null) {
      return WorkoutLogForm(
        type: plan.type,
        durationMinutes: plan.durationMinutes,
        intensity: plan.intensity,
        planId: plan.planId,
        planTitle: plan.title,
      );
    }
    return const WorkoutLogForm();
  }

  String? _titleFor(String? planId, PlannedWorkout? plan) {
    if (planId == null) return null;
    if (plan?.planId == planId) return plan!.title;
    final plans = ref.read(allWorkoutPlansProvider).value ?? const [];
    for (final candidate in plans) {
      if (candidate.id == planId) return candidate.title;
    }
    return null;
  }

  void setType(WorkoutType type) {
    _edited = true;
    state = state.copyWith(type: type);
  }

  void setIntensity(WorkoutIntensity intensity) {
    _edited = true;
    state = state.copyWith(intensity: intensity);
  }

  void setDuration(String text) {
    _edited = true;
    state = state.copyWith(durationMinutes: () => int.tryParse(text.trim()));
  }

  /// Saves today's workout. Returns an error message, or `null` once saved.
  Future<String?> submit() async {
    final type = state.type;
    final duration = state.durationMinutes;
    if (type == null) return 'Choose a workout type';
    if (duration == null || !WorkoutLog.isValidDuration(duration)) {
      return 'Enter a duration between ${WorkoutLog.minDurationMinutes} '
          'and ${WorkoutLog.maxDurationMinutes} minutes';
    }

    state = state.copyWith(isSubmitting: true);
    try {
      await ref
          .read(workoutLogRepositoryProvider)
          .saveLog(
            userId,
            WorkoutLog(
              date: workoutLogDateKey(DateTime.now()),
              type: type,
              durationMinutes: duration,
              intensity: state.intensity,
              fromPlan: state.planId != null,
              planId: state.planId,
            ),
          );
      return null;
    } catch (e) {
      return 'Failed to save workout: $e';
    } finally {
      if (ref.mounted) state = state.copyWith(isSubmitting: false);
    }
  }
}
