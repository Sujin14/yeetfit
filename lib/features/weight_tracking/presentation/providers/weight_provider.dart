import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/entities/progress_level.dart';
import '../../data/datasources/weight_datasource.dart';
import '../../domain/entities/weight_data.dart';
import '../../data/repositories/weight_repository_impl.dart';
import '../../domain/repositories/weight_repository.dart';

final weightRepositoryProvider = Provider<WeightRepository>(
  (ref) => WeightRepositoryImpl(WeightDataSource()),
);

// Today's weight, with an update method used by the save controller.
final currentWeightProvider = AsyncNotifierProvider.autoDispose
    .family<CurrentWeightNotifier, double, String>(CurrentWeightNotifier.new);

// Notifier for weight goal.
final weightGoalProvider = AsyncNotifierProvider.autoDispose
    .family<WeightGoalNotifier, WeightData, String>(WeightGoalNotifier.new);

// Computed progress toward the goal and its level for UI.
final weightProgressProvider = Provider.autoDispose
    .family<({double progress, ProgressLevel level}), String>((ref, userId) {
      final currentWeight = ref.watch(
        currentWeightProvider(userId).select((value) => value.value ?? 75.0),
      );
      final goal = ref.watch(
        weightGoalProvider(userId).select((value) => value.value),
      );
      final goalWeight = goal?.goalWeight ?? 70.0;
      final initialWeight = goal?.initialWeight ?? 75.0;
      final progress = initialWeight != goalWeight
          ? ((initialWeight - currentWeight) / (initialWeight - goalWeight))
                .clamp(0.0, 1.0)
          : 0.0;
      return (progress: progress, level: ProgressLevel.fromRatio(progress));
    });

/// Last seven days of saved entries, fetched once per screen visit.
final weightHistoryProvider = FutureProvider.autoDispose
    .family<List<WeightData>, String>(
      (ref, userId) =>
          ref.read(weightRepositoryProvider).getWeeklyWeightData(userId),
    );

/// [weightHistoryProvider] with today's live weight and goal merged in,
/// sorted by date.
final weeklyWeightDataProvider = Provider.autoDispose
    .family<AsyncValue<List<WeightData>>, String>((ref, userId) {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final currentWeight = ref.watch(
        currentWeightProvider(userId).select((value) => value.value ?? 75.0),
      );
      final goal = ref.watch(
        weightGoalProvider(userId).select((value) => value.value),
      );
      return ref
          .watch(weightHistoryProvider(userId))
          .whenData(
            (history) => [
              for (final entry in history)
                if (entry.date != today) entry,
              WeightData(
                date: today,
                currentWeight: currentWeight,
                goalWeight: goal?.goalWeight ?? 70.0,
                initialWeight: goal?.initialWeight ?? 75.0,
                targetDate: goal?.targetDate,
              ),
            ]..sort((a, b) => a.date.compareTo(b.date)),
          );
    });

class CurrentWeightNotifier extends AsyncNotifier<double> {
  final String userId;

  CurrentWeightNotifier(this.userId);

  WeightRepository get _repository => ref.read(weightRepositoryProvider);

  @override
  Future<double> build() async {
    final weightData = await _repository.getWeightData(userId);
    return weightData?.currentWeight ?? 75.0;
  }

  /// Saves today's weight and returns the goal it was saved against (null
  /// when no goal is set). Keeps the last value while saving (progress is
  /// shown by the save controller). Failures propagate to the caller.
  Future<WeightData?> updateWeight(double currentWeight) async {
    final repository = _repository;
    final goal = await repository.getUserWeightGoal(userId);
    await repository.updateWeight(
      userId,
      currentWeight,
      goal?.goalWeight,
      goal?.initialWeight,
      goal?.targetDate,
    );
    if (ref.mounted) state = AsyncData(currentWeight);
    return goal;
  }
}

/// A saved weight and the goal it was saved against (null when none is set).
class WeightSaveResult {
  final double weight;
  final double? goalWeight;

  const WeightSaveResult({required this.weight, this.goalWeight});

  bool get goalReached =>
      goalWeight != null && (weight - goalWeight!).abs() < 0.1;
}

/// Saves a weight entry: `data(null)` while idle, `data(result)` once saved;
/// errors carry a user-facing message. The tracking screen reacts once and
/// calls `consume()`.
final weightSaveControllerProvider = AsyncNotifierProvider.autoDispose
    .family<WeightSaveController, WeightSaveResult?, String>(
      WeightSaveController.new,
    );

class WeightSaveController extends AsyncNotifier<WeightSaveResult?> {
  final String userId;

  WeightSaveController(this.userId);

  @override
  FutureOr<WeightSaveResult?> build() => null;

  Future<void> save(String input) async {
    if (state.isLoading) return;
    final weight = double.tryParse(input.trim());
    if (weight == null || weight <= 0) {
      state = AsyncError('Please enter a valid weight', StackTrace.current);
      return;
    }
    state = const AsyncLoading();
    try {
      final goal = await ref
          .read(currentWeightProvider(userId).notifier)
          .updateWeight(weight);
      if (ref.mounted) {
        state = AsyncData(
          WeightSaveResult(weight: weight, goalWeight: goal?.goalWeight),
        );
      }
    } catch (e, stackTrace) {
      if (ref.mounted) {
        state = AsyncError('Failed to save weight: $e', stackTrace);
      }
    }
  }

  /// Resets a delivered result or error so the next save notifies again.
  void consume() {
    if (!state.isLoading) state = const AsyncData(null);
  }
}

// Notifier for weight goal management.
class WeightGoalNotifier extends AsyncNotifier<WeightData> {
  final String userId;

  WeightGoalNotifier(this.userId);

  WeightRepository get _repository => ref.read(weightRepositoryProvider);

  @override
  Future<WeightData> build() => _fetchGoal();

  Future<WeightData> _fetchGoal() async {
    final goal = await _repository.getUserWeightGoal(userId);
    return goal ??
        WeightData(
          date: DateTime.now().toIso8601String().split('T')[0],
          currentWeight: 75.0,
          goalWeight: 70.0,
          initialWeight: 75.0,
        );
  }

  Future<void> setGoal(
    double goalWeight,
    double initialWeight,
    DateTime? targetDate,
  ) async {
    final result = await AsyncValue.guard(() async {
      await _repository.setUserWeightGoal(
        userId,
        goalWeight,
        initialWeight,
        targetDate,
      );
      return _fetchGoal();
    });
    if (ref.mounted) state = result;
  }
}
