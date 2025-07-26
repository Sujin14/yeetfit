import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  Future<void> updatePaymentStatus(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'hasPaid': true,
    });
  }

  Future<Map<String, dynamic>> verifyPayment(String paymentId, String orderId, String signature) async {
    try {
      final response = await http.post(
        Uri.parse('https://yeetfit-backend.onrender.com/api/verify-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'razorpay_order_id': orderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': signature,
        }),
      );
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 'success') {
        return {'status': 'success'};
      } else {
        throw Exception('Verification failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error verifying payment: $e');
    }
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse('https://yeetfit-backend.onrender.com/api/create-order'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(payload),
      );
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['orderId'] != null) {
        return {'orderId': json['orderId']};
      } else {
        throw Exception('Order failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error initiating payment: $e');
    }
  }
}