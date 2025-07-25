import '../repositories/chat_repository.dart';

class UpdateTypingStatus {
  final ChatRepository repository;

  UpdateTypingStatus(this.repository);

  Future<void> call(String chatId, String userId, bool isTyping) {
    return repository.updateTypingStatus(chatId, userId, isTyping);
  }
}
