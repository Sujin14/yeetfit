/// Completion bucket for a tracked metric; the UI maps it to a color.
enum ProgressLevel {
  none,
  quarter,
  half,
  threeQuarter,
  full;

  /// Buckets [ratio] (consumed / goal, where 1.0 means the goal was met).
  static ProgressLevel fromRatio(double ratio) {
    if (ratio >= 1.0) return full;
    if (ratio >= 0.75) return threeQuarter;
    if (ratio >= 0.5) return half;
    if (ratio >= 0.25) return quarter;
    return none;
  }
}
