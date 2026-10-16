import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/sleep_data.dart';

// Firestore representation of [SleepData].
class SleepModel extends SleepData {
  const SleepModel({
    required super.date,
    super.bedtime,
    super.wakeUpTime,
    required super.duration,
    required super.goalHours,
  });

  // Creates from Firestore map.
  factory SleepModel.fromMap(Map<String, dynamic> map) {
    return SleepModel(
      date: map['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      bedtime: (map['bedtime'] as Timestamp?)?.toDate(),
      wakeUpTime: (map['wakeUpTime'] as Timestamp?)?.toDate(),
      duration: (map['duration'] as num?)?.toDouble() ?? 0.0,
      goalHours: (map['goalHours'] as num?)?.toDouble() ?? 8.0,
    );
  }
}
