import '../../domain/repositories/payment_repository.dart';
import '../datasource/payment_service.dart';
import '../model/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentService service;

  PaymentRepositoryImpl(this.service);

  @override
  Future<void> updatePaymentStatus(String userId) {
    return service.updatePaymentStatus(userId);
  }

  @override
  Future<Map<String, dynamic>> createOrder(PaymentModel payment) {
    return service.createOrder(payment.toMap());
  }
}