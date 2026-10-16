import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/chat_bubble.dart';
import 'package:yeetfit/shared/widgets/chat_date_chip.dart';
import 'package:yeetfit/shared/widgets/chat_shimmer.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../../data/model/chatbot_message_model.dart';
import '../providers/chatbot_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  static String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(date.year, date.month, date.day);

    if (msgDate == today) return 'Today';
    if (msgDate == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final messagesAsync = ref.watch(chatbotProvider(widget.userId));

    return messagesAsync.when(
      data: (messages) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        // ChatbotBody renders the empty state over the full screen.
        if (messages.isEmpty) return const SizedBox.shrink();

        final sortedMessages = List<ChatbotMessage>.from(messages)
          ..sort((a, b) {
            final timeCompare = a.timestamp.compareTo(b.timestamp);
            if (timeCompare != 0) return timeCompare;
            if (a.isUser && !b.isUser) return -1;
            if (!a.isUser && b.isUser) return 1;
            return 0;
          });

        final messageWidgets = <Widget>[];
        String? lastDateLabel;
        for (final message in sortedMessages) {
          final dateLabel = _dateLabel(message.timestamp);
          if (lastDateLabel != dateLabel) {
            messageWidgets.add(ChatDateChip(label: dateLabel));
            lastDateLabel = dateLabel;
          }
          messageWidgets.add(
            ChatBubble(
              text: message.text,
              isMine: message.isUser,
              renderMarkdown: !message.isUser,
            ),
          );
        }

        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          children: messageWidgets,
        );
      },
      loading: () => const ChatShimmer(),
      error: (error, _) => YeetErrorState(
        message: "Couldn't load your chat with Yana: $error",
        onRetry: () => ref.invalidate(chatbotProvider(widget.userId)),
      ),
    );
  }
}
