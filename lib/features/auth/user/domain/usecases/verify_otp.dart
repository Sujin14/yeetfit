import '../../login/domain/repositories/auth_repository.dart';

class VerifyOTP {
  final AuthRepository repository;
  VerifyOTP(this.repository);

  Future<bool> call(String verificationId, String otp) async {
    final result = await repository.signInWithOTP(
      verificationId: verificationId,
      smsCode: otp,
    );
    return result != null;
  }
}
