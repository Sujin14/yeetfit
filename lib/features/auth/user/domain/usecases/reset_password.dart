import '../../login/domain/repositories/auth_repository.dart';

class SendPasswordResetEmail {
  final AuthRepository repository;
  SendPasswordResetEmail(this.repository);

  Future<void> call(String email) {
    return repository.sendPasswordResetEmail(email);
  }
}
