

import '../../data/model/message_model.dart';
import '../repositories/chat_repository.dart';

class GetChatMessages {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  Stream<List<MessageModel>> call(String chatId) {
    return repository.getChatMessages(chatId);
  }
}