import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/services/call_native_service.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_status.dart';
import '../providers/active_call_controller.dart';
import '../providers/active_call_state.dart';
import '../providers/call_provider.dart';
import '../utils/close_call_route.dart';
import '../widgets/active_call_body.dart';

class ActiveCallScreen extends ConsumerWidget {
  final CallSession call;

  const ActiveCallScreen({super.key, required this.call});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    if (userId == null) {
      return const Scaffold(
        body: SignInRequiredView(message: 'Please log in to make calls'),
      );
    }

    final isCaller = call.isCaller(userId);
    final controllerProvider = activeCallControllerProvider((
      callId: call.id,
      channelId: call.channelId,
      type: call.type,
      isCaller: isCaller,
    ));
    final state = ref.watch(controllerProvider);
    final controller = ref.read(controllerProvider.notifier);
    final latest = ref.watch(activeCallProvider(call.id)).value ?? call;

    // Either side ending the call (or the ring timing out) closes the screen.
    ref.listen(activeCallProvider(call.id), (_, next) {
      if (!next.hasValue) return;
      final status = next.value?.status;
      debugPrint('[YeetCall] ActiveCallScreen status: $status');
      if (status != null && !status.isFinished) return;
      debugPrint(
        '[YeetCall] Caller/callee ended call (status=$status) — dismissing',
      );
      unawaited(CallNativeService.clearLockScreenFlags());
      final otherName = call.otherParty(userId).name;
      final current = ref.read(controllerProvider);
      final message = current.phase == CallConnectionPhase.failed
          ? current.error
          : switch (status) {
              CallStatus.declined when isCaller =>
                '$otherName declined the call',
              CallStatus.missed when isCaller => 'No answer from $otherName',
              _ => null,
            };
      closeCallRoute(context, message: message);
    });

    return PopScope(
      // Calls end only through the end button.
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ActiveCallBody(
          call: latest,
          userId: userId,
          state: state,
          localRenderer: controller.localRenderer,
          remoteRenderer: controller.remoteRenderer,
          onToggleMute: controller.toggleMute,
          onToggleCamera: controller.toggleCamera,
          onToggleSpeaker: controller.toggleSpeaker,
          onSwitchCamera: controller.switchCamera,
          onEnd: () {
            controller.hangUp();
            closeCallRoute(context);
          },
        ),
      ),
    );
  }
}
