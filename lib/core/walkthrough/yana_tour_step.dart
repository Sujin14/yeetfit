import 'package:flutter/widgets.dart';

/// One showcased widget in a Yana tour.
class YanaTourStep {
  final GlobalKey key;
  final String message;
  final int number;
  final int total;

  const YanaTourStep({
    required this.key,
    required this.message,
    required this.number,
    required this.total,
  });

  bool get isLast => number == total;
}
