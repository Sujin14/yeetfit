class Challenge {
  final String id;
  final String title;
  final String description;

  /// One of `steps`, `water`, `sleep` or `calories`.
  final String metric;
  final double goal;
  final int durationDays;
  final DateTime startDate;
  final DateTime endDate;
  final int participantCount;

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.metric,
    required this.goal,
    required this.durationDays,
    required this.startDate,
    required this.endDate,
    required this.participantCount,
  });

  /// Whole days left, counting a partial day as one; 0 once ended.
  int daysRemaining(DateTime now) {
    if (!endDate.isAfter(now)) return 0;
    return (endDate.difference(now).inHours / 24).ceil();
  }
}
