import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'selected_date_provider.dart';
import 'package:yeetfit/shared/providers/user_document_provider.dart';

final bmiStreamProvider = StreamProvider.family<double, String>((ref, userId) {
  final date = ref.watch(selectedDateProvider).toIso8601String().split('T')[0];

  final weightStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('weight')
      .collection('weight')
      .doc(date)
      .snapshots();

  return Rx.combineLatest2(watchUserDocument(ref, userId), weightStream, (
    userData,
    weightDoc,
  ) {
    final height = (userData?['height'] as num?)?.toDouble() ?? 0.0;
    final weight = weightDoc.exists
        ? (weightDoc.data()?['currentWeight'] as num?)?.toDouble()
        : (userData?['currentWeight'] as num?)?.toDouble();

    if (height <= 0 || weight == null || weight <= 0) return 0.0;
    return weight / ((height / 100) * (height / 100));
  });
});
