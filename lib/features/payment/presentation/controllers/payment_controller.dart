import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../config/razorpay_config.dart';
import '../../data/model/payment_model.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/update_payment_status.dart';

class PaymentState {
  final bool isLoading;
  final String? error;
  final bool success;

  PaymentState({
    this.isLoading = false,
    this.error,
    this.success = false,
  });

  PaymentState copyWith({
    bool? isLoading,
    String? error,
    bool? success,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
    );
  }
}

class PaymentController extends StateNotifier<PaymentState> {
  final CreateOrder createOrder;
  final UpdatePaymentStatus updatePaymentStatus;
  final Ref ref;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Razorpay _razorpay = Razorpay();

  PaymentController({
    required this.createOrder,
    required this.updatePaymentStatus,
    required this.ref,
  }) : super(PaymentState()) {
    _initializeRazorpay();
    _loadUserData();
  }

  void _initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      state = state.copyWith(error: 'User not authenticated');
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? FirebaseAuth.instance.currentUser?.email ?? '';
      }
    } catch (e) {
      print('User data load error: $e');
      state = state.copyWith(error: 'User data load error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    state = state.copyWith(isLoading: true);
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await updatePaymentStatus.call(userId);
      }
      state = state.copyWith(
        isLoading: false,
        error: null,
        success: true,
      );
    } catch (e) {
      print('Payment success handling error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error updating payment status: $e',
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    state = state.copyWith(
      isLoading: false,
      error: 'Payment failed: ${response.message}',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External wallet selected: ${response.walletName}');
  }

  Future<void> startPayment() async {
    if (!formKey.currentState!.validate()) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      state = state.copyWith(error: 'User not authenticated');
      return;
    }
    state = state.copyWith(isLoading: true);
    try {
      final payment = PaymentModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        contact: contactController.text.trim(),
        amount: 50000, // ₹500 in paise
        currency: 'INR',
      );
      final result = await createOrder.call(payment);
      final orderId = result['orderId'];
      _openRazorpaySession(orderId, payment);
    } catch (e) {
      print('Start payment error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error initiating payment: $e',
      );
    }
  }

  void _openRazorpaySession(String orderId, PaymentModel payment) {
    final options = {
      'key': RazorpayConfig.keyId,
      'amount': payment.amount,
      'currency': payment.currency,
      'name': 'YeetFit',
      'description': 'One-time chat access',
      'order_id': orderId,
      'prefill': {
        'name': payment.name,
        'email': payment.email,
        'contact': payment.contact,
      },
      'timeout': 60, // in seconds
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error opening payment session: $e',
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    _razorpay.clear();
    super.dispose();
  }
}