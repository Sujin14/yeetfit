
import '../../data/model/message_model.dart';

abstract class ChatRepository {
  Stream<List<MessageModel>> getChatMessages(String chatId);
  Stream<MessageModel> getMessageStatus(String chatId, String messageId);
  Stream<Map<String, dynamic>> getUserProfile(String userId);
  Future<void> sendMessage(String chatId, MessageModel message);
  Future<String> createOrGetChat(String adminId, String participantId, String participantName);
  Future<void> updateTypingStatus(String chatId, String userId, bool isTyping);
  Stream<bool> getTypingStatus(String chatId, String userId);
  Future<void> updateMessageStatus(String chatId, String messageId, String status);
  Future<void> deleteChat(String chatId);
  Future<void> deleteMessage(String chatId, String messageId);
}