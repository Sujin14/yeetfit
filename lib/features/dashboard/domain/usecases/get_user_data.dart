import '../repositories/user_repository.dart';

class GetUserData {
  final UserRepository repository;

  GetUserData(this.repository);

  Future<Map<String, dynamic>?> call(String userId) async {
    return await repository.getUserData(userId);
  }
}
