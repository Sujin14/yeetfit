import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/datasources/progress_datasource.dart';
import '../../data/repositories/daily_progress_repository_impl.dart';
import '../../domain/usecases/daily_progress.dart';
import '../../domain/usecases/get_monthly_progress.dart';

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

// Selected metric (null = all)
final selectedMetricProvider = StateProvider<String?>((ref) => null);

// Monthly progress provider (re-reads selectedMetric on each fetch)
final monthlyProgressProvider = StateNotifierProvider.autoDispose
    .family<MonthlyProgressNotifier, AsyncValue<List<DailyProgress>>, DateTime>(
      (ref, month) {
        return MonthlyProgressNotifier(
          ref,
          ref.read(getMonthlyProgressProvider),
          month,
        );
      },
    );

// Heat color provider for a given date
final dailyProgressColorProvider = Provider.autoDispose.family<Color, String>((
  ref,
  key,
) {
  // key: "<userId>|<yyyy-MM-dd>"
  final parts = key.split('|');
  final date = parts[1];
  final month = DateTime.parse(date).copyWith(day: 1);
  final entries = ref.watch(monthlyProgressProvider(month)).value ?? [];
  final entry = entries.firstWhere(
    (e) => e.date == date,
    orElse: () => DailyProgress(date: date, completionRate: 0.0),
  );
  final p = entry.completionRate;
  // Print only when there's meaningful progress (to avoid spam)
  if (p > 0.0) {
    debugPrint('[ColorProvider] date=$date completion=$p');
  }
  if (p >= 0.8) return AppTheme.colors['fullProgress']!;
  if (p >= 0.5) return AppTheme.colors['threeQuarterProgress']!;
  if (p >= 0.2) return AppTheme.colors['halfProgress']!;
  return AppTheme.colors['noProgress']!;
});

class MonthlyProgressNotifier
    extends StateNotifier<AsyncValue<List<DailyProgress>>> {
  final Ref _ref;
  final GetMonthlyProgress _usecase;
  final DateTime _month;

  MonthlyProgressNotifier(this._ref, this._usecase, this._month)
    : super(const AsyncValue.loading()) {
    _fetch();
    // Auto refresh when metric changes
    _ref.listen<String?>(selectedMetricProvider, (_, __) {
      debugPrint(
        '[Notifier] selectedMetricProvider changed - refreshing for month=$_month',
      );
      refresh();
    });
  }

  Future<void> _fetch() async {
    try {
      if (!mounted) return;
      state = const AsyncValue.loading();
      final metric = _ref.read(selectedMetricProvider);
      debugPrint(
        '[Notifier] Fetching data for month=$_month metric=${metric ?? "ALL"}',
      );
      final data = await _usecase.call(_month, metric: metric);
      if (!mounted) return;
      debugPrint('[Notifier] Fetched ${data.length} entries for month=$_month');
      for (final d in data.take(5)) {
        debugPrint('[Notifier] sample: ${d.date} => ${d.completionRate}');
      }
      state = AsyncValue.data(data);
    } catch (e, st) {
      debugPrint('[Notifier] error: $e\n$st');
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => _fetch();
}
