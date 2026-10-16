import 'package:flutter_test/flutter_test.dart';
import 'package:yeetfit/core/utils/nutrition_targets_calculator.dart';

void main() {
  group('NutritionTargetsCalculator', () {
    test('weight loss: BMR × activity − 500, rounded to 50 kcal', () {
      // BMR 1780 × 1.55 = 2759 − 500 = 2259 → 2250.
      final targets = NutritionTargetsCalculator.calculate(
        gender: 'Male',
        age: 30,
        weightKg: 80,
        heightCm: 180,
        activityLevel: 'Moderately Active',
        goal: 'weight loss',
      )!;
      expect(targets.calories, 2250);
      expect(targets.protein, 197);
      expect(targets.carbs, 225);
      expect(targets.fat, 63);
    });

    test('weight loss is floored at 1200 kcal for women', () {
      final targets = NutritionTargetsCalculator.calculate(
        gender: 'Female',
        age: 60,
        weightKg: 45,
        heightCm: 150,
        activityLevel: 'Sedentary',
        goal: 'weight loss',
      )!;
      expect(targets.calories, 1200);
      expect(targets.protein, 105);
      expect(targets.carbs, 120);
      expect(targets.fat, 33);
    });

    test(
      'other gender averages BMR; missing activity defaults to moderate',
      () {
        // BMR 1590.75 × 1.55 = 2465.66 + 300 = 2765.66 → 2750.
        final targets = NutritionTargetsCalculator.calculate(
          gender: 'Other',
          age: 25,
          weightKg: 70,
          heightCm: 175,
          goal: 'muscle building',
        )!;
        expect(targets.calories, 2750);
        expect(targets.protein, 206);
        expect(targets.carbs, 344);
        expect(targets.fat, 61);
      },
    );

    test('very active with an unknown goal is maintenance at × 1.9', () {
      final targets = NutritionTargetsCalculator.calculate(
        gender: 'male',
        age: 30,
        weightKg: 80,
        heightCm: 180,
        activityLevel: 'Very Active',
        goal: '',
      )!;
      expect(targets.calories, 3400);
      expect(targets.protein, 213);
      expect(targets.carbs, 425);
      expect(targets.fat, 94);
    });

    test('returns null when a body field is missing', () {
      expect(
        NutritionTargetsCalculator.calculate(
          gender: 'Female',
          age: 30,
          weightKg: 60,
          heightCm: 0,
        ),
        isNull,
      );
      expect(
        NutritionTargetsCalculator.calculate(
          gender: '',
          age: 30,
          weightKg: 60,
          heightCm: 165,
        ),
        isNull,
      );
    });
  });
}
