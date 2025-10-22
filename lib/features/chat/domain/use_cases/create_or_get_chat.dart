import '../repositories/message_repository.dart';

class CreateOrGetChat {
  final MessageRepository repository;

  CreateOrGetChat(this.repository);

  Future<String> call(
    String adminId,
    String participantId,
    String participantName,
  ) {
    return repository.createOrGetChat(adminId, participantId, participantName);
  }
}
