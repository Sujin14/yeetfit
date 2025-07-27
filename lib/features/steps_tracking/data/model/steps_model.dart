import 'package:cloud_firestore/cloud_firestore.dart';

class StepsData {
  final String date;
  final int steps;
  final int goalSteps;
  final double caloriesBurned;

  StepsData({
    required this.date,
    required this.steps,
    required this.goalSteps,
    required this.caloriesBurned,
  });

  factory StepsData.fromMap(Map<String, dynamic> map) {
    return StepsData(
      date: map['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      steps: (map['steps'] as num?)?.toInt() ?? 0,
      goalSteps: (map['goalSteps'] as num?)?.toInt() ?? 10000,
      caloriesBurned: (map['caloriesBurned'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'steps': steps,
      'goalSteps': goalSteps,
      'caloriesBurned': caloriesBurned,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    };
  }
}