
import '../repositories/payment_repository.dart';

class UpdatePaymentStatus {
  final PaymentRepository repository;

  UpdatePaymentStatus(this.repository);

  Future<void> call(String userId) {
    return repository.updatePaymentStatus(userId);
  }
}