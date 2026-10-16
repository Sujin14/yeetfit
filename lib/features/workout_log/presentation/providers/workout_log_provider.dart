import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/plans/presentation/providers/plan_provider.dart';
import '../../data/datasources/workout_log_datasource.dart';
import '../../data/repositories/workout_log_repository_impl.dart';
import '../../domain/entities/planned_workout.dart';
import '../../domain/entities/today_workout_status.dart';
import '../../domain/entities/workout_log.dart';
import '../../domain/repositories/workout_log_repository.dart';
import '../../domain/usecases/find_planned_workout.dart';

String workoutLogDateKey(DateTime day) => day.toIso8601String().split('T')[0];

final workoutLogRepositoryProvider = Provider<WorkoutLogRepository>(
  (ref) => WorkoutLogRepositoryImpl(WorkoutLogDataSource()),
);

final todayWorkoutLogProvider = StreamProvider.autoDispose
    .family<WorkoutLog?, String>((ref, userId) {
      return ref
          .read(workoutLogRepositoryProvider)
          .watchLog(userId, workoutLogDateKey(DateTime.now()));
    });

/// Today's coach-assigned workout from the signed-in client's plans.
final todayPlannedWorkoutProvider =
    Provider.autoDispose<AsyncValue<PlannedWorkout?>>((ref) {
      return ref
          .watch(allWorkoutPlansProvider)
          .whenData(
            (plans) => findPlannedWorkout([
              for (final plan in plans)
                if (plan.id != null)
                  (id: plan.id!, title: plan.title, details: plan.details),
            ], DateTime.now()),
          );
    });

/// Loading only while today's log loads; an unreadable plan list counts as
/// no plan, so logging still works.
final todayWorkoutStatusProvider = Provider.autoDispose
    .family<AsyncValue<TodayWorkoutStatus>, String>((ref, userId) {
      final logAsync = ref.watch(todayWorkoutLogProvider(userId));
      final plan = ref.watch(todayPlannedWorkoutProvider).value;
      final plans = ref.watch(allWorkoutPlansProvider).value ?? const [];

      return logAsync.whenData((log) {
        String? logPlanTitle;
        final planId = log?.planId;
        if (planId != null) {
          for (final candidate in plans) {
            if (candidate.id == planId) logPlanTitle = candidate.title;
          }
        }
        return TodayWorkoutStatus(
          log: log,
          plan: plan,
          logPlanTitle: logPlanTitle,
        );
      });
    });
