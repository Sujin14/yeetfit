

import '../../domain/repositories/chat_repository.dart';
import '../datasource/firestore_chat_service.dart';
import '../model/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirestoreChatService service;

  ChatRepositoryImpl(this.service);

  @override
  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return service.getChatMessages(chatId);
  }

  @override
  Stream<MessageModel> getMessageStatus(String chatId, String messageId) {
    return service.getMessageStatus(chatId, messageId);
  }

  @override
  Stream<Map<String, dynamic>> getUserProfile(String userId) {
    return service.getUserProfile(userId);
  }

  @override
  Future<void> sendMessage(String chatId, MessageModel message) {
    return service.sendMessage(chatId, message);
  }

  @override
  Future<String> createOrGetChat(
    String adminId,
    String participantId,
    String participantName,
  ) {
    return service.createOrGetChat(adminId, participantId, participantName);
  }

  @override
  Future<void> updateTypingStatus(String chatId, String userId, bool isTyping) {
    return service.updateTypingStatus(chatId, userId, isTyping);
  }

  @override
  Stream<bool> getTypingStatus(String chatId, String userId) {
    return service.getTypingStatus(chatId, userId);
  }

  @override
  Future<void> updateMessageStatus(
    String chatId,
    String messageId,
    String status,
  ) {
    return service.updateMessageStatus(chatId, messageId, status);
  }

  @override
  Future<void> deleteChat(String chatId) {
    return service.deleteChat(chatId);
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) {
    return service.deleteMessage(chatId, messageId);
  }
}