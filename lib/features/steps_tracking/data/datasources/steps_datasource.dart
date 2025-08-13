import 'dart:convert' show json;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/steps_model.dart';

class StepsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _localStepsKey = 'last_steps_data';

  Future<StepsData?> getStepsData(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .doc(date);

    final doc = await docRef.get();
    if (doc.exists) {
      return StepsData.fromMap(doc.data()!);
    }
    final prefs = await SharedPreferences.getInstance();
    final localData = prefs.getString('$_localStepsKey$userId$date');
    if (localData != null) {
      try {
        return StepsData.fromMap(
          Map<String, dynamic>.from(json.decode(localData)),
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<int> getStepsGoal(String userId, String date) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .doc(date);

    final doc = await docRef.get();
    if (doc.exists) {
      return (doc.data()!['goalSteps'] as num?)?.toInt() ?? 10000;
    }
    // Check local storage
    final prefs = await SharedPreferences.getInstance();
    final localData = prefs.getString('$_localStepsKey$userId$date');
    if (localData != null) {
      try {
        final map = Map<String, dynamic>.from(json.decode(localData));
        return (map['goalSteps'] as num?)?.toInt() ?? 10000;
      } catch (_) {
        return 10000;
      }
    }
    return 10000;
  }

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

    // Data for Firestore (includes timestamp)
    final firestoreData = {
      'date': date,
      'steps': steps,
      'goalSteps': goalSteps,
      'caloriesBurned': caloriesBurned,
      'timestamp': Timestamp.fromDate(DateTime.parse('$date 00:00:00')),
    };

    // Data for SharedPreferences (excludes timestamp)
    final localData = {
      'date': date,
      'steps': steps,
      'goalSteps': goalSteps,
      'caloriesBurned': caloriesBurned,
    };

    // Save to Firestore (offline support handles no internet)
    await docRef.set(firestoreData, SetOptions(merge: true));

    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_localStepsKey$userId$date', json.encode(localData));
  }

  Future<List<StepsData>> getWeeklyStepsData(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('steps')
        .collection('steps')
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    final firestoreData = querySnapshot.docs
        .map((doc) => StepsData.fromMap(doc.data()))
        .toList();

    // Supplement with local data if needed
    final prefs = await SharedPreferences.getInstance();
    final localData = <StepsData>[];
    for (
      var date = startDate;
      date.isBefore(endDate.add(const Duration(days: 1)));
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
        } catch (_) {}
      }
    }

    final allData = [...firestoreData, ...localData];
    allData.sort((a, b) => a.date.compareTo(b.date));
    return allData;
  }

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
          // Add timestamp for Firestore
          map['timestamp'] = Timestamp.fromDate(DateTime.parse('$date 00:00:00'));
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