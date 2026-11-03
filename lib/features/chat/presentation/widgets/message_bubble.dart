import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/chat_bubble.dart';
import '../../data/model/message_model.dart';
import '../controllers/chat_controller.dart';
import '../providers/chat_provider.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class MessageBubble extends ConsumerWidget {
  final MessageModel message;
  final ChatController controller;

  const MessageBubble({
    super.key,
    required this.message,
    required this.controller,
  });

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
    final chatState = ref.watch(chatControllerProvider(controller.adminId));
    final selectionMode = chatState.selectionMode;
    final isSelected = chatState.selectedIds.contains(message.id);

    return Material(
      color: isSelected
          ? colors.primary.withValues(alpha: 0.12)
          : Colors.transparent,
      child: InkWell(
        onTap: selectionMode
            ? () => controller.toggleSelection(message.id)
            : null,
        onLongPress: selectionMode
            ? null
            : () {
                HapticFeedback.lightImpact();
                controller.enterSelection(message.id);
              },
        child: Padding(
          padding: EdgeInsets.only(
            left: selectionMode ? AppSpacing.sm : 0,
            right: selectionMode ? AppSpacing.sm : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (selectionMode) ...[
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    size: 22,
                    color: isSelected ? colors.primary : colors.textMuted,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: ChatBubble(
                  text: message.content,
                  isMine: isMe,
                  onLongPress: selectionMode
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          controller.enterSelection(message.id);
                        },
                  footer: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(message.timestamp),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: AppSpacing.xs),
                        _statusIcon(colors, message.status),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
