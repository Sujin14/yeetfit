import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/steps_model.dart';

// Data source for steps tracking with Firestore and local offline support.
class StepsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _localStepsKey = 'last_steps_data';

  // Fetches steps data for a date (Firestore + local fallback).
  Future<StepsData?> getStepsData(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .doc(date);

    try {
      final doc = await docRef.get();
      if (doc.exists) {
        return StepsData.fromMap(doc.data()!);
      }
    } catch (e) {
      // Fall through to local on Firestore error
    }

    final prefs = await SharedPreferences.getInstance();
    final localData = prefs.getString('$_localStepsKey$userId$date');
    if (localData != null) {
      try {
        return StepsData.fromMap(
          Map<String, dynamic>.from(json.decode(localData)),
        );
      } catch (_) {
        // Ignore parse errors
      }
    }
    return null;
  }

  // Fetches steps goal for a date (Firestore + local fallback).
  Future<int> getStepsGoal(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .doc(date);

    try {
      final doc = await docRef.get();
      if (doc.exists) {
        return (doc.data()?['goalSteps'] as num?)?.toInt() ?? 10000;
      }
    } catch (e) {
      // Fall through to local
    }

    final prefs = await SharedPreferences.getInstance();
    final localData = prefs.getString('$_localStepsKey$userId$date');
    if (localData != null) {
      try {
        final map = Map<String, dynamic>.from(json.decode(localData));
        return (map['goalSteps'] as num?)?.toInt() ?? 10000;
      } catch (_) {
        // Ignore
      }
    }
    return 10000;
  }

  // Adds or updates steps entry (Firestore + local).
  Future<void> addStepsEntry(
    String userId,
    String date,
    int steps,
    int goalSteps,
    double caloriesBurned,
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .doc(date);

    final firestoreData = {
      'date': date,
      'steps': steps,
      'goalSteps': goalSteps,
      'caloriesBurned': caloriesBurned,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    };

    final localData = {
      'date': date,
      'steps': steps,
      'goalSteps': goalSteps,
      'caloriesBurned': caloriesBurned,
    };

    try {
      await docRef.set(firestoreData, SetOptions(merge: true));
    } catch (e) {
      // Firestore fail—local only
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_localStepsKey$userId$date',
      json.encode(localData),
    );
  }

  // Fetches weekly steps data (Firestore + local supplement).
  Future<List<StepsData>> getWeeklyStepsData(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final queryStartDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final queryEndDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
    );
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(queryStartDate),
        )
        .where(
          'timestamp',
          isLessThanOrEqualTo: Timestamp.fromDate(queryEndDate),
        )
        .get();

    final firestoreData = querySnapshot.docs
        .map((doc) => StepsData.fromMap(doc.data()))
        .toList();

    final prefs = await SharedPreferences.getInstance();
    final localData = <StepsData>[];
    for (
      var date = queryStartDate;
      date.isBefore(queryEndDate.add(const Duration(days: 1)));
      date = date.add(const Duration(days: 1))
    ) {
      final dateString = date.toIso8601String().split('T')[0];
      final localKey = '$_localStepsKey$userId$dateString';
      final localString = prefs.getString(localKey);
      if (localString != null &&
          !firestoreData.any((d) => d.date == dateString)) {
        try {
          final map = Map<String, dynamic>.from(json.decode(localString));
          localData.add(StepsData.fromMap(map));
        } catch (_) {
          // Ignore
        }
      }
    }

    final allData = [...firestoreData, ...localData];
    allData.sort((a, b) => a.date.compareTo(b.date));
    return allData;
  }

  // Syncs local data to Firestore.
  Future<void> syncLocalData(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where((key) => key.startsWith('$_localStepsKey$userId'))
        .toList();
    for (var key in keys) {
      final localData = prefs.getString(key);
      if (localData != null) {
        try {
          final map = Map<String, dynamic>.from(json.decode(localData));
          final date = map['date'] as String;
          map['timestamp'] = Timestamp.fromDate(
            DateTime.parse('$date 00:00:00'),
          );
          final docRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('progress')
              .doc('steps')
              .collection('steps')
              .doc(date);
          await docRef.set(map, SetOptions(merge: true));
          await prefs.remove(key);
        } catch (_) {}
      }
    }
  }
}
