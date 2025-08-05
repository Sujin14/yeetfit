

import '../datasources/chatbot_datasource.dart';
import '../model/chatbot_message_model.dart';

abstract class ChatbotRepository {
  Future<ChatbotMessage> sendMessage(String userId, String message);
  Stream<List<ChatbotMessage>> getMessages(String userId);
}

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotDataSource dataSource;

  ChatbotRepositoryImpl(this.dataSource);

  @override
  Future<ChatbotMessage> sendMessage(String userId, String message) async {
    return await dataSource.sendMessage(userId, message);
  }

  @override
  Stream<List<ChatbotMessage>> getMessages(String userId) {
    return dataSource.getMessages(userId);
  }
}