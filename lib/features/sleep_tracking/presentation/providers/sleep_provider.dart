import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasource/sleep_data_source.dart';
import '../../domain/entities/sleep_data.dart';
import '../../data/repositories/sleep_repository_impl.dart';
import '../../domain/repositories/sleep_repository.dart';

final sleepRepositoryProvider = Provider<SleepRepository>(
  (ref) => SleepRepositoryImpl(SleepDataSource()),
);

/// Today's sleep entry (times, duration and goal), live from Firestore.
/// `null` data means nothing has been saved for today yet.
final todaySleepProvider = StreamProvider.autoDispose
    .family<SleepData?, String>(
      (ref, userId) =>
          ref.read(sleepRepositoryProvider).watchTodaySleep(userId),
    );

/// Last seven days of saved entries, fetched once per screen visit.
final sleepHistoryProvider = FutureProvider.autoDispose
    .family<List<SleepData>, String>(
      (ref, userId) =>
          ref.read(sleepRepositoryProvider).getWeeklySleepData(userId),
    );

/// [sleepHistoryProvider] with today's live entry merged in, sorted by date.
final weeklySleepDataProvider = Provider.autoDispose
    .family<AsyncValue<List<SleepData>>, String>((ref, userId) {
      final today = ref.watch(todaySleepProvider(userId)).value;
      return ref
          .watch(sleepHistoryProvider(userId))
          .whenData(
            (history) => [
              for (final entry in history)
                if (entry.date != today?.date) entry,
              ?today,
            ]..sort((a, b) => a.date.compareTo(b.date)),
          );
    });

// Form state for the sleep entry dialog.
final sleepEntryFormProvider = NotifierProvider.autoDispose
    .family<SleepEntryFormNotifier, SleepEntryForm, String>(
      SleepEntryFormNotifier.new,
    );

// Saves the sleep goal. `data(true)` once saved; errors carry a user-facing
// message.
final sleepGoalControllerProvider = AsyncNotifierProvider.autoDispose
    .family<SleepGoalController, bool, String>(SleepGoalController.new);

// Immutable form state for the sleep entry dialog.
class SleepEntryForm {
  final DateTime? bedtime;
  final DateTime? wakeUpTime;
  final bool isSubmitting;

  const SleepEntryForm({
    this.bedtime,
    this.wakeUpTime,
    this.isSubmitting = false,
  });

  SleepEntryForm copyWith({
    DateTime? bedtime,
    DateTime? wakeUpTime,
    bool? isSubmitting,
  }) {
    return SleepEntryForm(
      bedtime: bedtime ?? this.bedtime,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  /// Wake-up time moved forward a day when it's at or before bedtime, i.e.
  /// the user slept past midnight. Null until both times are set.
  DateTime? get adjustedWakeUpTime {
    final start = bedtime;
    var end = wakeUpTime;
    if (start == null || end == null) return null;
    while (!end!.isAfter(start)) {
      end = end.add(const Duration(days: 1));
    }
    return end;
  }

  /// Time asleep, or null until both times are set.
  Duration? get sleepDuration => adjustedWakeUpTime?.difference(bedtime!);
}

class SleepEntryFormNotifier extends Notifier<SleepEntryForm> {
  final String userId;

  SleepEntryFormNotifier(this.userId);

  @override
  SleepEntryForm build() {
    // Prefill with today's logged times once they load, without overwriting edits.
    ref.listen<AsyncValue<SleepData?>>(todaySleepProvider(userId), (_, next) {
      final sleep = next.value;
      if (sleep == null) return;
      state = state.copyWith(
        bedtime: state.bedtime ?? sleep.bedtime,
        wakeUpTime: state.wakeUpTime ?? sleep.wakeUpTime,
      );
    });
    final loggedSleep = ref.read(todaySleepProvider(userId)).value;
    return SleepEntryForm(
      bedtime: loggedSleep?.bedtime,
      wakeUpTime: loggedSleep?.wakeUpTime,
    );
  }

  DateTime _todayAt(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  void setBedtime(TimeOfDay time) =>
      state = state.copyWith(bedtime: _todayAt(time));

  void setWakeUpTime(TimeOfDay time) =>
      state = state.copyWith(wakeUpTime: _todayAt(time));

  /// Saves the entry. Returns an error message, or `null` once saved.
  Future<String?> submit() async {
    final bedtime = state.bedtime;
    final adjustedWakeUpTime = state.adjustedWakeUpTime;
    if (bedtime == null || adjustedWakeUpTime == null) {
      return 'Please select both bedtime and wake-up time';
    }
    final duration = state.sleepDuration!.inMinutes / 60.0;

    final repository = ref.read(sleepRepositoryProvider);
    state = state.copyWith(isSubmitting: true);
    try {
      await repository.addSleepEntry(
        userId,
        bedtime,
        adjustedWakeUpTime,
        duration,
      );
      return null;
    } catch (e) {
      return 'Failed to save sleep entry: $e';
    } finally {
      if (ref.mounted) state = state.copyWith(isSubmitting: false);
    }
  }
}

class SleepGoalController extends AsyncNotifier<bool> {
  final String userId;

  SleepGoalController(this.userId);

  @override
  FutureOr<bool> build() => false;

  /// Validates and saves [input] as the goal in hours.
  Future<void> submit(String input) async {
    if (state.isLoading) return;
    final newGoal = double.tryParse(input.trim());
    if (newGoal == null || newGoal <= 0) {
      state = AsyncError('Please enter a valid number', StackTrace.current);
      return;
    }
    state = const AsyncLoading();
    try {
      await ref.read(sleepRepositoryProvider).setSleepGoal(userId, newGoal);
      if (ref.mounted) state = const AsyncData(true);
    } catch (e, stackTrace) {
      if (ref.mounted) {
        state = AsyncError('Failed to save sleep goal: $e', stackTrace);
      }
    }
  }
}
