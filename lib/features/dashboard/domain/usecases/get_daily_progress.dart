import '../repositories/user_repository.dart';

class GetDailyProgress {
  final UserRepository repository;

  GetDailyProgress(this.repository);

  Future<Map<String, dynamic>> call(String userId, String date) async {
    return await repository.getDailyProgress(userId, date);
  }

  Stream<Map<String, dynamic>> stream(String userId, String date) {
    return repository.getDailyProgressStream(userId, date);
  }
}