import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/model/message_model.dart';
import '../../domain/use_cases/create_or_get_chat.dart';
import '../../domain/use_cases/delete_chat.dart';
import '../../domain/use_cases/delete_message.dart';
import '../../domain/use_cases/get_chat_messages.dart';
import '../../domain/use_cases/get_message_status.dart';
import '../../domain/use_cases/get_typing_status.dart';
import '../../domain/use_cases/get_user_profile.dart';
import '../../domain/use_cases/send_message.dart';
import '../../domain/use_cases/update_message_status.dart';
import '../../domain/use_cases/update_typing_status.dart';
import 'package:go_router/go_router.dart';

class ChatState {
  final List<MessageModel> messages;
  final bool isLoadingMessages;
  final String messageText;
  final bool isTyping;
  final bool participantTyping;
  final String participantName;
  final String participantImage;
  final String? error;

  ChatState({
    this.messages = const [],
    this.isLoadingMessages = true,
    this.messageText = '',
    this.isTyping = false,
    this.participantTyping = false,
    this.participantName = 'Admin',
    this.participantImage = '',
    this.error,
  });

  ChatState copyWith({
    List<MessageModel>? messages,
    bool? isLoadingMessages,
    String? messageText,
    bool? isTyping,
    bool? participantTyping,
    String? participantName,
    String? participantImage,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      messageText: messageText ?? this.messageText,
      isTyping: isTyping ?? this.isTyping,
      participantTyping: participantTyping ?? this.participantTyping,
      participantName: participantName ?? this.participantName,
      participantImage: participantImage ?? this.participantImage,
      error: error,
    );
  }
}

class ChatController extends StateNotifier<ChatState> {
  final GetChatMessages getChatMessages;
  final GetMessageStatus getMessageStatus;
  final GetUserProfile getUserProfile;
  final SendMessage sendMessage;
  final CreateOrGetChat createOrGetChat;
  final UpdateTypingStatus updateTypingStatus;
  final GetTypingStatus getTypingStatus;
  final UpdateMessageStatus updateMessageStatus;
  final DeleteChat deleteChat;
  final DeleteMessage deleteMessage;
  final String adminId;

  final TextEditingController messageController = TextEditingController();
  String? _chatId;
  String? _participantId;

  StreamSubscription? _messagesSubscription;
  StreamSubscription? _typingSubscription;
  StreamSubscription? _profileSubscription;

  ChatController({
    required this.getChatMessages,
    required this.getMessageStatus,
    required this.getUserProfile,
    required this.sendMessage,
    required this.createOrGetChat,
    required this.updateTypingStatus,
    required this.getTypingStatus,
    required this.updateMessageStatus,
    required this.deleteChat,
    required this.deleteMessage,
    required this.adminId,
  }) : super(ChatState());

  Future<void> setupChat(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      state = state.copyWith(error: 'User not authenticated');
      _showErrorSnack(context, 'Please sign in to access chat');
      context.goNamed('/login');
      return;
    }
    _participantId = currentUser.uid;

    try {
      _chatId = await createOrGetChat(adminId, _participantId!, state.participantName);
      if (_chatId == null) {
        state = state.copyWith(error: 'Failed to initialize chat');
        _showErrorSnack(context, 'Failed to initialize chat');
        return;
      }

      _messagesSubscription = getChatMessages(_chatId!).listen((data) {
        state = state.copyWith(messages: data, isLoadingMessages: false);
        for (var message in data) {
          if (message.senderId != _participantId && message.status != 'read') {
            updateMessageStatus(_chatId!, message.id, 'read');
          }
        }
      }, onError: (e) {
        state = state.copyWith(isLoadingMessages: false, error: 'Failed to load messages: $e');
        _showErrorSnack(context, 'Failed to load messages: $e');
      });

      _typingSubscription = getTypingStatus(_chatId!, adminId).listen((typing) {
        state = state.copyWith(participantTyping: typing);
      }, onError: (e) {
        state = state.copyWith(error: 'Failed to load typing status: $e');
        _showErrorSnack(context, 'Failed to load typing status: $e');
      });

      _profileSubscription = getUserProfile(adminId).listen((profile) {
        state = state.copyWith(
          participantName: profile['name'] ?? state.participantName,
          participantImage: profile['profileImage'] ?? state.participantImage,
        );
      }, onError: (e) {
        state = state.copyWith(error: 'Failed to load user profile: $e');
        _showErrorSnack(context, 'Failed to load user profile: $e');
      });
    } catch (e) {
      state = state.copyWith(isLoadingMessages: false, error: 'Failed to setup chat: $e');
      _showErrorSnack(context, 'Failed to setup chat: $e');
    }
  }

  void updateMessage(String value) {
    state = state.copyWith(messageText: value);
    if (_chatId != null && _participantId != null) {
      updateTypingStatus(_chatId!, _participantId!, value.isNotEmpty);
    }
  }

  Future<void> sendMessages(BuildContext context) async {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = state.copyWith(error: 'User not authenticated');
      _showErrorSnack(context, 'User not authenticated');
      return;
    }

    if (_chatId == null || _participantId == null) {
      state = state.copyWith(error: 'Chat not initialized');
      _showErrorSnack(context, 'Chat not initialized');
      return;
    }

    try {
      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: user.uid,
        content: messageText,
        timestamp: DateTime.now(),
        participants: [adminId, _participantId!],
        participantName: state.participantName,
        status: 'sent',
      );

      await sendMessage(_chatId!, message);
      messageController.clear();
      state = state.copyWith(messageText: '');
      await updateTypingStatus(_chatId!, _participantId!, false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to send message: $e');
      _showErrorSnack(context, 'Failed to send message: $e');
    }
  }

  Future<void> deleteChats(BuildContext context) async {
    if (_chatId == null) {
      state = state.copyWith(error: 'Chat not initialized');
      _showErrorSnack(context, 'Chat not initialized');
      return;
    }
    try {
      await deleteChat(_chatId!);
      // Navigation handled in widget to avoid duplication
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete chat: $e');
      _showErrorSnack(context, 'Failed to delete chat: $e');
    }
  }

  Future<void> deleteMessages(BuildContext context, String messageId) async {
    if (_chatId == null) {
      state = state.copyWith(error: 'Chat not initialized');
      _showErrorSnack(context, 'Chat not initialized');
      return;
    }
    try {
      await deleteMessage(_chatId!, messageId);
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete message: $e');
      _showErrorSnack(context, 'Failed to delete message: $e');
    }
  }

  Widget getMessageStatusIcon(String status) {
    switch (status) {
      case 'sent':
        return Icon(Icons.check, size: 16.sp, color: AppTheme.colors['secondaryText']);
      case 'delivered':
        return Icon(Icons.done_all, size: 16.sp, color: AppTheme.colors['secondaryText']);
      case 'read':
        return Icon(Icons.done_all, size: 16.sp, color: AppTheme.colors['primaryAccent']);
      default:
        return const SizedBox.shrink();
    }
  }

  void copyMessageToClipboard(BuildContext context, String content) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Message copied to clipboard',
          style: AppTheme.textStyles['bodyMedium']?.copyWith(
            color: AppTheme.colors['onSurfaceDark'],
          ),
        ),
        backgroundColor: AppTheme.colors['primaryAccent'],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.textStyles['bodyMedium']!.copyWith(
            color: AppTheme.colors['onSurfaceDark'],
          ),
        ),
        backgroundColor: AppTheme.colors['error'],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _typingSubscription?.cancel();
    _profileSubscription?.cancel();
    messageController.dispose();
    super.dispose();
  }
}