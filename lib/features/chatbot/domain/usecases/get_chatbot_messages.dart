import '../../data/model/chatbot_message_model.dart';
import '../../data/repositories/chatbot_repository.dart';

class GetChatbotMessages {
  final ChatbotRepository repository;

  GetChatbotMessages(this.repository);

  Stream<List<ChatbotMessage>> call(String userId) {
    return repository.getMessages(userId);
  }
}