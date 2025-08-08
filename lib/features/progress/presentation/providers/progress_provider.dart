import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/progress_datasource.dart';
import '../../data/repositories/daily_progress_repository_impl.dart';
import '../../domain/usecases/daily_progress.dart';
import '../../domain/usecases/get_monthly_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


// Repository provider
final progressRepositoryProvider = Provider<ProgressRepositoryImpl>(
  (ref) => ProgressRepositoryImpl(
    dataSource: ProgressDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ),
  ),
);

// UseCase provider
final getMonthlyProgressProvider = Provider<GetMonthlyProgress>(
  (ref) => GetMonthlyProgress(repository: ref.read(progressRepositoryProvider)),
);

// Provider for selected metric
final selectedMetricProvider = StateProvider<String?>((ref) => null);

// Provider for monthly progress
final monthlyProgressProvider = StateNotifierProvider.autoDispose
    .family<MonthlyProgressNotifier, AsyncValue<List<DailyProgress>>, DateTime>(
      (ref, month) => MonthlyProgressNotifier(
        ref,
        ref.read(getMonthlyProgressProvider),
        month,
        ref.watch(selectedMetricProvider),
      ),
    );

// Provider for daily progress color for a specific date
final dailyProgressColorProvider = Provider.autoDispose.family<Color, String>((
  ref,
  userIdAndDate,
) {
  final parts = userIdAndDate.split('|');
  final userId = parts[0];
  final date = parts[1];
  final month = DateTime.parse(date).copyWith(day: 1);
  final metric = ref.watch(selectedMetricProvider);
  final monthlyData = ref.watch(monthlyProgressProvider(month)).value ?? [];
  final today = DateTime.now().toIso8601String().split('T')[0];

  final progressEntry = monthlyData.firstWhere(
    (entry) => entry.date == date,
    orElse: () => DailyProgress(date: date, completionRate: 0.0),
  );
  final progress = progressEntry.completionRate;

  if (progress >= 0.8) return const Color(0xFF4CAF50);
  if (progress >= 0.5) return const Color(0xFF81C784);
  if (progress >= 0.2) return const Color(0xFFC8E6C9);
  return const Color(0xFFE0E0E0);
});

// Notifier for monthly progress
class MonthlyProgressNotifier
    extends StateNotifier<AsyncValue<List<DailyProgress>>> {
  final Ref _ref;
  final GetMonthlyProgress _getMonthlyProgress;
  final DateTime _month;
  final String? _metric;

  MonthlyProgressNotifier(
    this._ref,
    this._getMonthlyProgress,
    this._month,
    this._metric,
  ) : super(const AsyncValue.loading()) {
    _fetchProgress();
  }

  Future<void> _fetchProgress() async {
    try {
      if (!mounted) {
        return;
      }
      state = const AsyncValue.loading();
      final progress = await _getMonthlyProgress.call(_month, metric: _metric);
      if (mounted) {
        state = AsyncValue.data(
          progress.isEmpty
              ? [
                  DailyProgress(
                    date: _month.toIso8601String().substring(0, 10),
                    completionRate: 0.0,
                  ),
                ]
              : progress,
        );
      }
    } catch (e, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  Future<void> refresh() async {
    if (!mounted) {
      return;
    }
    await _fetchProgress();
  }
}
