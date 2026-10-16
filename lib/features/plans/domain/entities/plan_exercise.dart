/// One exercise inside a workout plan's `details.exercises` list.
class PlanExercise {
  final String name;
  final String? sets;
  final String? reps;
  final String repsType;
  final String? description;
  final List<String> instructions;
  final String? videoUrl;

  const PlanExercise({
    required this.name,
    this.sets,
    this.reps,
    this.repsType = '',
    this.description,
    this.instructions = const [],
    this.videoUrl,
  });

  factory PlanExercise.fromMap(Map<String, dynamic> map) {
    final rawInstructions = map['instructions'];
    final List<String> instructions;
    if (rawInstructions is List) {
      instructions = rawInstructions
          .whereType<Map<String, dynamic>>()
          .map((e) => e['text']?.toString() ?? '')
          .where((text) => text.isNotEmpty)
          .toList();
    } else if (rawInstructions is String && rawInstructions.isNotEmpty) {
      instructions = [rawInstructions];
    } else {
      instructions = const [];
    }

    String? nonEmpty(Object? value) {
      final text = value?.toString().trim();
      return text == null || text.isEmpty ? null : text;
    }

    return PlanExercise(
      name: nonEmpty(map['name']) ?? 'Unnamed',
      sets: nonEmpty(map['sets']),
      reps: nonEmpty(map['reps']),
      repsType: nonEmpty(map['repsType']) ?? '',
      description: nonEmpty(map['description']),
      instructions: instructions,
      videoUrl: nonEmpty(map['videoUrl']),
    );
  }

  /// e.g. "3 × 12 reps", "12 reps", "3 sets"; empty when neither is set.
  String get setsReps {
    final repsText = reps == null
        ? null
        : repsType.isEmpty
        ? reps!
        : '$reps $repsType';
    if (sets != null && repsText != null) return '$sets × $repsText';
    if (repsText != null) return repsText;
    if (sets != null) return '$sets sets';
    return '';
  }

  bool get hasDetails => description != null || instructions.isNotEmpty;
}
