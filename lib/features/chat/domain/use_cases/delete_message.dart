import '../repositories/chat_repository.dart';

class DeleteMessage {
  final ChatRepository repository;

  DeleteMessage(this.repository);

  Future<void> call(String chatId, String messageId) {
    return repository.deleteMessage(chatId, messageId);
  }
}
