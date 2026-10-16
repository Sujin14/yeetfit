class MoodEntry {
  static const int minScore = 1;
  static const int maxScore = 5;

  final String date; // 'yyyy-MM-dd'
  final int score; // 1–5
  final DateTime timestamp;

  const MoodEntry({
    required this.date,
    required this.score,
    required this.timestamp,
  });

  /// Today's entry for [score]; throws [ArgumentError] outside 1–5.
  factory MoodEntry.today(int score) {
    if (score < minScore || score > maxScore) {
      throw ArgumentError.value(score, 'score', 'must be 1–5');
    }
    final now = DateTime.now();
    return MoodEntry(
      date: now.toIso8601String().split('T')[0],
      score: score,
      timestamp: now,
    );
  }
}
