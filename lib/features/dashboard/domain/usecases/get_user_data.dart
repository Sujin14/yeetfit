// lib/features/dashboard/domain/usecases/get_user_data.dart
import '../repositories/user_repository.dart';

class GetUserData {
  final UserRepository repository;
  GetUserData(this.repository);
  Future<Map<String, dynamic>?> call(String userId) async => await repository.getUserData(userId);
}