import '../repositories/message_repository.dart';

class DeleteChat {
  final MessageRepository repository;

  DeleteChat(this.repository);

  Future<void> call(String chatId) {
    return repository.deleteChat(chatId);
  }
}
