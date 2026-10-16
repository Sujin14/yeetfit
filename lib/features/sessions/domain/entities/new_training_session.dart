/// What a coach fills in to schedule a session; the trainer's name and photo
/// are added from their profile.
class NewTrainingSession {
  final String title;
  final String description;
  final String meetLink;
  final DateTime scheduledAt;
  final int durationMinutes;

  const NewTrainingSession({
    required this.title,
    required this.description,
    required this.meetLink,
    required this.scheduledAt,
    required this.durationMinutes,
  });
}
