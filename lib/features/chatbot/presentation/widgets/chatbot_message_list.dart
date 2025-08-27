import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
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

  String getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(date.year, date.month, date.day);

    if (msgDate == today) return 'Today';
    if (msgDate == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatbotMessagesProvider(widget.userId));

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
          final dateLabel = getDateLabel(message.timestamp);

          if (lastDateLabel != dateLabel) {
            messageWidgets.add(
              Padding(
                padding: EdgeInsets.symmetric(vertical: FixedSizes.box8(context)),
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
                margin: EdgeInsets.symmetric(vertical: FixedSizes.box4(context)),
                padding: EdgeInsets.symmetric(
                  horizontal: FixedSizes.box16(context),
                  vertical: FixedSizes.box12(context),
                ),
                constraints: BoxConstraints(maxWidth: FixedSizes.box150(context)),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? AppTheme.colors['primaryAccent']!.withOpacity(0.8)
                      : AppTheme.colors['navigationAccent']!.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(FixedSizes.radius16(context)),
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
          padding: EdgeInsets.symmetric(
            horizontal: FixedSizes.box16(context),
            vertical: FixedSizes.box8(context),
          ),
          children: messageWidgets,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
