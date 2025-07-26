import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/model/payment_model.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/update_payment_status.dart';
import '../../domain/usecases/verify_payment.dart';
import '../providers/payment_provider.dart';

class PaymentState {
  final bool isLoading;
  final String? paymentUrl;
  final WebViewController? webViewController;
  final String? error;
  final bool success;

  PaymentState({
    this.isLoading = false,
    this.paymentUrl,
    this.webViewController,
    this.error,
    this.success = false,
  });

  PaymentState copyWith({
    bool? isLoading,
    String? paymentUrl,
    WebViewController? webViewController,
    String? error,
    bool? success,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      webViewController: webViewController ?? this.webViewController,
      error: error,
      success: success ?? this.success,
    );
  }
}

class PaymentController extends StateNotifier<PaymentState> {
  final CreateOrder createOrder;
  final VerifyPayment verifyPayment;
  final UpdatePaymentStatus updatePaymentStatus;
  final Ref ref;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static const _callbackScheme = 'yeetfit://';

  PaymentController({
    required this.createOrder,
    required this.verifyPayment,
    required this.updatePaymentStatus,
    required this.ref,
  }) : super(PaymentState()) {
    _initializeWebView();
    _loadUserData();
  }

  void _initializeWebView() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => state = state.copyWith(isLoading: true),
          onPageFinished: (_) => state = state.copyWith(isLoading: false),
          onNavigationRequest: (req) {
            if (req.url.startsWith(_callbackScheme)) {
              _handleCallback(req.url);
              return NavigationDecision.prevent;
            } else if (req.url.startsWith('upi://')) {
              final uri = Uri.parse(req.url);
              launchUrl(uri, mode: LaunchMode.externalApplication);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (err) {
            state = state.copyWith(
              isLoading: false,
              error: 'Failed to load payment page: ${err.description}',
            );
          },
        ),
      );
    state = state.copyWith(webViewController: controller);
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

  void _handleCallback(String url) {
    final uri = Uri.parse(url);
    if (uri.host == 'success') {
      _verifyPayment(
        uri.queryParameters['payment_id'],
        uri.queryParameters['order_id'],
        uri.queryParameters['signature'],
      );
    } else {
      _handlePaymentFailure();
    }
  }

  Future<void> _verifyPayment(String? paymentId, String? orderId, String? signature) async {
    if (paymentId == null || orderId == null || signature == null) {
      state = state.copyWith(error: 'Missing payment data');
      return;
    }
    state = state.copyWith(isLoading: true);
    try {
      await verifyPayment.call(paymentId, orderId, signature);
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await updatePaymentStatus.call(userId);
      }
      state = state.copyWith(
        isLoading: false,
        paymentUrl: null,
        error: null,
        success: true,
      );
    } catch (e) {
      print('Verify payment error: $e');
      state = state.copyWith(
        isLoading: false,
        paymentUrl: null,
        error: 'Error verifying payment: $e',
      );
    }
  }

  void _handlePaymentFailure() {
    state = state.copyWith(
      isLoading: false,
      paymentUrl: null,
      error: 'Payment failed or cancelled',
    );
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
        amount: 50000,
        currency: 'INR',
      );
      final result = await createOrder.call(payment);
      final orderId = result['orderId'];
      final html = _generateCheckoutHtml(orderId, payment);
      state = state.copyWith(paymentUrl: html, error: null);
      if (state.webViewController != null && state.paymentUrl != null) {
        await state.webViewController!.loadHtmlString(state.paymentUrl!);
      }
    } catch (e) {
      print('Start payment error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error initiating payment: $e',
      );
    }
  }

  String _generateCheckoutHtml(String orderId, PaymentModel payment) {
    final name = Uri.encodeComponent(payment.name);
    final email = Uri.encodeComponent(payment.email);
    final contact = Uri.encodeComponent(payment.contact);
    return '''
<html><body><script src="https://checkout.razorpay.com/v1/checkout.js"></script><script>
var options = {
  key: "rzp_test_vlqwFDG9Y2GUoT",
  amount: "${payment.amount}",
  currency: "${payment.currency}",
  name: "YeetFit",
  description: "One-time chat access",
  order_id: "$orderId",
  handler: function(r){ window.location="${_callbackScheme}success?payment_id="+r.razorpay_payment_id+"&order_id="+r.razorpay_order_id+"&signature="+r.razorpay_signature; },
  modal:{ondismiss:function(){window.location="${_callbackScheme}failure";}},
  prefill:{name:"$name",email:"$email",contact:"$contact"}
};
var rzp = new Razorpay(options);
rzp.on('payment.failed',function(r){window.location="${_callbackScheme}failure";});
rzp.open();
</script></body></html>
''';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    super.dispose();
  }
}

final paymentControllerProvider = StateNotifierProvider<PaymentController, PaymentState>((ref) {
  return PaymentController(
    createOrder: ref.read(createOrderProvider),
    verifyPayment: ref.read(verifyPaymentProvider),
    updatePaymentStatus: ref.read(updatePaymentStatusProvider),
    ref: ref,
  );
});