/// A group training session hosted by a coach on Google Meet
/// (`sessions/{id}`).
class TrainingSession {
  final String id;
  final String title;
  final String description;
  final String trainerId;
  final String trainerName;
  final String trainerPhoto;
  final String meetLink;
  final DateTime scheduledAt;
  final int durationMinutes;
  final bool isGlobal;
  final List<String> assignedClientUids;

  const TrainingSession({
    required this.id,
    required this.title,
    required this.description,
    required this.trainerId,
    required this.trainerName,
    required this.trainerPhoto,
    required this.meetLink,
    required this.scheduledAt,
    required this.durationMinutes,
    this.isGlobal = false,
    this.assignedClientUids = const [],
  });

  DateTime get endsAt => scheduledAt.add(Duration(minutes: durationMinutes));

  bool get isUpcoming => isUpcomingAt(DateTime.now());

  bool get isLive => isLiveAt(DateTime.now());

  bool isUpcomingAt(DateTime now) => now.isBefore(scheduledAt);

  bool isLiveAt(DateTime now) =>
      !now.isBefore(scheduledAt) && now.isBefore(endsAt);
}
