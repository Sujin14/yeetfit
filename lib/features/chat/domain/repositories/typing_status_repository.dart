abstract class TypingStatusRepository {
  Future<void> updateTypingStatus(String chatId, String userId, bool isTyping);
  Stream<bool> getTypingStatus(String chatId, String userId);
}