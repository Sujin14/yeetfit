import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'database_service.dart';
import '../model/message_model.dart';

class FirestoreChatService implements DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreChatService() {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  Future<List<MessageModel>> parseMessages(List<QueryDocumentSnapshot> docs) async {
    return await compute((List<QueryDocumentSnapshot> docs) {
      return docs
          .map((doc) => MessageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    }, docs);
  }

  @override
  Stream<List<Map<String, dynamic>>> getChatMessages(String chatId) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.error(Exception('User not authenticated'));
    }
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 100)))
        .asyncMap<List<Map<String, dynamic>>>((chatDoc) async {
          if (!chatDoc.exists) {
            return <Map<String, dynamic>>[];
          }
          final snapshot = await _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .where('participants', arrayContains: currentUser.uid)
              .orderBy('timestamp', descending: true)
              .limit(50)
              .get();
          final messages = await parseMessages(snapshot.docs);
          return messages.map((m) => m.toMap()).toList();
        });
  }

  @override
  Stream<Map<String, dynamic>> getMessageStatus(String chatId, String messageId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            throw Exception('Message not found');
          }
          return MessageModel.fromMap(doc.data()!, doc.id).toMap();
        });
  }

  @override
  Stream<Map<String, dynamic>> getUserProfile(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            return {'name': 'Admin', 'profileImage': ''};
          }
          return doc.data() ?? {'name': 'Admin', 'profileImage': ''};
        });
  }

  @override
  Future<void> sendMessage(String chatId, Map<String, dynamic> message) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message['id'])
        .set(message);
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message['content'],
      'lastMessageTime': message['timestamp'],
      'participants': message['participants'],
      'participantName': message['participantName'],
    });
  }

  @override
  Future<void> updateTypingStatus(String chatId, String userId, bool isTyping) async {
    await _firestore.collection('chats').doc(chatId).update({
      'typing_$userId': isTyping,
    });
  }

  @override
  Stream<bool> getTypingStatus(String chatId, String userId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map<bool>((doc) {
          if (!doc.exists) {
            return false;
          }
          return (doc.data()?['typing_$userId'] as bool?) ?? false;
        });
  }

  @override
  Future<void> updateMessageStatus(String chatId, String messageId, String status) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'status': status});
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    if (!chatDoc.exists) {
      throw Exception('Chat does not exist: $chatId');
    }
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    final isAdmin = userDoc.exists && userDoc.data()?['role'] == 'admin';
    final participants = List<String>.from(chatDoc.data()?['participants'] ?? []);
    if (!isAdmin && !participants.contains(currentUser.uid)) {
      throw Exception('User ${currentUser.uid} is not authorized to delete chat $chatId');
    }
    final messages = await _firestore.collection('chats').doc(chatId).collection('messages').get();
    for (var doc in messages.docs) {
      await doc.reference.delete();
    }
    await _firestore.collection('chats').doc(chatId).delete();
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    if (!chatDoc.exists) {
      throw Exception('Chat does not exist: $chatId');
    }
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    final isAdmin = userDoc.exists && userDoc.data()?['role'] == 'admin';
    final participants = List<String>.from(chatDoc.data()?['participants'] ?? []);
    if (!isAdmin && !participants.contains(currentUser.uid)) {
      throw Exception('User ${currentUser.uid} is not authorized to delete message $messageId');
    }
    await _firestore.collection('chats').doc(chatId).collection('messages').doc(messageId).delete();
  }

  @override
  Future<String> createOrGetChat(
      String adminId, String participantId, String participantName) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.uid != participantId) {
      throw Exception('User is not authenticated or participantId does not match current user');
    }
    if (adminId.isEmpty || participantId.isEmpty || adminId == participantId) {
      throw Exception('Invalid admin or participant ID');
    }
    final chatId = _generateChatId(adminId, participantId);
    final chatRef = _firestore.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();
    if (!chatDoc.exists) {
      await chatRef.set({
        'participants': [adminId, participantId],
        'participantName': participantName,
        'lastMessage': '',
        'lastMessageTime': Timestamp.now(),
        'typing_$adminId': false,
        'typing_$participantId': false,
      }, SetOptions(merge: true));
    }
    return chatId;
  }

  String _generateChatId(String adminId, String participantId) {
    final ids = [adminId, participantId]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}