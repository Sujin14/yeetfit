import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/shared/widgets/yeet_confirm_dialog.dart';
import '../../domain/entities/coach.dart';
import '../providers/coach_provider.dart';

/// Enabled only once both the client's coach and any pending request have
/// loaded and neither blocks a new request.
class RequestCoachButton extends ConsumerWidget {
  final Coach coach;
  final String clientUid;
  final AsyncValue<String?> currentCoachId;
  final double width;
  final double height;

  const RequestCoachButton({
    super.key,
    required this.coach,
    required this.clientUid,
    required this.currentCoachId,
    this.width = 148,
    this.height = 36,
  });

  String get _coachName => coach.name.isEmpty ? 'this coach' : coach.name;

  Future<void> _request(BuildContext context, WidgetRef ref) async {
    final colors = Theme.of(context).extension<AppColors>()!;
    final controller = ref.read(
      coachRequestControllerProvider(coach.uid).notifier,
    );
    final confirmed = await showYeetConfirmDialog(
      context,
      title: 'Request Coach',
      message: 'Send a coaching request to $_coachName?',
      confirmLabel: 'Confirm',
      confirmColor: colors.primary,
    );
    if (!confirmed) return;

    final sent = await controller.request(clientUid);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            sent
                ? 'Request sent to $_coachName.'
                : 'Failed to send request. Please try again.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingRequest = ref.watch(
      pendingCoachRequestProvider((clientUid: clientUid, coachId: coach.uid)),
    );
    final isSending = ref
        .watch(coachRequestControllerProvider(coach.uid))
        .isLoading;
    final assignedCoachId = currentCoachId.value;
    final isPending = pendingRequest.value ?? false;

    final label = switch (assignedCoachId) {
      _ when isPending => 'Request Pending',
      final id? when id == coach.uid => 'Your coach',
      _? => 'Coach assigned',
      null => 'Request Coach',
    };
    final canRequest =
        currentCoachId.hasValue &&
        pendingRequest.hasValue &&
        assignedCoachId == null &&
        !isPending;

    return SizedBox(
      width: width,
      child: GradientButton(
        label: label,
        height: height,
        borderRadius: height / 2,
        isLoading: isSending,
        onPressed: canRequest ? () => _request(context, ref) : null,
      ),
    );
  }
}
