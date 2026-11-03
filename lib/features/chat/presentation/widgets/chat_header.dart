import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/features/coaches/presentation/providers/coach_provider.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';
import 'package:yeetfit/shared/widgets/yeet_confirm_dialog.dart';
import '../controllers/chat_controller.dart';
import '../providers/chat_provider.dart';
import 'chat_participant_avatar.dart';

class ChatHeader extends ConsumerWidget {
  static const double _height = 64;

  final ChatController controller;
  final VoidCallback onAudioCall;
  final VoidCallback onVideoCall;
  final bool isStartingCall;

  /// Shown to coaches only; null hides the menu entry.
  final VoidCallback? onScheduleSession;

  const ChatHeader({
    super.key,
    required this.controller,
    required this.onAudioCall,
    required this.onVideoCall,
    required this.isStartingCall,
    this.onScheduleSession,
  });

  Future<void> _confirmClearChat(BuildContext context, WidgetRef ref) async {
    final name = ref.read(chatControllerProvider(controller.adminId)).participantName;
    final confirmed = await showYeetConfirmDialog(
      context,
      title: 'Delete chat?',
      message: 'Delete this chat for you? $name will still have it.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) return;
    final cleared = await controller.clearChatForMe();
    if (!context.mounted || !cleared) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat deleted for you'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmDeleteSelected(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final chatState = ref.read(chatControllerProvider(controller.adminId));
    final count = chatState.selectedIds.length;
    final name = chatState.participantName;
    final label = count == 1 ? 'message' : 'messages';
    final confirmed = await showYeetConfirmDialog(
      context,
      title: 'Delete $label?',
      message:
          'Delete $count $label? They\'ll be removed only from your chat. '
          '$name will still see them.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) return;
    final deleted = await controller.deleteSelectedForMe();
    if (!context.mounted || !deleted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleted for you'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copySelected(BuildContext context, WidgetRef ref) {
    final chatState = ref.read(chatControllerProvider(controller.adminId));
    final id = chatState.selectedIds.single;
    String? text;
    for (final message in chatState.messages) {
      if (message.id == id) {
        text = message.content;
        break;
      }
    }
    if (text == null) return;
    Clipboard.setData(ClipboardData(text: text));
    controller.clearSelection();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Live `coaches/{id}.profileImageUrl` via [myCoachProvider], falling back
  /// to [coachProfileProvider] for notification / schedule entry points.
  /// Never uses route-arg photos (they can be stale).
  String? _coachPhotoUrl(WidgetRef ref) {
    final coachId = controller.adminId;
    final userId = ref.watch(authUserIdProvider);
    if (userId != null) {
      final myCoach = ref.watch(myCoachProvider(userId));
      if (myCoach is MyCoachReady && myCoach.coach.id == coachId) {
        return myCoach.coach.photoUrl;
      }
    }
    return ref.watch(coachProfileProvider(coachId)).asData?.value?.profileImageUrl;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final chatState = ref.watch(chatControllerProvider(controller.adminId));
    final name = chatState.participantName;
    final photoUrl = _coachPhotoUrl(ref);
    final canCall = !isStartingCall && !chatState.isAccountDeleted;
    final selectionMode = chatState.selectionMode;
    final selectedCount = chatState.selectedIds.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.smd,
        AppSpacing.sm,
        AppSpacing.smd,
        AppSpacing.xs,
      ),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smd),
        child: SizedBox(
          height: _height,
          child: selectionMode
              ? Row(
                  children: [
                    GlassIconButton(
                      icon: Icons.close_rounded,
                      color: colors.onBackground,
                      tooltip: 'Cancel',
                      onPressed: controller.clearSelection,
                    ),
                    const SizedBox(width: AppSpacing.smd),
                    Expanded(
                      child: Text(
                        '$selectedCount selected',
                        style: textTheme.titleMedium!.copyWith(
                          color: colors.onBackground,
                        ),
                      ),
                    ),
                    if (selectedCount == 1)
                      GlassIconButton(
                        icon: Icons.copy_rounded,
                        color: colors.onBackground,
                        tooltip: 'Copy',
                        onPressed: () => _copySelected(context, ref),
                      ),
                    if (selectedCount == 1) const SizedBox(width: 6),
                    GlassIconButton(
                      icon: Icons.delete_outline_rounded,
                      color: colors.error,
                      tooltip: 'Delete',
                      onPressed: () => _confirmDeleteSelected(context, ref),
                    ),
                  ],
                )
              : Row(
                  children: [
                    const YeetBackButton(),
                    const SizedBox(width: AppSpacing.smd),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ChatParticipantAvatar(
                          name: name,
                          photoUrl: photoUrl,
                        ),
                        if (chatState.participantTyping)
                          Positioned(
                            right: -1,
                            bottom: -1,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: colors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.surface,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.smd),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium!.copyWith(
                              color: colors.onBackground,
                            ),
                          ),
                          Text(
                            chatState.participantTyping ? 'typing…' : 'Coach',
                            style: textTheme.bodySmall!.copyWith(
                              color: chatState.participantTyping
                                  ? colors.success
                                  : colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GlassIconButton(
                      icon: Icons.call_outlined,
                      color: colors.onBackground,
                      tooltip: 'Audio call',
                      onPressed: canCall ? onAudioCall : null,
                    ),
                    const SizedBox(width: 6),
                    GlassIconButton(
                      icon: Icons.videocam_outlined,
                      color: colors.onBackground,
                      tooltip: 'Video call',
                      onPressed: canCall ? onVideoCall : null,
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: colors.onBackground,
                      ),
                      color: colors.surface,
                      onSelected: (value) {
                        if (value == 'delete') {
                          _confirmClearChat(context, ref);
                        }
                        if (value == 'schedule') onScheduleSession?.call();
                      },
                      itemBuilder: (context) => [
                        if (onScheduleSession != null)
                          PopupMenuItem(
                            value: 'schedule',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_calendar_outlined,
                                  color: colors.onBackground,
                                  size: 20,
                                ),
                                const SizedBox(width: AppSpacing.smd),
                                Text(
                                  'Schedule session',
                                  style: textTheme.bodyLarge!.copyWith(
                                    color: colors.onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete Chat',
                            style: textTheme.bodyLarge!.copyWith(
                              color: colors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
