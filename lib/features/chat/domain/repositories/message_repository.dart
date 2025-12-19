import '../../data/model/message_model.dart';

abstract class MessageRepository {
  Stream<List<MessageModel>> getChatMessages(String chatId);
  Stream<MessageModel> getMessageStatus(String chatId, String messageId);
  Future<void> updateMessageStatus(String chatId, String messageId, String status);
  Future<void> sendMessage(String chatId, MessageModel message);
  Future<void> deleteMessage(String chatId, String messageId);
  Future<String> createOrGetChat(String adminId, String participantId, String participantName);
  Future<void> deleteChat(String chatId);
}