import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../data/model/message_model.dart';
import '../controllers/chat_controller.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../providers/chat_provider.dart';

class MessageBubble extends ConsumerWidget {
  final MessageModel message;
  final ChatController controller;

  const MessageBubble({super.key, required this.message, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = ref.watch(isMessageFromCurrentUserProvider(message.senderId));

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: FixedSizes.box12(context),
        vertical: FixedSizes.box4(context),
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onLongPress: () => _showMessageOptions(context),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: FixedSizes.box240(context)),
                child: GlassmorphicContainer(
                  padding: EdgeInsets.all(FixedSizes.box8(context)),
                  color: isMe
                      ? AppTheme.colors['primaryButton']!
                      : AppTheme.colors['secondaryAccent']!,
                  borderRadius: FixedSizes.radius12(context),
                  child: Text(
                    message.content,
                    style: AppTheme.textStyles['bodyMedium']?.copyWith(
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: FixedSizes.box4(context)),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat('hh:mm a').format(message.timestamp),
                  style: AppTheme.textStyles['bodySmall']?.copyWith(
                    color: AppTheme.colors['secondaryText'],
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: FixedSizes.box4(context)),
                  controller.getMessageStatusIcon(message.status),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Message Options', style: AppTheme.textStyles['titleMedium']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Copy', style: AppTheme.textStyles['bodyMedium']),
                onTap: () {
                  controller.copyMessageToClipboard(context, message.content);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(
                  'Delete',
                  style: AppTheme.textStyles['bodyMedium']?.copyWith(
                    color: AppTheme.colors['error'],
                  ),
                ),
                onTap: () {
                  controller.deleteMessages(context, message.id);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
