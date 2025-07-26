import '../repositories/chat_repository.dart';

class CreateOrGetChat {
  final ChatRepository repository;

  CreateOrGetChat(this.repository);

  Future<String> call(
    String adminId,
    String participantId,
    String participantName,
  ) {
    return repository.createOrGetChat(adminId, participantId, participantName);
  }
}