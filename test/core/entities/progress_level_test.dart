import 'package:flutter_test/flutter_test.dart';
import 'package:yeetfit/core/entities/progress_level.dart';

void main() {
  group('ProgressLevel.fromRatio', () {
    test('below 0.25 is none', () {
      expect(ProgressLevel.fromRatio(0), ProgressLevel.none);
      expect(ProgressLevel.fromRatio(0.24), ProgressLevel.none);
    });

    test('0.25 up to but not including 0.5 is quarter', () {
      expect(ProgressLevel.fromRatio(0.25), ProgressLevel.quarter);
      expect(ProgressLevel.fromRatio(0.49), ProgressLevel.quarter);
    });

    test('0.5 up to but not including 0.75 is half', () {
      expect(ProgressLevel.fromRatio(0.5), ProgressLevel.half);
      expect(ProgressLevel.fromRatio(0.74), ProgressLevel.half);
    });

    test('0.75 up to but not including 1.0 is threeQuarter', () {
      expect(ProgressLevel.fromRatio(0.75), ProgressLevel.threeQuarter);
      expect(ProgressLevel.fromRatio(0.99), ProgressLevel.threeQuarter);
    });

    test('1.0 and above is full', () {
      expect(ProgressLevel.fromRatio(1), ProgressLevel.full);
      expect(ProgressLevel.fromRatio(1.5), ProgressLevel.full);
    });
  });
}
