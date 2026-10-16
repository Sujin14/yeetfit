import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Live `users/{uid}` document, shared by the dashboard and the app drawer so
/// the profile is read through a single Firestore listener.
final userDocumentProvider =
    StreamProvider.family<Map<String, dynamic>?, String>((ref, userId) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots()
          .map((doc) => doc.data());
    });

/// [userDocumentProvider] as a stream that can be combined with other
/// streams, without restarting the caller's provider on every profile change.
Stream<Map<String, dynamic>?> watchUserDocument(Ref ref, String userId) {
  final controller = StreamController<Map<String, dynamic>?>();
  final subscription = ref.listen<AsyncValue<Map<String, dynamic>?>>(
    userDocumentProvider(userId),
    (_, next) {
      switch (next) {
        case AsyncData(:final value):
          controller.add(value);
        case AsyncError(:final error, :final stackTrace):
          controller.addError(error, stackTrace);
        case AsyncLoading():
          break;
      }
    },
    fireImmediately: true,
  );
  ref.onDispose(() {
    subscription.close();
    controller.close();
  });
  return controller.stream;
}
