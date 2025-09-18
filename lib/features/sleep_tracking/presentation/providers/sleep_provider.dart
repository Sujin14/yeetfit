import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasource/sleep_data_source.dart';
import '../../data/model/sleep_model.dart';
import '../../data/repositories/sleep_repository_impl.dart';
import '../../domain/usecases/add_sleep_entry.dart';
import '../../domain/usecases/set_sleep_goal.dart';
import '../../domain/usecases/get_sleep_data.dart';
import '../../domain/usecases/get_weekly_sleep_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Auth Provider
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

/// Repository provider
final sleepRepositoryProvider = Provider<SleepRepositoryImpl>(
  (ref) => SleepRepositoryImpl(SleepDataSource()),
);

/// UseCase providers
final addSleepEntryProvider = Provider<AddSleepEntry>(
  (ref) => AddSleepEntry(ref.read(sleepRepositoryProvider)),
);

final setSleepGoalProvider = Provider<SetSleepGoal>(
  (ref) => SetSleepGoal(ref.read(sleepRepositoryProvider)),
);

final getSleepDataProvider = Provider<GetSleepData>(
  (ref) => GetSleepData(ref.read(sleepRepositoryProvider)),
);

final getWeeklySleepDataProvider = Provider<GetWeeklySleepData>(
  (ref) => GetWeeklySleepData(ref.read(sleepRepositoryProvider)),
);

/// Provider for sleep duration
final sleepDurationProvider = StateNotifierProvider.autoDispose
    .family<SleepDurationNotifier, AsyncValue<double>, String>(
  (ref, userId) => SleepDurationNotifier(
    ref,
    ref.read(getSleepDataProvider),
    ref.read(addSleepEntryProvider),
    userId,
  ),
);

/// ✅ FIXED: Sleep goal provider is now a StreamProvider
/// Listens to Firestore snapshot so dashboard & feature screens stay in sync
final sleepGoalProvider =
    StreamProvider.autoDispose.family<double, String>((ref, userId) {
  final firestore = FirebaseFirestore.instance;
  final today = DateTime.now().toIso8601String().split('T')[0];

  final docRef = firestore
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('sleep')
      .collection('sleep')
      .doc(today);

  return docRef.snapshots().map((snapshot) {
    if (snapshot.exists) {
      return (snapshot.data()?['goalHours'] as num?)?.toDouble() ?? 8.0;
    }
    return 8.0; // Default goal
  });
});

/// Provider for sleep times (bedtime and wake-up time)
final sleepTimesProvider = StateNotifierProvider.autoDispose
    .family<SleepTimesNotifier, AsyncValue<Map<String, DateTime?>>, String>(
  (ref, userId) => SleepTimesNotifier(
    ref,
    ref.read(getSleepDataProvider),
    ref.read(addSleepEntryProvider),
    userId,
  ),
);

/// Provider for daily progress color
final dailySleepProgressColorProvider =
    Provider.autoDispose.family<Color, String>((ref, userIdAndDate) {
  final parts = userIdAndDate.split('|');
  final userId = parts[0];
  final date = parts[1];
  final weeklyData = ref.watch(weeklySleepDataProvider(userId)).value ?? [];
  final today = DateTime.now().toIso8601String().split('T')[0];
  final duration = date == today
      ? ref.watch(
          sleepDurationProvider(userId).select((value) => value.value ?? 0.0))
      : (weeklyData.firstWhere(
          (entry) => entry.date == date,
          orElse: () => SleepData(date: date, duration: 0.0, goalHours: 8.0),
        ).duration);
  final goalHours = date == today
      ? ref.watch(sleepGoalProvider(userId)).value ?? 8.0
      : (weeklyData.firstWhere(
          (entry) => entry.date == date,
          orElse: () => SleepData(date: date, duration: 0.0, goalHours: 8.0),
        ).goalHours);
  final progress = goalHours > 0 ? duration / goalHours : 0.0;

  if (progress >= 1.0) return const Color(0xFF4CAF50); // Green for 100%
  if (progress > 0.5) return const Color(0xFFFFEB3B); // Yellow for >50%
  if (progress >= 0.25) return const Color(0xFFFF9800); // Orange for ~50%
  return const Color(0xFFF44336); // Red for <25%
});

/// Weekly Sleep Data Provider
final weeklySleepDataProvider = FutureProvider.family<List<SleepData>, String>(
  (ref, userId) async {
    final asyncResult = await ref.read(getWeeklySleepDataProvider).call(userId);
    final weeklyData = asyncResult.when(
      data: (data) => data,
      error: (e, _) => throw e,
      loading: () => [],
    );
    final today = DateTime.now().toIso8601String().split('T')[0];
    final duration = ref
        .watch(sleepDurationProvider(userId).select((value) => value.value ?? 0.0));
    final goalHours = ref.watch(sleepGoalProvider(userId)).value ?? 8.0;
    final bedtime =
        ref.watch(sleepTimesProvider(userId).select((value) => value.value?['bedtime']));
    final wakeUpTime =
        ref.watch(sleepTimesProvider(userId).select((value) => value.value?['wakeUpTime']));
    final updatedData = weeklyData.where((data) => data.date != today).toList()
      ..add(SleepData(
        date: today,
        bedtime: bedtime,
        wakeUpTime: wakeUpTime,
        duration: duration,
        goalHours: goalHours,
      ));
    updatedData.sort((a, b) => a.date.compareTo(b.date));
    return updatedData.cast<SleepData>();
  },
);

