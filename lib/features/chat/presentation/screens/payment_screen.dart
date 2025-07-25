import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../chat/presentation/providers/payment_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  WebViewController? _webViewController;
  bool _isLoading = false;
  String? _paymentUrl;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _loadUserData();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('Mozilla/5.0 (Linux; Android) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains('success')) {
              await _verifyPayment(request.url);
              return NavigationDecision.prevent;
            } else if (request.url.contains('failure')) {
              _handlePaymentFailure();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            print('WebView error: ${error.description}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to load payment page: ${error.description}',
                  style: AppTheme.textStyles['bodyMedium']!.copyWith(
                    color: AppTheme.colors['onSurfaceDark'],
                  ),
                ),
                backgroundColor: AppTheme.colors['error'],
                behavior: SnackBarBehavior.floating,
              ),
            );
            setState(() {
              _isLoading = false;
              _paymentUrl = null;
            });
          },
        ),
      );
  }

  Future<void> _loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? FirebaseAuth.instance.currentUser?.email ?? '';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _verifyPayment(String url) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User not authenticated',
            style: AppTheme.textStyles['bodyMedium']!.copyWith(
              color: AppTheme.colors['onSurfaceDark'],
            ),
          ),
          backgroundColor: AppTheme.colors['error'],
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _isLoading = false;
        _paymentUrl = null;
      });
      return;
    }

    try {
      final uri = Uri.parse(url);
      final paymentId = uri.queryParameters['payment_id'];
      final orderId = uri.queryParameters['order_id'];
      final signature = uri.queryParameters['signature'];

      if (paymentId == null || orderId == null || signature == null) {
        throw Exception('Invalid payment response: missing parameters');
      }

      final response = await http.post(
        Uri.parse('https://yeetfit-backend.onrender.com/api/verify-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'razorpay_order_id': orderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': signature,
        }),
      );

      print('Verify payment response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 && jsonDecode(response.body)['status'] == 'success') {
        await ref.read(paymentServiceProvider).updatePaymentStatus(userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment successful! You can now access the chat feature.',
              style: AppTheme.textStyles['bodyMedium']!.copyWith(
              color: AppTheme.colors['onSurfaceDark'],
            ),
          ),
          backgroundColor: AppTheme.colors['primaryAccent'],
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/chat', extra: ref.watch(adminIdProvider).value ?? 'KzWEi9szv2dg9wvEKN6ZEGmZt7L2');
    } else {
      throw Exception('Payment verification failed: ${response.body}');
    }
  } catch (e) {
    print('Verify payment error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error verifying payment: $e',
          style: AppTheme.textStyles['bodyMedium']!.copyWith(
            color: AppTheme.colors['onSurfaceDark'],
          ),
        ),
        backgroundColor: AppTheme.colors['error'],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  setState(() {
    _isLoading = false;
    _paymentUrl = null;
  });
}

void _handlePaymentFailure() {
  print('Payment failed in WebView');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Payment failed. Please try again.',
        style: AppTheme.textStyles['bodyMedium']!.copyWith(
          color: AppTheme.colors['onSurfaceDark'],
        ),
      ),
      backgroundColor: AppTheme.colors['error'],
      behavior: SnackBarBehavior.floating,
    ),
  );
  setState(() {
    _isLoading = false;
    _paymentUrl = null;
  });
}

Future<void> _startPayment() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'User not authenticated',
          style: AppTheme.textStyles['bodyMedium']!.copyWith(
            color: AppTheme.colors['onSurfaceDark'],
          ),
        ),
        backgroundColor: AppTheme.colors['error'],
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final payload = {
      'amount': 50000,
      'currency': 'INR',
      'userId': userId,
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'contact': _contactController.text.trim(),
    };
    print('Sending create-order payload: $payload');

    final response = await http.post(
      Uri.parse('https://yeetfit-backend.onrender.com/api/create-order'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    print('Create order response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final orderData = jsonDecode(response.body);
      final orderId = orderData['orderId'];

      if (orderId == null) {
        throw Exception('Order ID not returned');
      }

      setState(() {
        _paymentUrl = '''
          <html>
            <body>
              <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
              <script>
                var options = {
                  "key": "rzp_test_vlqwFDG9Y2GUoT",
                  "amount": 50000,
                  "currency": "INR",
                  "name": "YeetFit",
                  "description": "One-time payment for chat access",
                  "order_id": "$orderId",
                  "handler": function (response) {
                    window.location.href = "https://success?payment_id=" + response.razorpay_payment_id + "&order_id=" + response.razorpay_order_id + "&signature=" + response.razorpay_signature;
                  },
                  "prefill": {
                    "name": "${_nameController.text.trim()}",
                    "email": "${_emailController.text.trim()}",
                    "contact": "${_contactController.text.trim()}"
                  },
                  "theme": {
                    "color": "#3399cc"
                  }
                };
                var rzp = new Razorpay(options);
                rzp.on('payment.failed', function (response) {
                  window.location.href = "https://failure?error=" + response.error.description;
                });
                rzp.open();
              </script>
            </body>
          </html>
        ''';
      });

      if (_webViewController != null && _paymentUrl != null) {
        await _webViewController!.loadHtmlString(_paymentUrl!);
      } else {
        throw Exception('WebView or payment URL not initialized');
      }
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  } catch (e) {
    print('Start payment error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error initiating payment: $e',
          style: AppTheme.textStyles['bodyMedium']!.copyWith(
            color: AppTheme.colors['onSurfaceDark'],
          ),
        ),
        backgroundColor: AppTheme.colors['error'],
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _startPayment,
          textColor: AppTheme.colors['onSurfaceDark'],
        ),
      ),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

@override
void dispose() {
  _nameController.dispose();
  _emailController.dispose();
  _contactController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppTheme.colors['lightBackground'] ?? Colors.grey[900],
    appBar: AppBar(
      title: Text('Unlock Chat Feature', style: AppTheme.textStyles['title']),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    body: Stack(
      children: [
        if (_paymentUrl != null && _webViewController != null)
          WebViewWidget(controller: _webViewController!)
        else
          SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: GlassmorphicContainer(
              color: AppTheme.colors['primaryAccent'] ?? Colors.blue,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'One-Time Payment',
                      style: AppTheme.textStyles['heading']!.copyWith(
                        color: AppTheme.colors['onSurfaceDark'],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Unlock the chat feature for a one-time payment of ₹500.',
                      style: AppTheme.textStyles['body']!.copyWith(
                        color: AppTheme.colors['onSurfaceDark'],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: AppTheme.colors['onSurfaceDark']),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: AppTheme.colors['onSurfaceDark']),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: AppTheme.colors['onSurfaceDark']),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: AppTheme.colors['onSurfaceDark']),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        labelStyle: TextStyle(color: AppTheme.colors['onSurfaceDark']),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: AppTheme.colors['onSurfaceDark']),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your contact number';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                          return 'Please enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _startPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                      ),
                      child: Text(
                        _isLoading ? 'Processing...' : 'Pay Now',
                        style: AppTheme.textStyles['title']!.copyWith(
                          color: AppTheme.colors['onSurfaceDark'],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator()),
      ],
    ),
  );
}
}