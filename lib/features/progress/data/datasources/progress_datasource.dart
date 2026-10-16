import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/progress_metric.dart';
import '../model/daily_progress_model.dart';

class ProgressDataSource {
  final FirebaseFirestore _firestore;

  ProgressDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Daily docs for [metric]: `users/{uid}/mood` for mood, otherwise
  /// `users/{uid}/progress/{key}/{key}`.
  CollectionReference<Map<String, dynamic>> _collection(
    String userId,
    ProgressMetric metric,
  ) {
    final user = _firestore.collection('users').doc(userId);
    final key = switch (metric) {
      ProgressMetric.steps => 'steps',
      ProgressMetric.water => 'water',
      ProgressMetric.sleep => 'sleep',
      ProgressMetric.calories => 'food',
      ProgressMetric.mood || ProgressMetric.all => null,
    };
    return key == null
        ? user.collection('mood')
        : user.collection('progress').doc(key).collection(key);
  }

  /// Metric docs are keyed by date. Food entries have generated IDs, so
  /// they're matched on their `date` field instead.
  Query<Map<String, dynamic>> _monthQuery(
    String userId,
    ProgressMetric metric,
    String startDate,
    String endDate,
  ) {
    final field = metric == ProgressMetric.calories
        ? FieldPath(const ['date'])
        : FieldPath.documentId;
    return _collection(userId, metric)
        .where(field, isGreaterThanOrEqualTo: startDate)
        .where(field, isLessThanOrEqualTo: endDate);
  }

  /// Total kcal logged per date. Legacy `{date}-goal` docs are skipped.
  static Map<String, double> _dailyCalorieTotals(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final totals = <String, double>{};
    for (final doc in docs) {
      if (doc.id.endsWith('-goal')) continue;
      final data = doc.data();
      final date = data['date'];
      final calories = data['calories'];
      if (date is! String || calories is! num) continue;
      totals[date] = (totals[date] ?? 0) + calories;
    }
    return totals;
  }

  /// One entry per day of [month] holding the docs needed for [metric]
  /// (all four fitness metrics for [ProgressMetric.all]).
  Future<List<DailyProgressModel>> getMonthlyProgress(
    String userId,
    DateTime month, {
    required ProgressMetric metric,
  }) async {
    final endOfMonth = DateTime(month.year, month.month + 1, 0);
    final startStr = DateTime(
      month.year,
      month.month,
    ).toIso8601String().substring(0, 10);
    final endStr = endOfMonth.toIso8601String().substring(0, 10);
    final progressMap = <String, Map<ProgressMetric, Map<String, dynamic>>>{};

    try {
      final metrics = metric == ProgressMetric.all
          ? ProgressMetric.fitness
          : [metric];

      for (final m in metrics) {
        final dataSnap = await _monthQuery(userId, m, startStr, endStr)
            .get()
            .timeout(
              const Duration(seconds: 12),
              onTimeout: () =>
                  throw TimeoutException('Timed out fetching ${m.label} data'),
            );

        if (m == ProgressMetric.calories) {
          for (final MapEntry(key: date, value: calories)
              in _dailyCalorieTotals(dataSnap.docs).entries) {
            progressMap.putIfAbsent(date, () => {})[m] = {'calories': calories};
          }
        } else {
          for (final doc in dataSnap.docs) {
            progressMap.putIfAbsent(doc.id, () => {})[m] = doc.data();
          }
        }
      }

      final progressList = <DailyProgressModel>[];
      for (var day = 1; day <= endOfMonth.day; day++) {
        final dateStr = DateTime(
          month.year,
          month.month,
          day,
        ).toIso8601String().substring(0, 10);
        progressList.add(
          DailyProgressModel(
            date: dateStr,
            metrics: progressMap[dateStr] ?? {},
          ),
        );
      }
      return progressList;
    } catch (e, st) {
      debugPrint('[DataSource] Error fetching progress: $e\n$st');
      rethrow;
    }
  }
}
