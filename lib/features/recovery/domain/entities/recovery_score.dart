enum RecoveryRecommendation { push, activeRecovery, rest }

extension RecoveryRecommendationX on RecoveryRecommendation {
  String get label => switch (this) {
    RecoveryRecommendation.push => 'Push hard today',
    RecoveryRecommendation.activeRecovery => 'Active recovery',
    RecoveryRecommendation.rest => 'Rest day',
  };

  String get description => switch (this) {
    RecoveryRecommendation.push =>
      'Your body is ready. Make this session count.',
    RecoveryRecommendation.activeRecovery =>
      'Light movement only — walk, stretch, yoga.',
    RecoveryRecommendation.rest => 'Full rest. Sleep and hydrate.',
  };
}

enum RecoveryLevel {
  excellent(80, 'Excellent 🔥'),
  good(60, 'Good 💪'),
  fair(40, 'Fair 😐'),
  needsRest(0, 'Needs Rest 😴');

  const RecoveryLevel(this.minScore, this.label);

  final int minScore;
  final String label;

  static RecoveryLevel fromScore(int score) => RecoveryLevel.values.firstWhere(
    (level) => score >= level.minScore,
    orElse: () => RecoveryLevel.needsRest,
  );
}

class RecoveryScore {
  static const double sleepPoints = 25;
  static const double waterPoints = 25;
  static const double stepsPoints = 20;
  static const double maxWorkout = 15;

  /// Points available in total; the 0–100 score is the share earned.
  static const double maxPoints =
      sleepPoints + waterPoints + stepsPoints + maxWorkout;

  final String date; // 'yyyy-MM-dd'
  final int score; // 0–100
  final double sleepContrib;
  final double waterContrib;
  final double stepsContrib;
  final double workoutContrib;

  /// False when the day has no step data; its points then go half to sleep
  /// and half to water.
  final bool stepsTracked;
  final RecoveryRecommendation recommendation;

  const RecoveryScore({
    required this.date,
    required this.score,
    required this.sleepContrib,
    required this.waterContrib,
    required this.stepsContrib,
    required this.workoutContrib,
    required this.stepsTracked,
    required this.recommendation,
  });

  static double maxSleepFor({required bool stepsTracked}) =>
      stepsTracked ? sleepPoints : sleepPoints + stepsPoints / 2;

  static double maxWaterFor({required bool stepsTracked}) =>
      stepsTracked ? waterPoints : waterPoints + stepsPoints / 2;

  double get maxSleep => maxSleepFor(stepsTracked: stepsTracked);
  double get maxWater => maxWaterFor(stepsTracked: stepsTracked);
  double get maxSteps => stepsTracked ? stepsPoints : 0;

  RecoveryLevel get level => RecoveryLevel.fromScore(score);
}

/// Thrown until the user has enough tracking history for a meaningful score.
class RecoveryScoreLockedException implements Exception {
  static const int requiredTrackedDays = 3;

  final int trackedDays;

  const RecoveryScoreLockedException({required this.trackedDays});

  @override
  String toString() =>
      'Recovery score unlocks after $requiredTrackedDays tracked days '
      '($trackedDays so far)';
}
