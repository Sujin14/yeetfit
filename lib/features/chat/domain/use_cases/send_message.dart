import '../../data/model/message_model.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call(String chatId, MessageModel message) {
    return repository.sendMessage(chatId, message);
  }
}
