import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Marks incoming chat messages as `delivered` while the user is signed in.
class MessageDeliveryService {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _chatsSubscription;
  String? _userId;

  void start(String userId) {
    if (_userId == userId && _chatsSubscription != null) return;
    stop();
    _userId = userId;

    _chatsSubscription = FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .listen(
          (snapshot) {
            for (final chat in snapshot.docs) {
              FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chat.id)
                  .collection('messages')
                  .where('participants', arrayContains: userId)
                  .where('status', isEqualTo: 'sent')
                  .where(
                    'senderId',
                    isNotEqualTo: userId,
                  ) // Only update messages not sent by the user
                  .get()
                  .then((messages) {
                    for (final msg in messages.docs) {
                      msg.reference.update({'status': 'delivered'}).catchError((
                        e,
                      ) {
                        debugPrint(
                          'MessageDeliveryService: status update failed: $e',
                        );
                      });
                    }
                  })
                  .catchError((e) {
                    debugPrint(
                      'MessageDeliveryService: message query failed: $e',
                    );
                  });
            }
          },
          onError: (e) {
            debugPrint('MessageDeliveryService: chat listener failed: $e');
          },
        );
  }

  void stop() {
    _chatsSubscription?.cancel();
    _chatsSubscription = null;
    _userId = null;
  }
}
