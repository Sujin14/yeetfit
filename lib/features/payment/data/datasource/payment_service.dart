import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentService {
  Future<void> updatePaymentStatus(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'hasPaid': true,
    });
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      final token = await user.getIdToken(true);
      print('Auth token: $token');
      final callable = FirebaseFunctions.instanceFor(
        region: 'asia-south1',
      ).httpsCallable('createOrder');
      final response = await callable.call(payload);
      final data = response.data;
      print('Cloud Function response: $data');
      if (data['status'] == 'success' && data['orderId'] != null) {
        return {'orderId': data['orderId']};
      } else {
        throw Exception(
          'Order creation failed: ${data['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      print('Create order error: $e');
      throw Exception('Error creating order: $e');
    }
  }
}
