import 'package:flutter_test/flutter_test.dart';
import 'package:yeetfit/features/steps_tracking/domain/entities/steps_data.dart';

void main() {
  group('StepsData.caloriesFor', () {
    test('10000 steps is 400 kcal', () {
      expect(StepsData.caloriesFor(10000), 400);
    });

    test('0 steps is 0 kcal', () {
      expect(StepsData.caloriesFor(0), 0);
    });

    test('5000 steps is 200 kcal', () {
      expect(StepsData.caloriesFor(5000), 200);
    });
  });

  group('StepsData.distanceKmFor', () {
    test('10000 steps is 7.62 km', () {
      expect(StepsData.distanceKmFor(10000), closeTo(7.62, 1e-9));
    });

    test('0 steps is 0 km', () {
      expect(StepsData.distanceKmFor(0), 0);
    });

    test('1000 steps is 0.762 km', () {
      expect(StepsData.distanceKmFor(1000), closeTo(0.762, 1e-9));
    });
  });
}
