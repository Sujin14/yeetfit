import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

IconData challengeMetricIcon(String metric) => switch (metric) {
  'steps' => Icons.directions_walk_rounded,
  'water' => Icons.water_drop_outlined,
  'sleep' => Icons.bedtime_outlined,
  'calories' => Icons.local_fire_department_outlined,
  _ => Icons.emoji_events_outlined,
};

Color challengeMetricColor(String metric, AppColors colors) => switch (metric) {
  'steps' => colors.primary,
  'water' => colors.secondary,
  'sleep' => colors.primaryVariant,
  'calories' => colors.fat,
  _ => colors.warning,
};

String challengeMetricUnit(String metric) => switch (metric) {
  'steps' => 'steps',
  'water' => 'glasses',
  'sleep' => 'hours',
  'calories' => 'kcal',
  _ => '',
};

String challengeMetricLabel(String metric) => switch (metric) {
  'steps' => 'Steps',
  'water' => 'Water',
  'sleep' => 'Sleep',
  'calories' => 'Calories',
  _ => 'Activity',
};

/// Sleep keeps one decimal (7.5 h); other metrics are whole numbers.
String formatChallengeValue(double value, String metric) {
  if (metric == 'sleep') return value.toStringAsFixed(1);
  return NumberFormat.decimalPattern().format(value.round());
}
