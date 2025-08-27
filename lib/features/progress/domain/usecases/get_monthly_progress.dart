import '../repositories/daily_progress_repository.dart';
import 'daily_progress.dart';

class GetMonthlyProgress {
  final ProgressRepository repository;
  GetMonthlyProgress({required this.repository});

  Future<List<DailyProgress>> call(DateTime month, {String? metric}) {
    return repository.getMonthlyProgress(month, metric: metric);
  }
}
