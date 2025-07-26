import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService extends ProviderObserver {
  Future<NotificationService> init() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return this; // Exit early if user is not authenticated
    }

    FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .listen((snapshot) {
      for (var chat in snapshot.docs) {
        FirebaseFirestore.instance
            .collection('chats')
            .doc(chat.id)
            .collection('messages')
            .where('participants', arrayContains: userId)
            .where('status', isEqualTo: 'sent')
            .where('senderId', isNotEqualTo: userId) // Only update messages not sent by the user
            .get()
            .then((messages) {
              for (var msg in messages.docs) {
                msg.reference.update({'status': 'delivered'}).catchError((e) {
                  FirebaseFirestore.instance
                      .collection('debug')
                      .doc('logs')
                      .collection('errors')
                      .add({
                    'error': 'Failed to update message status: $e',
                    'timestamp': FieldValue.serverTimestamp(),
                    'context': 'NotificationService.updateMessageStatus(${chat.id}, ${msg.id})',
                  });
                });
              }
            }).catchError((e) {
              FirebaseFirestore.instance
                  .collection('debug')
                  .doc('logs')
                  .collection('errors')
                  .add({
                'error': 'Failed to query messages: $e',
                'timestamp': FieldValue.serverTimestamp(),
                'context': 'NotificationService.getMessages(${chat.id})',
              });
            });
      }
    }, onError: (e) {
      FirebaseFirestore.instance
          .collection('debug')
          .doc('logs')
          .collection('errors')
          .add({
        'error': 'Failed to listen to chats: $e',
        'timestamp': FieldValue.serverTimestamp(),
        'context': 'NotificationService.init',
      });
    });

    return this;
  }
}