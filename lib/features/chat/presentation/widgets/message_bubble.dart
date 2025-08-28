import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/model/message_model.dart';
import '../providers/chat_provider.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class MessageBubble extends ConsumerWidget {
  final MessageModel message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = ref.watch(isMessageFromCurrentUserProvider(message.senderId));
    final adminId = ref.read(chatControllerProvider as ProviderListenable).adminId;
    final controller = ref.read(chatControllerProvider(adminId).notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onLongPress: () => controller.showMessageOptions(context, message.content, message.id),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: GlassmorphicContainer(
                  padding: EdgeInsets.all(8.w),
                  color: isMe
                      ? AppTheme.colors['primaryButton']!
                      : AppTheme.colors['secondaryAccent']!,
                  borderRadius: 12.r,
                  child: Text(
                    message.content,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                    style: AppTheme.textStyles['bodyMedium']?.copyWith(
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
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
}