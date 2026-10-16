import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yeetfit/core/services/streak_service.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/entities/challenge_participant.dart';

class ChallengeDataSource {
  static const int _leaderboardSize = 10;

  final FirebaseFirestore _firestore;

  ChallengeDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _challenges =>
      _firestore.collection('challenges');

  DocumentReference<Map<String, dynamic>> _participant(
    String challengeId,
    String userId,
  ) => _challenges.doc(challengeId).collection('participants').doc(userId);

  static DateTime? _toDate(Object? value) =>
      value is Timestamp ? value.toDate() : null;

  // Challenges are created by hand in the Firebase Console, so every field is
  // read defensively.
  static Challenge _challengeFromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? const <String, dynamic>{};
    final startDate = _toDate(data['startDate']) ?? DateTime.now();
    final durationDays = (data['durationDays'] as num?)?.toInt() ?? 0;
    return Challenge(
      id: doc.id,
      title: data['title'] as String? ?? 'Challenge',
      description: data['description'] as String? ?? '',
      metric: data['metric'] as String? ?? '',
      goal: (data['goal'] as num?)?.toDouble() ?? 0,
      durationDays: durationDays,
      startDate: startDate,
      endDate:
          _toDate(data['endDate']) ??
          startDate.add(Duration(days: durationDays)),
      participantCount: (data['participantCount'] as num?)?.toInt() ?? 0,
    );
  }

  static ChallengeParticipant _participantFromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? const <String, dynamic>{};
    return ChallengeParticipant(
      uid: doc.id,
      // serverTimestamp() reads back as null until the write is acknowledged.
      joinedAt: _toDate(data['joinedAt']) ?? DateTime.now(),
      currentProgress: (data['currentProgress'] as num?)?.toDouble() ?? 0,
      completed: data['completed'] as bool? ?? false,
    );
  }

  /// Challenges that have started and not yet ended. Only endDate is queried
  /// so the single-field index is enough; the start date is filtered
  /// client-side.
  Stream<List<Challenge>> watchActiveChallenges() {
    return _challenges
        .where(
          'endDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()),
        )
        .orderBy('endDate')
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now();
          return snapshot.docs
              .map(_challengeFromDoc)
              .where((challenge) => !challenge.startDate.isAfter(now))
              .toList();
        });
  }

  /// `null` when the challenge no longer exists.
  Future<Challenge?> getChallenge(String challengeId) async {
    final doc = await _challenges.doc(challengeId).get();
    return doc.exists ? _challengeFromDoc(doc) : null;
  }

  // The transaction makes join idempotent, so a double tap can't inflate
  // participantCount.
  Future<void> joinChallenge(String challengeId, String userId) async {
    final participantRef = _participant(challengeId, userId);
    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(participantRef);
      if (existing.exists) return;
      transaction.set(participantRef, {
        'joinedAt': FieldValue.serverTimestamp(),
        'currentProgress': 0,
        'completed': false,
      });
      transaction.update(_challenges.doc(challengeId), {
        'participantCount': FieldValue.increment(1),
      });
    });
    StreakService().invalidateChallengeCache(userId);
  }

  /// No-op when the user isn't a participant.
  Future<void> leaveChallenge(String challengeId, String userId) async {
    final participantRef = _participant(challengeId, userId);
    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(participantRef);
      if (!existing.exists) return;
      transaction.delete(participantRef);
      transaction.update(_challenges.doc(challengeId), {
        'participantCount': FieldValue.increment(-1),
      });
    });
    StreakService().invalidateChallengeCache(userId);
  }

  /// Top participants by progress, highest first.
  Stream<List<ChallengeParticipant>> watchLeaderboard(String challengeId) {
    return _challenges
        .doc(challengeId)
        .collection('participants')
        .orderBy('currentProgress', descending: true)
        .limit(_leaderboardSize)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_participantFromDoc).toList());
  }

  /// `null` while the user hasn't joined.
  Stream<ChallengeParticipant?> watchMyProgress(
    String challengeId,
    String userId,
  ) {
    return _participant(
      challengeId,
      userId,
    ).snapshots().map((doc) => doc.exists ? _participantFromDoc(doc) : null);
  }
}
