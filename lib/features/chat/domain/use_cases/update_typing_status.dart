import '../repositories/typing_status_repository.dart';

class UpdateTypingStatus {
  final TypingStatusRepository repository;

  UpdateTypingStatus(this.repository);

  Future<void> call(String chatId, String userId, bool isTyping) {
    return repository.updateTypingStatus(chatId, userId, isTyping);
  }
}