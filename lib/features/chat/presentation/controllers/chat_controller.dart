import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  void setupChat(BuildContext context) {
    _participantId = FirebaseAuth.instance.currentUser?.uid;
    if (_participantId == null) {
      state = state.copyWith(error: 'User not authenticated');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User not authenticated',
            style: AppTheme.textStyles['bodyMedium']!.copyWith(
              color: AppTheme.colors['onSurfaceDark'],
            ),
          ),
          backgroundColor: AppTheme.colors['error'],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    createOrGetChat(adminId, _participantId!, state.participantName).then((chatId) {
      _chatId = chatId;
      getChatMessages(chatId).listen((data) {
        state = state.copyWith(messages: data, isLoadingMessages: false);
        if (data.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No messages yet. Start the conversation!',
                style: AppTheme.textStyles['bodyMedium']!.copyWith(
                  color: AppTheme.colors['onSurfaceDark'],
                ),
              ),
              backgroundColor: AppTheme.colors['primaryAccent'],
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        for (var message in data) {
          if (message.senderId != _participantId && message.status != 'read') {
            updateMessageStatus(chatId, message.id, 'read');
          }
        }
      }, onError: (e) {
        state = state.copyWith(isLoadingMessages: false, error: 'Failed to load messages: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load messages: $e',
              style: AppTheme.textStyles['bodyMedium']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['error'],
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
      getTypingStatus(chatId, adminId).listen((typing) {
        state = state.copyWith(participantTyping: typing);
      }, onError: (e) {
        state = state.copyWith(error: 'Failed to load typing status: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load typing status: $e',
              style: AppTheme.textStyles['bodyMedium']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['error'],
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
      getUserProfile(adminId).listen((profile) {
        state = state.copyWith(
          participantName: profile['name'] ?? state.participantName,
          participantImage: profile['profileImage'] ?? state.participantImage,
        );
      }, onError: (e) {
        state = state.copyWith(error: 'Failed to load user profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load user profile: $e',
              style: AppTheme.textStyles['bodyMedium']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['error'],
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }).catchError((e) {
      state = state.copyWith(isLoadingMessages: false, error: 'Failed to setup chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to setup chat: $e',
            style: AppTheme.textStyles['bodyMedium']!.copyWith(
              color: AppTheme.colors['onSurfaceDark'],
            ),
          ),
          backgroundColor: AppTheme.colors['error'],
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void updateMessage(String value) {
    state = state.copyWith(messageText: value);
    if (_chatId != null && _participantId != null) {
      updateTypingStatus(_chatId!, _participantId!, value.isNotEmpty);
    }
  }

  Future<void> sendMessages(BuildContext context) async {
    if (state.messageText.trim().isEmpty || _chatId == null || _participantId == null) return;

    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _participantId!,
      content: state.messageText.trim(),
      timestamp: DateTime.now(),
      participants: [adminId, _participantId!],
      participantName: state.participantName,
      status: 'sent',
    );

    try {
      await sendMessage(_chatId!, message);
      messageController.clear();
      state = state.copyWith(messageText: '', isTyping: false);
      updateTypingStatus(_chatId!, _participantId!, false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to send message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to send message: $e',
            style: AppTheme.textStyles['bodyMedium']!.copyWith(
              color: AppTheme.colors['onSurfaceDark'],
            ),
          ),
          backgroundColor: AppTheme.colors['error'],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> deleteChats(BuildContext context) async {
    if (_chatId != null) {
      try {
        await deleteChat(_chatId!);
      } catch (e) {
        state = state.copyWith(error: 'Failed to delete chat: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete chat: $e',
              style: AppTheme.textStyles['bodyMedium']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['error'],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> deleteMessages(BuildContext context, String messageId) async {
    if (_chatId != null) {
      try {
        await deleteMessage(_chatId!, messageId);
      } catch (e) {
        state = state.copyWith(error: 'Failed to delete message: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete message: $e',
              style: AppTheme.textStyles['bodyMedium']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            backgroundColor: AppTheme.colors['error'],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}