import '../../domain/entities/water_data.dart';

// Firestore representation of [WaterData].
class WaterModel extends WaterData {
  const WaterModel({
    required super.date,
    required super.glassesConsumed,
    required super.goalGlasses,
  });

  // Creates from Firestore map.
  factory WaterModel.fromMap(Map<String, dynamic> map) {
    return WaterModel(
      date: map['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      glassesConsumed: map['glassesConsumed'] ?? 0,
      goalGlasses: map['goalGlasses'] ?? 8,
    );
  }
}
