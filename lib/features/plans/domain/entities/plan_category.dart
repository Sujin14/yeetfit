/// Explore filter buckets. [all] is the "no filter" option; [nutrition] holds
/// diet plans, which have no workout category.
enum PlanCategory {
  all('All'),
  strength('Strength'),
  cardio('Cardio'),
  flexibility('Flexibility'),
  hiit('HIIT'),
  recovery('Recovery'),
  nutrition('Nutrition');

  final String label;

  const PlanCategory(this.label);

  /// Matches a stored category value case-insensitively by name or label.
  /// Returns null for missing or unknown values; [all] is never returned.
  static PlanCategory? fromValue(String? raw) {
    final value = raw?.trim().toLowerCase();
    if (value == null || value.isEmpty) return null;
    for (final category in values) {
      if (category == all) continue;
      if (category.name == value || category.label.toLowerCase() == value) {
        return category;
      }
    }
    return null;
  }
}
