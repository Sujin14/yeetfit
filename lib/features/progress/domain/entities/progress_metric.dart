/// Metric shown on the Progress calendar. [all] averages the fitness metrics
/// (steps, water, sleep, calories); mood is tracked separately.
enum ProgressMetric {
  all('All'),
  steps('Steps'),
  water('Water'),
  sleep('Sleep'),
  calories('Calories'),
  mood('Mood');

  const ProgressMetric(this.label);
  final String label;

  static const List<ProgressMetric> fitness = [steps, water, sleep, calories];
}
