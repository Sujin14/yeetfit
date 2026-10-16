class DailyProgress {
  final String date;

  /// 0–1 completion, or null when nothing was logged that day.
  final double? completionRate;

  const DailyProgress({required this.date, required this.completionRate});
}
