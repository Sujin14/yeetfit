import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/chat_date_chip.dart';
import '../../../../core/utils/date_util.dart';
import '../../data/model/message_model.dart';
import '../controllers/chat_controller.dart';
import 'message_bubble.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Oldest-first messages with a date chip before each new day.
class ChatMessageList extends StatelessWidget {
  final List<MessageModel> messages;
  final ChatController controller;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.controller,
  });

  /// [messages] arrive newest first; the result interleaves date labels
  /// (`String`) with [MessageModel]s.
  static List<Object> _withDateSeparators(List<MessageModel> messages) {
    final items = <Object>[];
    DateTime? lastDate;
    for (final message in messages.reversed) {
      final timestamp = message.timestamp;
      final date = DateTime(timestamp.year, timestamp.month, timestamp.day);
      if (date != lastDate) {
        items.add(getFormattedDate(timestamp));
        lastDate = date;
      }
      items.add(message);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _withDateSeparators(messages);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: items.length,
      itemBuilder: (context, index) => switch (items[index]) {
        final String label => ChatDateChip(label: label),
        final MessageModel message => MessageBubble(
          message: message,
          controller: controller,
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
