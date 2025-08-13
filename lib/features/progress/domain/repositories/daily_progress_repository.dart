import '../usecases/daily_progress.dart';

abstract class ProgressRepository {
  Future<List<DailyProgress>> getMonthlyProgress(DateTime month, {String? metric});
}
