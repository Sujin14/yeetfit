import '../../data/model/message_model.dart';
import '../repositories/message_repository.dart';

class GetChatMessages {
  final MessageRepository repository;

  GetChatMessages(this.repository);

  Stream<List<MessageModel>> call(String chatId) {
    return repository.getChatMessages(chatId);
  }
}