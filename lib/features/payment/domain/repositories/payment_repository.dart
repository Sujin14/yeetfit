import '../../data/model/payment_model.dart';

abstract class PaymentRepository {
  Future<void> updatePaymentStatus(String userId);
  Future<Map<String, dynamic>> verifyPayment(
    String paymentId,
    String orderId,
    String signature,
  );
  Future<Map<String, dynamic>> createOrder(PaymentModel payment);
}
