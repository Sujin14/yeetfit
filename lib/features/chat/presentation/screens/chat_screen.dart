import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/date_util.dart';
import '../../data/model/message_model.dart';
import '../widgets/chat_header.dart';
import '../widgets/date_seperator.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String adminId;

  const ChatScreen({super.key, required this.adminId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chatControllerProvider(widget.adminId).notifier).setupChat(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatControllerProvider(widget.adminId));

    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'],
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: ChatHeader(
          controller: ref.read(chatControllerProvider(widget.adminId).notifier),
        ),
      ),
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Expanded(
                child: chatState.isLoadingMessages
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              reverse: false,
                              itemCount: _calculateItemCount(chatState.messages),
                              itemBuilder: (context, index) {
                                final item = _getItemAtIndex(chatState.messages, index);
                                if (item is String) {
                                  // Date separator
                                  return DateSeparator(dateText: item);
                                } else if (item is MessageModel) {
                                  // Message bubble
                                  return MessageBubble(
                                    message: item,
                                    controller: ref.read(
                                      chatControllerProvider(widget.adminId).notifier,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          if (chatState.participantTyping)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Typing...',
                                  style: AppTheme.textStyles['bodySmall']?.copyWith(
                                    color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
              MessageInput(
                controller: ref.read(
                  chatControllerProvider(widget.adminId).notifier,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateItemCount(List<MessageModel> messages) {
    if (messages.isEmpty) return 0;
    int count = messages.length;
    DateTime? lastDate;
    for (var message in messages.reversed) {
      final currentDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      if (lastDate == null || currentDate != lastDate) {
        count++; // Add a date separator
        lastDate = currentDate;
      }
    }
    return count;
  }

  dynamic _getItemAtIndex(List<MessageModel> messages, int index) {
    if (messages.isEmpty) return null;
    final reversedMessages = messages.reversed.toList();
    int currentIndex = 0;
    DateTime? lastDate;

    for (int i = 0; i < reversedMessages.length; i++) {
      final message = reversedMessages[i];
      final currentDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      if (lastDate == null || currentDate != lastDate) {
        if (currentIndex == index) {
          return getFormattedDate(message.timestamp);
        }
        currentIndex++;
        lastDate = currentDate;
      }

      if (currentIndex == index) {
        return message;
      }
      currentIndex++;
    }
    return null;
  }
}