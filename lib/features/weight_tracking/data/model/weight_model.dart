import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/weight_data.dart';

// Firestore representation of [WeightData].
class WeightModel extends WeightData {
  const WeightModel({
    required super.date,
    required super.currentWeight,
    required super.goalWeight,
    required super.initialWeight,
    super.targetDate,
  });

  // Creates from Firestore map.
  factory WeightModel.fromMap(Map<String, dynamic> map) {
    return WeightModel(
      date: map['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      currentWeight: (map['currentWeight'] as num?)?.toDouble() ?? 75.0,
      goalWeight: (map['goalWeight'] as num?)?.toDouble() ?? 70.0,
      initialWeight: (map['initialWeight'] as num?)?.toDouble() ?? 75.0,
      targetDate: (map['targetDate'] as Timestamp?)?.toDate(),
    );
  }
}
