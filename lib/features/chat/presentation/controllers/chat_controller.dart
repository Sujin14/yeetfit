import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasource/firestore_chat_service.dart';
import '../../data/model/message_model.dart';
import '../providers/chat_provider.dart';

class ChatState {
  final List<MessageModel> messages;
  final bool isLoadingMessages;
  final bool participantTyping;
  final String participantName;
  final String participantImage;

  /// The other user's profile no longer exists: past messages stay readable
  /// but nothing new can be sent.
  final bool isAccountDeleted;
  final bool selectionMode;
  final Set<String> selectedIds;
  final String? error;

  ChatState({
    this.messages = const [],
    this.isLoadingMessages = true,
    this.participantTyping = false,
    this.participantName = 'Coach',
    this.participantImage = '',
    this.isAccountDeleted = false,
    this.selectionMode = false,
    this.selectedIds = const {},
    this.error,
  });

  /// [error] is cleared unless passed, so each failure is reported once.
  ChatState copyWith({
    List<MessageModel>? messages,
    bool? isLoadingMessages,
    bool? participantTyping,
    String? participantName,
    String? participantImage,
    bool? isAccountDeleted,
    bool? selectionMode,
    Set<String>? selectedIds,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      participantTyping: participantTyping ?? this.participantTyping,
      participantName: participantName ?? this.participantName,
      participantImage: participantImage ?? this.participantImage,
      isAccountDeleted: isAccountDeleted ?? this.isAccountDeleted,
      selectionMode: selectionMode ?? this.selectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
      error: error,
    );
  }
}

class ChatController extends Notifier<ChatState> {
  final String adminId;

  late FirestoreChatService _chatService;
  final TextEditingController messageController = TextEditingController();
  String? _chatId;
  String? _participantId;

  StreamSubscription<List<MessageModel>>? _messagesSubscription;
  StreamSubscription<bool>? _typingSubscription;
  StreamSubscription<Map<String, dynamic>?>? _profileSubscription;

  ChatController(this.adminId);

  @override
  ChatState build() {
    _chatService = ref.read(firestoreChatServiceProvider);
    ref.onDispose(() {
      _messagesSubscription?.cancel();
      _typingSubscription?.cancel();
      _profileSubscription?.cancel();
      messageController.dispose();
    });
    return ChatState();
  }

  /// Seeds the display name before the coaches/ stream lands.
  /// Photo comes from [myCoachProvider] / coach doc in the header — not args.
  void seedParticipant({required String name}) {
    if (name.isEmpty) return;
    state = state.copyWith(participantName: name);
  }

  Future<void> setupChat() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      state = state.copyWith(error: 'User not authenticated');
      return;
    }
    final participantId = currentUser.uid;
    _participantId = participantId;

    try {
      final accountDeleted = !await _chatService.coachExists(adminId);
      if (!ref.mounted) return;
      if (accountDeleted) state = state.copyWith(isAccountDeleted: true);
      // The rules reject creating a chat with a deleted coach.
      final chatId = accountDeleted
          ? FirestoreChatService.chatIdFor(adminId, participantId)
          : await _chatService.createOrGetChat(
              adminId,
              participantId,
              state.participantName,
            );
      if (!ref.mounted) return;
      _chatId = chatId;

      _messagesSubscription = _chatService
          .getChatMessages(chatId)
          .listen(
            (data) {
              state = state.copyWith(messages: data, isLoadingMessages: false);
              for (final message in data) {
                if (message.senderId != participantId &&
                    message.status != 'read') {
                  _chatService.updateMessageStatus(chatId, message.id, 'read');
                }
              }
            },
            onError: (e) {
              state = state.copyWith(
                isLoadingMessages: false,
                error: 'Failed to load messages: $e',
              );
            },
          );

      if (accountDeleted) return;

      _typingSubscription = _chatService
          .getTypingStatus(chatId, adminId)
          .listen(
            (typing) => state = state.copyWith(participantTyping: typing),
            onError: (e) {
              state = state.copyWith(error: 'Failed to load typing status: $e');
            },
          );

      _profileSubscription = _chatService
          .getCoachProfile(adminId)
          .listen(
            (profile) {
              if (profile == null) {
                state = state.copyWith(isAccountDeleted: true);
                return;
              }
              state = state.copyWith(
                participantName: profile['name'] ?? state.participantName,
                participantImage:
                    profile['profileImage'] ?? state.participantImage,
              );
            },
            onError: (e) {
              state = state.copyWith(error: 'Failed to load coach profile: $e');
            },
          );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoadingMessages: false,
        error: 'Failed to setup chat: $e',
      );
    }
  }

  void updateMessage(String value) {
    if (state.error != null) state = state.copyWith();
    final chatId = _chatId;
    final participantId = _participantId;
    if (chatId != null && participantId != null) {
      _chatService.updateTypingStatus(chatId, participantId, value.isNotEmpty);
    }
  }

  Future<void> sendMessages() async {
    if (state.isAccountDeleted) return;
    final messageText = messageController.text.trim();
    if (messageText.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = state.copyWith(error: 'User not authenticated');
      return;
    }

    final chatId = _chatId;
    final participantId = _participantId;
    if (chatId == null || participantId == null) {
      state = state.copyWith(error: 'Chat not initialized');
      return;
    }

    try {
      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: user.uid,
        content: messageText,
        timestamp: DateTime.now(),
        participants: [adminId, participantId],
        participantName: state.participantName,
        status: 'sent',
      );

      await _chatService.sendMessage(chatId, message);
      if (!ref.mounted) return;
      messageController.clear();
      if (state.error != null) state = state.copyWith();
      await _chatService.updateTypingStatus(chatId, participantId, false);
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(error: 'Failed to send message: $e');
      }
    }
  }

  void enterSelection(String messageId) {
    state = state.copyWith(
      selectionMode: true,
      selectedIds: {messageId},
    );
  }

  void toggleSelection(String messageId) {
    final next = Set<String>.from(state.selectedIds);
    if (!next.add(messageId)) next.remove(messageId);
    if (next.isEmpty) {
      clearSelection();
      return;
    }
    state = state.copyWith(selectionMode: true, selectedIds: next);
  }

  void clearSelection() {
    state = state.copyWith(selectionMode: false, selectedIds: const {});
  }

  /// Soft-deletes selected messages for the signed-in user only.
  Future<bool> deleteSelectedForMe() async {
    final chatId = _chatId;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (chatId == null || uid == null) {
      state = state.copyWith(error: 'Chat not initialized');
      return false;
    }
    final ids = state.selectedIds.toList();
    if (ids.isEmpty) return false;
    try {
      await _chatService.deleteMessagesForMe(chatId, ids, uid);
      if (!ref.mounted) return true;
      clearSelection();
      return true;
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(error: 'Failed to delete messages: $e');
      }
      return false;
    }
  }

  /// Clears the chat for the signed-in user only; the other party keeps it.
  Future<bool> clearChatForMe() async {
    final chatId = _chatId;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (chatId == null || uid == null) {
      state = state.copyWith(error: 'Chat not initialized');
      return false;
    }
    try {
      await _chatService.clearChatForMe(chatId, uid);
      if (!ref.mounted) return true;
      clearSelection();
      return true;
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(error: 'Failed to delete chat: $e');
      }
      return false;
    }
  }
}
