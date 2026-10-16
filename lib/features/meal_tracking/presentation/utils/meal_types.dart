const mealTypes = [
  'Breakfast',
  'Morning Snack',
  'Lunch',
  'Evening Snack',
  'Dinner',
];

/// Best-guess meal slot for something eaten at [time].
String mealTypeForTime(DateTime time) {
  final hour = time.hour;
  if (hour < 10) return 'Breakfast';
  if (hour < 12) return 'Morning Snack';
  if (hour < 15) return 'Lunch';
  if (hour < 18) return 'Evening Snack';
  return 'Dinner';
}
