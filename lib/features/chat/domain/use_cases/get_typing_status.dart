
import '../repositories/chat_repository.dart';

class GetTypingStatus {
  final ChatRepository repository;

  GetTypingStatus(this.repository);

  Stream<bool> call(String chatId, String userId) {
    return repository.getTypingStatus(chatId, userId);
  }
}