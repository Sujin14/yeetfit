enum WorkoutType {
  gym('gym', 'Gym'),
  running('running', 'Running'),
  cycling('cycling', 'Cycling'),
  yoga('yoga', 'Yoga'),
  swimming('swimming', 'Swimming'),
  homeWorkout('home_workout', 'Home Workout'),
  sports('sports', 'Sports'),
  other('other', 'Other');

  const WorkoutType(this.value, this.label);

  /// Stored in Firestore.
  final String value;
  final String label;

  static WorkoutType fromValue(String? value) => WorkoutType.values.firstWhere(
    (type) => type.value == value,
    orElse: () => WorkoutType.other,
  );
}
