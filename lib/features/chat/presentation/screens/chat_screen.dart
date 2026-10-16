import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/call_route_constants.dart';
import 'package:yeetfit/core/routes/session_route_constants.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/features/calls/domain/entities/call_participant.dart';
import 'package:yeetfit/features/calls/domain/entities/call_type.dart';
import 'package:yeetfit/features/calls/presentation/providers/call_launcher_provider.dart';
import 'package:yeetfit/features/calls/presentation/utils/call_error_message.dart';
import 'package:yeetfit/shared/providers/user_role_provider.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_body.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String adminId;

  const ChatScreen({super.key, required this.adminId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chatControllerProvider(widget.adminId).notifier).setupChat();
    });
  }

  void _showError(String message) {
    final colors = Theme.of(context).extension<AppColors>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _startCall(CallType type) async {
    final chatState = ref.read(chatControllerProvider(widget.adminId));
    final call = await ref
        .read(callLauncherProvider.notifier)
        .start(
          receiver: CallParticipant(
            id: widget.adminId,
            name: chatState.participantName,
            photoUrl: chatState.participantImage,
          ),
          type: type,
        );
    if (call == null || !mounted) return;
    context.push(CallRouteConstants.activeCallPath(call.id), extra: call);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = chatControllerProvider(widget.adminId);
    final chatState = ref.watch(chatProvider);
    final controller = ref.read(chatProvider.notifier);
    final isStartingCall = ref.watch(callLauncherProvider).isLoading;
    final isAdmin = ref.watch(isAdminProvider).value ?? false;

    ref.listen(chatProvider.select((state) => state.error), (_, error) {
      if (error != null) _showError(error);
    });
    ref.listen(callLauncherProvider, (_, next) {
      final error = next.error;
      if (error != null && !next.isLoading) _showError(callErrorMessage(error));
    });

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: ChatBody(
          messages: chatState.messages,
          isLoadingMessages: chatState.isLoadingMessages,
          participantTyping: chatState.participantTyping,
          isAccountDeleted: chatState.isAccountDeleted,
          controller: controller,
          isStartingCall: isStartingCall,
          onAudioCall: () => _startCall(CallType.audio),
          onVideoCall: () => _startCall(CallType.video),
          onScheduleSession: isAdmin
              ? () => context.push(SessionRouteConstants.create)
              : null,
        ),
      ),
    );
  }
}
