import 'package:flutter_test/flutter_test.dart';
import 'package:yeetfit/features/mood/domain/entities/mood_entry.dart';
import 'package:yeetfit/features/mood/domain/usecases/correlate_mood_with_fitness.dart';

void main() {
  final today = DateTime(2026, 10, 16);
  const correlate = CorrelateMoodWithFitness();

  DateTime day(int daysAgo) =>
      DateTime(today.year, today.month, today.day - daysAgo);

  String key(DateTime date) => date.toIso8601String().split('T')[0];

  MoodEntry mood(int daysAgo, int score) {
    final date = day(daysAgo);
    return MoodEntry(date: key(date), score: score, timestamp: date);
  }

  group('CorrelateMoodWithFitness', () {
    test('perfect positive correlation is 1', () {
      final result = correlate.call(
        moods: [mood(1, 1), mood(0, 5)],
        fitnessByDate: {key(day(1)): 0.2, key(day(0)): 1},
        today: today,
      );

      expect(result.pearson, closeTo(1, 0.001));
    });

    test('perfect negative correlation is -1', () {
      final result = correlate.call(
        moods: [mood(1, 5), mood(0, 1)],
        fitnessByDate: {key(day(1)): 0.2, key(day(0)): 1},
        today: today,
      );

      expect(result.pearson, closeTo(-1, 0.001));
    });

    test('unrelated series correlate near 0', () {
      final result = correlate.call(
        moods: [mood(3, 1), mood(2, 5), mood(1, 1), mood(0, 5)],
        fitnessByDate: {
          key(day(3)): 0.2,
          key(day(2)): 0.2,
          key(day(1)): 0.8,
          key(day(0)): 0.8,
        },
        today: today,
      );

      expect(result.pearson, closeTo(0, 0.001));
    });

    test('empty data returns no correlation', () {
      final result = correlate.call(
        moods: const [],
        fitnessByDate: const {},
        today: today,
      );

      expect(result.pearson, isNull);
      expect(result.pairedDays, 0);
      expect(result.days, hasLength(CorrelateMoodWithFitness.windowDays));
    });

    test('a single paired day returns no correlation', () {
      final result = correlate.call(
        moods: [mood(0, 3)],
        fitnessByDate: {key(day(0)): 0.5},
        today: today,
      );

      expect(result.pearson, isNull);
      expect(result.pairedDays, 1);
    });
  });
}
