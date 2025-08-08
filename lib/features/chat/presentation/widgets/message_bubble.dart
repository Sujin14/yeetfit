import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../data/model/message_model.dart';
import '../controllers/chat_controller.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final ChatController controller;

  const MessageBubble({
    super.key,
    required this.message,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == FirebaseAuth.instance.currentUser?.uid;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onLongPress: () {
                _showMessageOptions(context);
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: GlassmorphicContainer(
                  padding: EdgeInsets.all(8.w),
                  color: isMe
                      ? (AppTheme.colors['primaryButton'] ?? Colors.blue)
                      : (AppTheme.colors['secondaryAccent'] ?? Colors.grey),
                  borderRadius: 12.r,
                  child: Text(
                    message.content,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                    style: AppTheme.textStyles['bodyMedium']?.copyWith(
                      color: AppTheme.colors['primaryText'] ?? Colors.white,
                    ) ?? TextStyle(color: Colors.white),
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
                    color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                  ) ?? TextStyle(color: Colors.grey),
                ),
                if (isMe) ...[
                  SizedBox(width: 4.w),
                  _buildMessageStatusIcon(message.status),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageStatusIcon(String status) {
    switch (status) {
      case 'sent':
        return Icon(Icons.check, size: 16.sp, color: AppTheme.colors['secondaryText']);
      case 'delivered':
        return Icon(Icons.done_all, size: 16.sp, color: AppTheme.colors['secondaryText']);
      case 'read':
        return Icon(Icons.done_all, size: 16.sp, color: AppTheme.colors['primaryAccent']);
      default:
        return const SizedBox.shrink();
    }
  }

  void _showMessageOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Message Options',
            style: AppTheme.textStyles['titleMedium'] ?? TextStyle(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Copy',
                  style: AppTheme.textStyles['bodyMedium'] ?? TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.content));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Message copied to clipboard',
                        style: AppTheme.textStyles['bodyMedium']?.copyWith(
                          color: AppTheme.colors['onSurfaceDark'] ?? Colors.white,
                        ) ?? TextStyle(color: Colors.white),
                      ),
                      backgroundColor: AppTheme.colors['primaryAccent'] ?? Colors.blue,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Delete',
                  style: AppTheme.textStyles['bodyMedium']?.copyWith(
                    color: AppTheme.colors['error'] ?? Colors.red,
                  ) ?? TextStyle(color: Colors.red),
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