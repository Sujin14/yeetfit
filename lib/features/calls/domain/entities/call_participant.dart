/// One side of a call, as shown to the other side.
class CallParticipant {
  final String id;
  final String name;
  final String photoUrl;

  const CallParticipant({
    required this.id,
    required this.name,
    this.photoUrl = '',
  });
}
