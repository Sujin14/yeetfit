// lib/features/dashboard/domain/usecases/get_bmi.dart
import '../repositories/user_repository.dart';

class GetBMI {
  final UserRepository repository;
  GetBMI(this.repository);
  Future<double> call(String userId, String date) async =>
      await repository.getBMI(userId, date);
}
