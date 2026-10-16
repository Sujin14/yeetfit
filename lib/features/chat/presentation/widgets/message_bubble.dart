import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/chat_bubble.dart';
import '../../data/model/message_model.dart';
import '../controllers/chat_controller.dart';
import 'message_options_dialog.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class MessageBubble extends ConsumerWidget {
  final MessageModel message;
  final ChatController controller;

  const MessageBubble({
    super.key,
    required this.message,
    required this.controller,
  });

  void _showMessageOptions(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => MessageOptionsDialog(
        onCopy: () {
          Clipboard.setData(ClipboardData(text: message.content));
          messenger.showSnackBar(
            SnackBar(
              content: const Text('Message copied to clipboard'),
              backgroundColor: colors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(dialogContext).pop();
        },
        onDelete: () {
          controller.deleteMessages(message.id);
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  static Widget _statusIcon(AppColors colors, String status) {
    return switch (status) {
      'sent' => Icon(Icons.check, size: 16, color: colors.textSecondary),
      'delivered' => Icon(
        Icons.done_all,
        size: 16,
        color: colors.textSecondary,
      ),
      'read' => Icon(Icons.done_all, size: 16, color: colors.primary),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isMe = ref.watch(authUserIdProvider) == message.senderId;

    return ChatBubble(
      text: message.content,
      isMine: isMe,
      onLongPress: () => _showMessageOptions(context),
      footer: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('hh:mm a').format(message.timestamp),
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: colors.textMuted),
          ),
          if (isMe) ...[
            const SizedBox(width: AppSpacing.xs),
            _statusIcon(colors, message.status),
          ],
        ],
      ),
    );
  }
}
