import 'package:flutter_test/flutter_test.dart';
import 'package:yeetfit/features/recovery/domain/entities/recovery_inputs.dart';
import 'package:yeetfit/features/recovery/domain/entities/recovery_score.dart';
import 'package:yeetfit/features/recovery/domain/usecases/calculate_recovery_score.dart';
import 'package:yeetfit/features/workout_log/domain/entities/workout_intensity.dart';
import 'package:yeetfit/features/workout_log/domain/entities/workout_log.dart';
import 'package:yeetfit/features/workout_log/domain/entities/workout_type.dart';

void main() {
  const date = '2026-10-16';

  RecoveryInputs inputs({
    double hoursSlept = 8,
    double sleepGoal = 8,
    int glassesConsumed = 8,
    int waterGoal = 8,
    int? stepsToday = 10000,
    int stepsGoal = 10000,
    WorkoutLog? workout,
  }) {
    return RecoveryInputs(
      hoursSlept: hoursSlept,
      sleepGoal: sleepGoal,
      glassesConsumed: glassesConsumed,
      waterGoal: waterGoal,
      stepsToday: stepsToday,
      stepsGoal: stepsGoal,
      workout: workout,
    );
  }

  const completedWorkout = WorkoutLog(
    date: date,
    type: WorkoutType.gym,
    durationMinutes: 45,
    intensity: WorkoutIntensity.intense,
  );

  group('calculateRecoveryScore', () {
    test('every input at its goal scores 100', () {
      final score = calculateRecoveryScore(
        inputs(workout: completedWorkout),
        date: date,
      );

      expect(score.sleepContrib, RecoveryScore.sleepPoints);
      expect(score.waterContrib, RecoveryScore.waterPoints);
      expect(score.stepsContrib, RecoveryScore.stepsPoints);
      expect(score.workoutContrib, RecoveryScore.maxWorkout);
      expect(score.score, 100);
      expect(score.recommendation, RecoveryRecommendation.push);
    });

    test('missing steps move their 20 points onto sleep and water', () {
      final score = calculateRecoveryScore(
        inputs(stepsToday: null, workout: completedWorkout),
        date: date,
      );

      expect(score.stepsTracked, isFalse);
      expect(score.stepsContrib, 0);
      expect(score.sleepContrib, 35);
      expect(score.waterContrib, 35);
      expect(score.workoutContrib, RecoveryScore.maxWorkout);
      expect(
        score.sleepContrib +
            score.waterContrib +
            score.stepsContrib +
            score.workoutContrib,
        RecoveryScore.maxPoints,
      );
      expect(score.score, 100);
    });

    test('no workout contributes 0 points', () {
      final score = calculateRecoveryScore(inputs(), date: date);

      expect(score.workoutContrib, 0);
      expect(score.score, 82);
    });

    test('all zeros score 0', () {
      final score = calculateRecoveryScore(
        inputs(hoursSlept: 0, glassesConsumed: 0, stepsToday: 0),
        date: date,
      );

      expect(score.sleepContrib, 0);
      expect(score.waterContrib, 0);
      expect(score.stepsContrib, 0);
      expect(score.workoutContrib, 0);
      expect(score.score, 0);
      expect(score.recommendation, RecoveryRecommendation.rest);
    });

    test('score never exceeds 100', () {
      final score = calculateRecoveryScore(
        inputs(
          hoursSlept: 20,
          glassesConsumed: 40,
          stepsToday: 50000,
          workout: completedWorkout,
        ),
        date: date,
      );

      expect(score.score, lessThanOrEqualTo(100));
      expect(score.score, 100);
    });

    test('score never goes below 0', () {
      final score = calculateRecoveryScore(
        inputs(hoursSlept: -4, glassesConsumed: -2, stepsToday: -100),
        date: date,
      );

      expect(score.score, greaterThanOrEqualTo(0));
      expect(score.score, 0);
    });
  });
}
