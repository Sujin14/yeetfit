import 'package:cloud_firestore/cloud_firestore.dart';

// Model for sleep data entries and goals.
class SleepData {
  final String date;
  final DateTime? bedtime;
  final DateTime? wakeUpTime;
  final double duration; // in hours
  final double goalHours; // in hours

  SleepData({
    required this.date,
    this.bedtime,
    this.wakeUpTime,
    required this.duration,
    required this.goalHours,
  });

  // Creates from Firestore map.
  factory SleepData.fromMap(Map<String, dynamic> map) {
    return SleepData(
      date: map['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      bedtime: map['bedtime'] != null ? (map['bedtime'] as Timestamp).toDate() : null,
      wakeUpTime: map['wakeUpTime'] != null ? (map['wakeUpTime'] as Timestamp).toDate() : null,
      duration: (map['duration'] as num?)?.toDouble() ?? 0.0,
      goalHours: (map['goalHours'] as num?)?.toDouble() ?? 8.0,
    );
  }

  // Converts to Firestore map.
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'bedtime': bedtime != null ? Timestamp.fromDate(bedtime!) : null,
      'wakeUpTime': wakeUpTime != null ? Timestamp.fromDate(wakeUpTime!) : null,
      'duration': duration,
      'goalHours': goalHours,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    };
  }
}