/// Notifier for sleep duration
class SleepDurationNotifier extends StateNotifier<AsyncValue<double>> {
  final Ref _ref;
  final GetSleepData _getSleepData;
  final AddSleepEntry _addSleepEntry;
  final String _userId;

  SleepDurationNotifier(
      this._ref, this._getSleepData, this._addSleepEntry, this._userId)
      : super(const AsyncValue.loading()) {
    _fetchSleepDuration();
  }

  Future<void> _fetchSleepDuration() async {
    try {
      state = const AsyncValue.loading();
      final sleepData = await _getSleepData.call(_userId);
      state = AsyncValue.data(sleepData?.duration ?? 0.0);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateDuration(
      DateTime bedtime, DateTime wakeUpTime, double duration) async {
    try {
      state = const AsyncValue.loading();
      await _addSleepEntry.call(_userId, bedtime, wakeUpTime, duration);
      state = AsyncValue.data(duration);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Notifier for sleep times
class SleepTimesNotifier extends StateNotifier<AsyncValue<Map<String, DateTime?>>> {
  final Ref _ref;
  final GetSleepData _getSleepData;
  final AddSleepEntry _addSleepEntry;
  final String _userId;

  SleepTimesNotifier(this._ref, this._getSleepData, this._addSleepEntry, this._userId)
      : super(const AsyncValue.loading()) {
    _fetchSleepTimes();
  }

  Future<void> _fetchSleepTimes() async {
    try {
      state = const AsyncValue.loading();
      final sleepData = await _getSleepData.call(_userId);
      state = AsyncValue.data({
        'bedtime': sleepData?.bedtime,
        'wakeUpTime': sleepData?.wakeUpTime,
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addSleepEntry(
      DateTime bedtime, DateTime wakeUpTime, double duration) async {
    try {
      await _addSleepEntry.call(_userId, bedtime, wakeUpTime, duration);
      await _fetchSleepTimes();
      _ref
          .read(sleepDurationProvider(_userId).notifier)
          .updateDuration(bedtime, wakeUpTime, duration);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Logic for SleepEntryDialog
final sleepEntryDialogStateProvider =
    StateProvider.family<SleepEntryDialogState, String>((ref, userId) {
  return SleepEntryDialogState(ref, userId);
});

class SleepEntryDialogState {
  final Ref ref;
  final String userId;
  DateTime? bedtime;
  DateTime? wakeUpTime;

  SleepEntryDialogState(this.ref, this.userId) {
    final sleepTimesAsync = ref.watch(sleepTimesProvider(userId));
    bedtime = sleepTimesAsync.value?['bedtime'];
    wakeUpTime = sleepTimesAsync.value?['wakeUpTime'];
  }

  Future<void> pickBedtime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(bedtime ?? DateTime.now()),
    );
    if (time != null) {
      bedtime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        time.hour,
        time.minute,
      );
    }
  }

  Future<void> pickWakeUpTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(wakeUpTime ?? DateTime.now()),
    );
    if (time != null) {
      wakeUpTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        time.hour,
        time.minute,
      );
      if (bedtime != null && wakeUpTime!.hour < bedtime!.hour) {
        wakeUpTime = wakeUpTime!.add(const Duration(days: 1));
      }
    }
  }

  void submitSleepEntry(BuildContext context) {
    if (bedtime != null && wakeUpTime != null) {
      DateTime adjustedWakeUpTime = wakeUpTime!;
      if (wakeUpTime!.isBefore(bedtime!) ||
          wakeUpTime!.isAtSameMomentAs(bedtime!)) {
        adjustedWakeUpTime = wakeUpTime!.add(const Duration(days: 1));
      }
      final duration =
          adjustedWakeUpTime.difference(bedtime!).inMinutes / 60.0;
      ref
          .read(sleepTimesProvider(userId).notifier)
          .addSleepEntry(bedtime!, adjustedWakeUpTime, duration);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both bedtime and wake-up time')),
      );
    }
  }
}

/// Logic for SleepGoalDialog
final sleepGoalDialogStateProvider =
    StateProvider.family<SleepGoalDialogState, String>((ref, userId) {
  return SleepGoalDialogState(ref, userId);
});

class SleepGoalDialogState {
  final Ref ref;
  final String userId;
  final TextEditingController controller;

  SleepGoalDialogState(this.ref, this.userId)
      : controller = TextEditingController(text: '8.0');

  void submitGoal(BuildContext context) async {
    final newGoal = double.tryParse(controller.text);
    if (newGoal != null && newGoal > 0) {
      final firestore = FirebaseFirestore.instance;
      final today = DateTime.now().toIso8601String().split('T')[0];

      await firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc('sleep')
          .collection('sleep')
          .doc(today)
          .set({'goalHours': newGoal}, SetOptions(merge: true));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
    }
  }

  void dispose() {
    controller.dispose();
  }
}
