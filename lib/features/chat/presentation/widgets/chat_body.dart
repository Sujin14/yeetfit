import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/chat_input_bar.dart';
import 'package:yeetfit/shared/widgets/chat_shimmer.dart';
import '../../data/model/message_model.dart';
import '../controllers/chat_controller.dart';
import 'chat_account_deleted_notice.dart';
import 'chat_header.dart';
import 'chat_message_list.dart';
import 'typing_indicator.dart';

class ChatBody extends StatelessWidget {
  final List<MessageModel> messages;
  final bool isLoadingMessages;
  final bool participantTyping;
  final bool isAccountDeleted;
  final ChatController controller;
  final VoidCallback onAudioCall;
  final VoidCallback onVideoCall;
  final bool isStartingCall;
  final VoidCallback? onScheduleSession;

  const ChatBody({
    super.key,
    required this.messages,
    required this.isLoadingMessages,
    required this.participantTyping,
    required this.isAccountDeleted,
    required this.controller,
    required this.onAudioCall,
    required this.onVideoCall,
    required this.isStartingCall,
    this.onScheduleSession,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          children: [
            ChatHeader(
              controller: controller,
              onAudioCall: onAudioCall,
              onVideoCall: onVideoCall,
              isStartingCall: isStartingCall,
              onScheduleSession: onScheduleSession,
            ),
            Expanded(
              child: isLoadingMessages
                  ? const ChatShimmer()
                  : ChatMessageList(messages: messages, controller: controller),
            ),
            if (participantTyping && !isLoadingMessages)
              const TypingIndicator(),
            isAccountDeleted
                ? const ChatAccountDeletedNotice()
                : ChatInputBar(
                    controller: controller.messageController,
                    onChanged: controller.updateMessage,
                    onSend: controller.sendMessages,
                  ),
          ],
        ),
      ),
    );
  }
}
