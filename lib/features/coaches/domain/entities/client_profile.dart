/// The signed-in client's `clients/{uid}` document. The coach app writes
/// [trainingDays]; this app only reads them.
class ClientProfile {
  /// Assigned coach, or null when none is set.
  final String? currentCoachId;

  /// Weekdays the client trains: 1 = Monday … 7 = Sunday.
  final List<int> trainingDays;

  const ClientProfile({this.currentCoachId, this.trainingDays = const []});

  factory ClientProfile.fromMap(Map<String, dynamic> map) {
    final coachId = map['currentCoachId'];
    return ClientProfile(
      currentCoachId: coachId is String && coachId.isNotEmpty ? coachId : null,
      trainingDays: List<int>.from(map['trainingDays'] ?? const []),
    );
  }

  ClientProfile copyWith({String? currentCoachId, List<int>? trainingDays}) {
    return ClientProfile(
      currentCoachId: currentCoachId ?? this.currentCoachId,
      trainingDays: trainingDays ?? this.trainingDays,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClientProfile &&
        other.currentCoachId == currentCoachId &&
        _sameDays(other.trainingDays, trainingDays);
  }

  @override
  int get hashCode => Object.hash(currentCoachId, Object.hashAll(trainingDays));
}

bool _sameDays(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
