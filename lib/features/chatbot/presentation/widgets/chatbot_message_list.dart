import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/model/chatbot_message_model.dart';
import '../providers/chatbot_provider.dart';

class ChatbotMessageList extends ConsumerStatefulWidget {
  final String userId;

  const ChatbotMessageList({super.key, required this.userId});

  @override
  ConsumerState<ChatbotMessageList> createState() => _ChatbotMessageListState();
}

class _ChatbotMessageListState extends ConsumerState<ChatbotMessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatbotMessagesProvider(widget.userId));
    final controller = ref.read(chatbotProvider(widget.userId).notifier);

    return messagesAsync.when(
      data: (messages) {
        WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

        final List<Widget> messageWidgets = [];
        String? lastDateLabel;

        final sortedMessages = List<ChatbotMessage>.from(messages)
          ..sort((a, b) {
            final timeCompare = a.timestamp.compareTo(b.timestamp);
            if (timeCompare != 0) return timeCompare;
            if (a.isUser && !b.isUser) return -1;
            if (!a.isUser && b.isUser) return 1;
            return 0;
          });

        for (final message in sortedMessages) {
          final dateLabel = controller.getDateLabel(message.timestamp);

          if (lastDateLabel != dateLabel) {
            messageWidgets.add(
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Center(
                  child: Text(
                    dateLabel,
                    style: AppTheme.textStyles['body']!.copyWith(
                      color: AppTheme.colors['secondaryText'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
            lastDateLabel = dateLabel;
          }

          messageWidgets.add(
            Align(
              alignment: message.isUser
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                constraints: BoxConstraints(maxWidth: 300.w),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? AppTheme.colors['primaryAccent']!.withOpacity(0.8)
                      : AppTheme.colors['navigationAccent']!.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  message.text,
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: message.isUser
                        ? AppTheme.colors['onSurfaceDark']
                        : AppTheme.colors['primaryText'],
                  ),
                ),
              ),
            ),
          );
        }

        return ListView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          children: messageWidgets,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Error: $error',
          style: AppTheme.textStyles['bodyMedium']?.copyWith(
            color: AppTheme.colors['error'],
          ),
        ),
      ),
    );
  }
}