import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasource/payment_service.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/update_payment_status.dart';
import '../controllers/payment_controller.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final service = ref.read(paymentServiceProvider);
  return PaymentRepositoryImpl(service);
});

final updatePaymentStatusProvider = Provider<UpdatePaymentStatus>((ref) {
  final repository = ref.read(paymentRepositoryProvider);
  return UpdatePaymentStatus(repository);
});

final createOrderProvider = Provider<CreateOrder>((ref) {
  final repository = ref.read(paymentRepositoryProvider);
  return CreateOrder(repository);
});

final paymentControllerProvider = StateNotifierProvider<PaymentController, PaymentState>((ref) {
  return PaymentController(
    createOrder: ref.read(createOrderProvider),
    updatePaymentStatus: ref.read(updatePaymentStatusProvider),
    ref: ref,
  );
});

final adminIdProvider = FutureProvider<String>((ref) async {
  final doc = await FirebaseFirestore.instance.collection('config').doc('app').get();
  return doc.data()?['adminId'] ?? 'KzWEi9szv2dg9wvEKN6ZEGmZt7L2';
});

final paymentStatusProvider = StreamProvider<bool>((ref) async* {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    yield false;
    return;
  }
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
  yield* userDoc.snapshots().map((snapshot) => snapshot.data()?['hasPaid'] ?? false);
});