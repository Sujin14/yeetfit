import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/shell_route_constants.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';
import '../controllers/chat_controller.dart';
import '../providers/chat_provider.dart';
import 'chat_delete_dialog.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ChatDeleteDialog(),
    );
    if (confirmed != true) return;
    final deleted = await controller.deleteChats();
    if (!context.mounted) return;
    if (deleted) {
      context.go(ShellRouteConstants.dashboard);
      return;
    }
    final error = ref.read(chatControllerProvider(controller.adminId)).error;
    if (error != null) {
      final colors = Theme.of(context).extension<AppColors>()!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: colors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final chatState = ref.watch(chatControllerProvider(controller.adminId));
    final name = chatState.participantName;
    final image = chatState.participantImage;
    final canCall = !isStartingCall && !chatState.isAccountDeleted;

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
          child: Row(
            children: [
              const YeetBackButton(),
              const SizedBox(width: AppSpacing.smd),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: colors.primary.withValues(alpha: 0.25),
                    foregroundImage: image.isNotEmpty
                        ? CachedNetworkImageProvider(image)
                        : null,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: textTheme.titleMedium!.copyWith(
                        color: colors.onBackground,
                      ),
                    ),
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
                          border: Border.all(color: colors.surface, width: 2),
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
                icon: Icon(Icons.more_vert, color: colors.onBackground),
                color: colors.surface,
                onSelected: (value) {
                  if (value == 'delete') _confirmDelete(context, ref);
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
                      style: textTheme.bodyLarge!.copyWith(color: colors.error),
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
