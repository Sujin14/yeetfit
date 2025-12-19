import '../repositories/message_repository.dart';

class DeleteMessage {
  final MessageRepository repository;

  DeleteMessage(this.repository);

  Future<void> call(String chatId, String messageId) {
    return repository.deleteMessage(chatId, messageId);
  }
}
