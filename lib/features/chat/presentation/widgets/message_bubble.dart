import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../data/model/message_model.dart';
import '../controllers/chat_controller.dart';
import '../providers/chat_provider.dart';

class MessageBubble extends ConsumerWidget {
  final MessageModel message;
  final ChatController controller;

  const MessageBubble({
    super.key,
    required this.message,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = ref.watch(isMessageFromCurrentUserProvider(message.senderId));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onLongPress: () => _showMessageOptions(context),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: GlassmorphicContainer(
                  padding: EdgeInsets.all(8.w),
                  color: isMe
                      ? AppTheme.colors['primaryAccent']!
                      : AppTheme.colors['secondaryAccent']!,
                  borderRadius: 12.r,
                  child: Text(
                    message.content,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                    style:
                        AppTheme.textStyles['bodyMedium']?.copyWith(
                          color: AppTheme.colors['primaryText'],
                        ) ??
                        TextStyle(color: AppTheme.colors['white']),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: isMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat('hh:mm a').format(message.timestamp),
                  style:
                      AppTheme.textStyles['bodySmall']?.copyWith(
                        color: AppTheme.colors['secondaryText'],
                      ) ??
                      TextStyle(color: AppTheme.colors['gray']),
                ),
                if (isMe) ...[
                  SizedBox(width: 4.w),
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
          title: Text(
            'Message Options',
            style:
                AppTheme.textStyles['titleMedium'] ?? TextStyle(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Copy',
                  style:
                      AppTheme.textStyles['bodyMedium'] ??
                      TextStyle(fontSize: 16),
                ),
                onTap: () {
                  controller.copyMessageToClipboard(context, message.content);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(
                  'Delete',
                  style:
                      AppTheme.textStyles['bodyMedium']?.copyWith(
                        color: AppTheme.colors['error'],
                      ) ??
                      TextStyle(color: AppTheme.colors['error']),
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
