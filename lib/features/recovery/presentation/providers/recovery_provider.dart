import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/sleep_tracking/presentation/providers/sleep_provider.dart';
import 'package:yeetfit/features/steps_tracking/presentation/providers/steps_provider.dart';
import 'package:yeetfit/features/water_tracking/presentation/providers/water_provider.dart';
import 'package:yeetfit/features/workout_log/presentation/providers/workout_log_provider.dart';
import '../../data/datasources/recovery_datasource.dart';
import '../../domain/entities/recovery_inputs.dart';
import '../../domain/entities/recovery_score.dart';
import '../../domain/usecases/calculate_recovery_score.dart';

String _today() => DateTime.now().toIso8601String().split('T')[0];

const double _defaultSleepGoalHours = 8;

final recoveryDataSourceProvider = Provider<RecoveryDataSource>(
  (ref) => RecoveryDataSource(),
);

/// Today's saved score; `null` until one has been calculated (including while
/// the feature is still locked).
final recoveryScoreProvider = StreamProvider.autoDispose
    .family<RecoveryScore?, String>((ref, userId) {
      return ref.read(recoveryDataSourceProvider).watchScore(userId, _today());
    });

/// Drops a save when a newer calculation has already started, and skips a
/// write when the score is unchanged, so a burst of tracking updates can't
/// persist an older result over a newer one.
final _recoverySaveGateProvider = Provider.autoDispose
    .family<_RecoverySaveGate, String>((ref, userId) => _RecoverySaveGate());

class _RecoverySaveGate {
  int _generation = 0;
  Future<void> _queue = Future<void>.value();
  String? _lastKey;

  Future<void> saveIfChanged(
    RecoveryScore score,
    Future<void> Function() write,
  ) {
    final key = _key(score);
    if (key == _lastKey) return Future<void>.value();

    final generation = ++_generation;
    final result = _queue.then((_) async {
      if (generation != _generation) return;
      await write();
      if (generation == _generation) _lastKey = key;
    });
    _queue = result.catchError((_) {});
    return result;
  }

  static String _key(RecoveryScore score) =>
      '${score.score}|'
      '${score.sleepContrib.toStringAsFixed(2)}|'
      '${score.waterContrib.toStringAsFixed(2)}|'
      '${score.stepsContrib.toStringAsFixed(2)}|'
      '${score.workoutContrib.toStringAsFixed(2)}|'
      '${score.stepsTracked}|'
      '${score.recommendation.name}';
}

/// Recalculates today's score whenever water, sleep, steps, the step goal,
/// or the workout log changes, then saves it. The dashboard card reads the
/// saved document, so it updates without opening the detail screen.
/// Fails with [RecoveryScoreLockedException] until the user has tracked
/// enough days; once any score exists the history check is skipped.
final calculateRecoveryProvider = FutureProvider.autoDispose
    .family<RecoveryScore, String>(
      (ref, userId) async {
        final water = await ref.watch(todayWaterProvider(userId).future);
        final sleep = await ref.watch(todaySleepProvider(userId).future);
        final steps = await ref.watch(stepsCountProvider(userId).future);
        final stepsGoal = await ref.watch(stepsGoalProvider(userId).future);
        final workout = await ref.watch(todayWorkoutLogProvider(userId).future);

        final dataSource = ref.read(recoveryDataSourceProvider);
        final date = _today();

        if (!await dataSource.hasAnyScore(userId)) {
          final trackedDays = await dataSource.countTrackedDays(userId, date);
          if (trackedDays < RecoveryScoreLockedException.requiredTrackedDays) {
            throw RecoveryScoreLockedException(trackedDays: trackedDays);
          }
        }

        final score = calculateRecoveryScore(
          RecoveryInputs(
            hoursSlept: sleep?.duration ?? 0,
            sleepGoal: sleep != null && sleep.goalHours > 0
                ? sleep.goalHours
                : _defaultSleepGoalHours,
            glassesConsumed: water.glassesConsumed,
            waterGoal: water.goalGlasses,
            stepsToday: steps,
            stepsGoal: stepsGoal,
            workout: workout,
          ),
          date: date,
        );
        await ref
            .read(_recoverySaveGateProvider(userId))
            .saveIfChanged(score, () => dataSource.saveScore(userId, score));
        return score;
      },
      // Locked is an expected state; retrying would re-run the history
      // queries for nothing.
      retry: (retryCount, error) => error is RecoveryScoreLockedException
          ? null
          : ProviderContainer.defaultRetry(retryCount, error),
    );
