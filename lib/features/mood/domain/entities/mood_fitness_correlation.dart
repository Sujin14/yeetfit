class MoodFitnessDay {
  final DateTime date;
  final int? mood; // 1–5, null when not logged
  final double fitnessPercent; // 0–100

  const MoodFitnessDay({
    required this.date,
    required this.mood,
    required this.fitnessPercent,
  });
}

class MoodFitnessCorrelation {
  static const int requiredPairedDays = 14;

  /// One entry per day of the window, oldest first.
  final List<MoodFitnessDay> days;

  /// Days that have both a mood entry and fitness data.
  final int pairedDays;

  /// Pearson r over the paired days; null when it can't be computed
  /// (too few days or no variation in one of the series).
  final double? pearson;

  const MoodFitnessCorrelation({
    required this.days,
    required this.pairedDays,
    required this.pearson,
  });

  bool get isUnlocked => pairedDays >= requiredPairedDays;
}
