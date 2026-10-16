import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/call_route_constants.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_status.dart';
import '../providers/call_provider.dart';
import '../providers/incoming_call_controller.dart';
import '../utils/call_error_message.dart';
import '../utils/close_call_route.dart';
import '../widgets/incoming_call_body.dart';

class IncomingCallScreen extends ConsumerWidget {
  final CallSession call;

  const IncomingCallScreen({super.key, required this.call});

  Future<void> _accept(BuildContext context, WidgetRef ref) async {
    final accepted = await ref
        .read(incomingCallControllerProvider(call.id).notifier)
        .accept();
    if (!accepted || !context.mounted) return;
    context.pushReplacement(
      CallRouteConstants.activeCallPath(call.id),
      extra: call,
    );
  }

  Future<void> _decline(BuildContext context, WidgetRef ref) async {
    await ref.read(incomingCallControllerProvider(call.id).notifier).decline();
    if (context.mounted) closeCallRoute(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerProvider = incomingCallControllerProvider(call.id);
    final isBusy = ref.watch(controllerProvider).isLoading;
    final latest = ref.watch(activeCallProvider(call.id)).value ?? call;

    // Declined here, or the caller hung up / the ring timed out.
    ref.listen(activeCallProvider(call.id), (_, next) {
      if (!next.hasValue) return;
      final status = next.value?.status;
      if (status != null && !status.isFinished) return;
      closeCallRoute(
        context,
        message: status == CallStatus.missed || status == CallStatus.ended
            ? 'Missed call from ${call.caller.name}'
            : null,
      );
    });
    ref.listen(controllerProvider, (_, next) {
      final error = next.error;
      if (error != null) {
        closeCallRoute(context, message: callErrorMessage(error));
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _decline(context, ref);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ShellGradientBackground(
          child: IncomingCallBody(
            call: latest,
            isBusy: isBusy,
            onAccept: () => _accept(context, ref),
            onDecline: () => _decline(context, ref),
          ),
        ),
      ),
    );
  }
}
