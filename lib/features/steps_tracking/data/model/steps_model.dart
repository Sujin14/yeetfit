import '../../domain/entities/steps_data.dart';

// Firestore / local-cache representation of [StepsData].
class StepsModel extends StepsData {
  const StepsModel({
    required super.date,
    required super.steps,
    required super.goalSteps,
    required super.caloriesBurned,
  });

  // Creates from map (Firestore or local).
  factory StepsModel.fromMap(Map<String, dynamic> map) {
    return StepsModel(
      date: map['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      steps: (map['steps'] as num?)?.toInt() ?? 0,
      goalSteps: (map['goalSteps'] as num?)?.toInt() ?? 1000,
      caloriesBurned: (map['caloriesBurned'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
