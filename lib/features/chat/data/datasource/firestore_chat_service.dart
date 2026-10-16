import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../model/message_model.dart';

class FirestoreChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getChatMessages(String chatId) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.error(Exception('User not authenticated'));
    }
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .debounce(
          (_) => TimerStream<void>(null, const Duration(milliseconds: 100)),
        )
        .asyncMap((chatDoc) async {
          if (!chatDoc.exists) return <MessageModel>[];
          final snapshot = await _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .where('participants', arrayContains: currentUser.uid)
              .orderBy('timestamp', descending: true)
              .limit(50)
              .get();
          return snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  /// `null` once the user's profile no longer exists (account deleted).
  Stream<Map<String, dynamic>?> getUserProfile(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data());
  }

  Future<bool> userExists(String userId) async =>
      (await _firestore.collection('users').doc(userId).get()).exists;

  static String chatIdFor(String userA, String userB) {
    final ids = [userA, userB]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    final data = message.toMap();
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .set(data);
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': data['content'],
      'lastMessageTime': data['timestamp'],
      'participants': data['participants'],
      'participantName': data['participantName'],
    });
  }

  Future<void> updateTypingStatus(String chatId, String userId, bool isTyping) {
    return _firestore.collection('chats').doc(chatId).update({
      'typing_$userId': isTyping,
    });
  }

  Stream<bool> getTypingStatus(String chatId, String userId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((doc) => (doc.data()?['typing_$userId'] as bool?) ?? false);
  }

  Future<void> updateMessageStatus(
    String chatId,
    String messageId,
    String status,
  ) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'status': status});
  }

  Future<void> deleteChat(String chatId) async {
    await _ensureCanModifyChat(chatId, 'Not authorized to delete this chat');
    final chatRef = _firestore.collection('chats').doc(chatId);
    final messages = await chatRef.collection('messages').get();
    for (final doc in messages.docs) {
      await doc.reference.delete();
    }
    await chatRef.delete();
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await _ensureCanModifyChat(chatId, 'Not authorized to delete this message');
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  /// Throws unless the chat exists and the signed-in user is an admin or one
  /// of its participants.
  Future<void> _ensureCanModifyChat(
    String chatId,
    String unauthorizedMessage,
  ) async {
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    if (!chatDoc.exists) {
      throw Exception('Chat does not exist: $chatId');
    }
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    final userDoc = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final isAdmin = userDoc.exists && userDoc.data()?['role'] == 'admin';
    final participants = List<String>.from(
      chatDoc.data()?['participants'] ?? [],
    );
    if (!isAdmin && !participants.contains(currentUser.uid)) {
      throw Exception(unauthorizedMessage);
    }
  }

  Future<String> createOrGetChat(
    String adminId,
    String participantId,
    String participantName,
  ) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.uid != participantId) {
      throw Exception(
        'User is not authenticated or participantId does not match current user',
      );
    }
    if (adminId.isEmpty || participantId.isEmpty || adminId == participantId) {
      throw Exception('Invalid admin or participant ID');
    }
    final chatId = chatIdFor(adminId, participantId);
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
}
