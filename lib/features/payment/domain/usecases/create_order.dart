

import '../../data/model/payment_model.dart';
import '../repositories/payment_repository.dart';

class CreateOrder {
  final PaymentRepository repository;

  CreateOrder(this.repository);

  Future<Map<String, dynamic>> call(PaymentModel payment) {
    return repository.createOrder(payment);
  }
}