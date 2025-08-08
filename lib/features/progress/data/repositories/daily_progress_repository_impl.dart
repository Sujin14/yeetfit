

import '../../domain/repositories/daily_progress_repository.dart';
import '../../domain/usecases/daily_progress.dart';
import '../datasources/progress_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressDataSource dataSource;

  ProgressRepositoryImpl({required this.dataSource});

  @override
  Future<List<DailyProgress>> getMonthlyProgress(DateTime month, {String? metric}) async {
    final models = await dataSource.getMonthlyProgress(month, metric: metric);
    return models
        .map((model) => DailyProgress(
              date: model.date,
              completionRate: model.getCompletionRate(metric: metric),
            ))
        .toList();
  }
}