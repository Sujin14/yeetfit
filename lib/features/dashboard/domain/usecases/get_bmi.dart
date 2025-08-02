import '../repositories/user_repository.dart';

class GetBMI {
  final UserRepository repository;

  GetBMI(this.repository);

  Future<double> call(String userId, String date) async {
    return await repository.getBMI(userId, date);
  }
}
