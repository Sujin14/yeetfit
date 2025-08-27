import '../../data/model/chatbot_message_model.dart';
import '../../data/repositories/chatbot_repository.dart';

class SendChatbotMessage {
  final ChatbotRepository repository;

  SendChatbotMessage(this.repository);

  Future<ChatbotMessage> call(String userId, String message) async {
    return await repository.sendMessage(userId, message);
  }
}
