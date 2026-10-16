import 'dart:math';
import '../entities/recovery_inputs.dart';
import '../entities/recovery_score.dart';
import 'workout_recovery_points.dart';

/// Points out of [RecoveryScore.maxPoints] (sleep 25, water 25, steps 20,
/// workout 15), scaled to 0–100. Without step data its 20 points move to
/// sleep and water (35 each).
RecoveryScore calculateRecoveryScore(
  RecoveryInputs inputs, {
  required String date,
}) {
  final stepsToday = inputs.stepsToday;
  final stepsTracked = stepsToday != null;

  final sleep =
      _ratio(inputs.hoursSlept, inputs.sleepGoal) *
      RecoveryScore.maxSleepFor(stepsTracked: stepsTracked);
  final water =
      _ratio(inputs.glassesConsumed.toDouble(), inputs.waterGoal.toDouble()) *
      RecoveryScore.maxWaterFor(stepsTracked: stepsTracked);
  final steps = stepsTracked
      ? _ratio(stepsToday.toDouble(), inputs.stepsGoal.toDouble()) *
            RecoveryScore.stepsPoints
      : 0.0;
  final workout = workoutRecoveryPoints(inputs.workout);

  final points = sleep + water + steps + workout;
  final score = (points / RecoveryScore.maxPoints * 100).round().clamp(0, 100);

  final recommendation = score >= 70
      ? RecoveryRecommendation.push
      : score >= 40
      ? RecoveryRecommendation.activeRecovery
      : RecoveryRecommendation.rest;

  return RecoveryScore(
    date: date,
    score: score,
    sleepContrib: sleep,
    waterContrib: water,
    stepsContrib: steps,
    workoutContrib: workout,
    stepsTracked: stepsTracked,
    recommendation: recommendation,
  );
}

/// Progress toward [goal], capped at 1; 0 when no goal is set.
double _ratio(double value, double goal) =>
    goal > 0 ? min(value / goal, 1.0) : 0.0;
