// lib/features/dashboard/presentation/providers/user_data_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userDataFutureProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return doc.data();
    });
