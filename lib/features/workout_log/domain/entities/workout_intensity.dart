enum WorkoutIntensity {
  light('light', 'Light'),
  moderate('moderate', 'Moderate'),
  intense('intense', 'Intense');

  const WorkoutIntensity(this.value, this.label);

  /// Stored in Firestore.
  final String value;
  final String label;

  static WorkoutIntensity fromValue(String? value) =>
      WorkoutIntensity.values.firstWhere(
        (intensity) => intensity.value == value,
        orElse: () => WorkoutIntensity.moderate,
      );
}
