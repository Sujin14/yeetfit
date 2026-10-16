class ChallengeParticipant {
  final String uid;
  final DateTime joinedAt;
  final double currentProgress;
  final bool completed;

  const ChallengeParticipant({
    required this.uid,
    required this.joinedAt,
    required this.currentProgress,
    required this.completed,
  });
}
