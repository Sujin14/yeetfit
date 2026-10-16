import '../entities/coach.dart';

abstract class CoachRepository {
  /// Coaches with `isActive == true` and a complete profile, sorted by name.
  /// Emits again whenever a coach is added, removed or (de)activated.
  Stream<List<Coach>> watchActiveCoaches();

  /// The coach's profile, or `null` when it no longer exists.
  Future<Coach?> getCoach(String coachId);

  /// The client's assigned coach from `clients/{uid}`, or `null` when none
  /// is assigned or the client doc doesn't exist yet.
  Stream<String?> watchCurrentCoachId(String clientUid);

  /// Whether the client has a pending request to this coach.
  Stream<bool> watchHasPendingRequest({
    required String clientUid,
    required String coachId,
  });

  /// Creates a pending coaching request, or re-opens a previously declined
  /// or ended one. Throws [CoachRequestException] if the coach already
  /// accepted.
  Future<void> requestCoach({
    required String clientUid,
    required String coachId,
  });

  /// Removes the signed-in client's current coach. Throws
  /// [CoachRemovalException] on failure.
  Future<void> removeCoach();
}

class CoachRequestException implements Exception {
  final String message;

  const CoachRequestException(this.message);

  @override
  String toString() => message;
}

class CoachRemovalException implements Exception {
  final String message;

  const CoachRemovalException(this.message);

  @override
  String toString() => message;
}
