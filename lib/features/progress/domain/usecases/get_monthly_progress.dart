

import '../repositories/daily_progress_repository.dart';
import 'daily_progress.dart';

class GetMonthlyProgress {
  final ProgressRepository repository;

  GetMonthlyProgress({required this.repository});

  Future<List<DailyProgress>> call(DateTime month, {String? metric}) async {
    return await repository.getMonthlyProgress(month, metric: metric);
  }
}