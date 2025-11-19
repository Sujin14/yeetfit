import 'package:cloud_firestore/cloud_firestore.dart';

class WeightData {
  final String date;
  final double currentWeight;
  final double goalWeight;
  final double initialWeight;
  final DateTime? targetDate;

  WeightData({
    required this.date,
    required this.currentWeight,
    required this.goalWeight,
    required this.initialWeight,
    this.targetDate,
  });

  factory WeightData.fromMap(Map<String, dynamic> map) {
    return WeightData(
      date: map['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      currentWeight: (map['currentWeight'] as num?)?.toDouble() ?? 77.0,
      goalWeight: (map['goalWeight'] as num?)?.toDouble() ?? 70.0,
      initialWeight: (map['initialWeight'] as num?)?.toDouble() ?? 75.0,
      targetDate: map['targetDate'] != null ? (map['targetDate'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'initialWeight': initialWeight,
      'targetDate': targetDate != null ? Timestamp.fromDate(targetDate!) : null,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    };
  }
}