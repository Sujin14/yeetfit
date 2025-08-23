import '../../domain/repositories/daily_progress_repository.dart';
import '../../domain/usecases/daily_progress.dart';
import '../datasources/progress_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressDataSource dataSource;

  ProgressRepositoryImpl({required this.dataSource});

  @override
  Future<List<DailyProgress>> getMonthlyProgress(DateTime month, {String? metric}) async {
    print('[Repo] Requesting monthly progress for $month metric=${metric ?? "ALL"}');
    final models = await dataSource.getMonthlyProgress(month, metric: metric);
    final converted = models
        .map((m) {
          final dp = DailyProgress(
            date: m.date,
            completionRate: m.getCompletionRate(metric: metric),
          );
          print('[Repo] mapped model -> ${m.date} completion=${dp.completionRate}');
          return dp;
        })
        .toList();
    print('[Repo] Returning ${converted.length} DailyProgress entries');
    return converted;
  }
}
