import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/mood_entry.dart';

/// Reads and writes `users/{uid}/mood/{date}`.
class MoodDataSource {
  static const int _historyDays = 30;

  final FirebaseFirestore _firestore;

  MoodDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _mood(String userId) =>
      _firestore.collection('users').doc(userId).collection('mood');

  static MoodEntry _fromMap(Map<String, dynamic> map, String date) {
    final timestamp = map['timestamp'];
    return MoodEntry(
      date: date,
      score: ((map['score'] as num?)?.toInt() ?? MoodEntry.minScore).clamp(
        MoodEntry.minScore,
        MoodEntry.maxScore,
      ),
      timestamp: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.parse('$date 00:00:00'),
    );
  }

  /// Replaces any earlier entry for the same day.
  Future<void> saveEntry(String userId, MoodEntry entry) {
    return _mood(userId).doc(entry.date).set({
      'score': entry.score,
      'timestamp': Timestamp.fromDate(entry.timestamp),
    });
  }

  Stream<MoodEntry?> watchEntry(String userId, String date) {
    return _mood(userId).doc(date).snapshots().map((doc) {
      final data = doc.data();
      return data == null ? null : _fromMap(data, date);
    });
  }

  /// Entries from the last 30 days including today, oldest first.
  Stream<List<MoodEntry>> watchLast30Days(String userId) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day - (_historyDays - 1));
    final startKey = start.toIso8601String().split('T')[0];

    return _mood(userId)
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: startKey)
        .orderBy(FieldPath.documentId)
        .snapshots()
        .map(
          (snapshot) => [
            for (final doc in snapshot.docs) _fromMap(doc.data(), doc.id),
          ],
        );
  }
}
