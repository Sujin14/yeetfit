import 'package:cloud_firestore/cloud_firestore.dart';

class WaterData {
  final String date;
  final int glassesConsumed;
  final int goalGlasses;

  WaterData({
    required this.date,
    required this.glassesConsumed,
    required this.goalGlasses,
  });

  factory WaterData.fromMap(Map<String, dynamic> map) {
    return WaterData(
      date: map['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      glassesConsumed: map['glassesConsumed'] ?? 0,
      goalGlasses: map['goalGlasses'] ?? 8,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'glassesConsumed': glassesConsumed,
      'goalGlasses': goalGlasses,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    };
  }
}