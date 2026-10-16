import 'package:flutter_test/flutter_test.dart';
import 'package:yeetfit/features/dashboard/domain/entities/bmi_category.dart';

void main() {
  group('BmiCategory.fromBmi', () {
    test('a value below 18.5 is underweight', () {
      expect(BmiCategory.fromBmi(16), BmiCategory.underweight);
    });

    test('exactly 18.5 is normal', () {
      expect(BmiCategory.fromBmi(18.5), BmiCategory.normal);
    });

    test('a value between 18.5 and 24.9 is normal', () {
      expect(BmiCategory.fromBmi(22), BmiCategory.normal);
      expect(BmiCategory.fromBmi(24.9), BmiCategory.normal);
    });

    test('exactly 25.0 is overweight', () {
      expect(BmiCategory.fromBmi(25), BmiCategory.overweight);
    });

    test('a value between 25.0 and 29.9 is overweight', () {
      expect(BmiCategory.fromBmi(27), BmiCategory.overweight);
      expect(BmiCategory.fromBmi(29.9), BmiCategory.overweight);
    });

    test('exactly 30.0 is obese', () {
      expect(BmiCategory.fromBmi(30), BmiCategory.obese);
    });

    test('a value above 30.0 is obese', () {
      expect(BmiCategory.fromBmi(35), BmiCategory.obese);
    });
  });
}
