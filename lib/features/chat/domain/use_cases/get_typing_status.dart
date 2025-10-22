

import '../repositories/typing_status_repository.dart';

class GetTypingStatus {
  final TypingStatusRepository repository;

  GetTypingStatus(this.repository);

  Stream<bool> call(String chatId, String userId) {
    return repository.getTypingStatus(chatId, userId);
  }
}