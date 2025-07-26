import '../repositories/payment_repository.dart';

class VerifyPayment {
  final PaymentRepository repository;

  VerifyPayment(this.repository);

  Future<Map<String, dynamic>> call(
    String paymentId,
    String orderId,
    String signature,
  ) {
    return repository.verifyPayment(paymentId, orderId, signature);
  }
}
