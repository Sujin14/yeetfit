import '../../data/model/message_model.dart';
import '../repositories/message_repository.dart';

class SendMessage {
  final MessageRepository repository;

  SendMessage(this.repository);

  Future<void> call(String chatId, MessageModel message) {
    return repository.sendMessage(chatId, message);
  }
}
