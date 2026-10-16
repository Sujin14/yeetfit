import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/workout_log/presentation/widgets/log_workout_button.dart';
import 'package:yeetfit/shared/widgets/yeet_error_state.dart';
import '../providers/recovery_provider.dart';
import 'recovery_locked_state.dart';
import 'recovery_score_body.dart';
import 'recovery_shimmer.dart';

/// Today's score for [userId], recalculated each time this is shown.
class RecoveryScoreContent extends ConsumerStatefulWidget {
  final String userId;

  const RecoveryScoreContent({super.key, required this.userId});

  @override
  ConsumerState<RecoveryScoreContent> createState() =>
      _RecoveryScoreContentState();
}

class _RecoveryScoreContentState extends ConsumerState<RecoveryScoreContent> {
  @override
  void initState() {
    super.initState();
    // The dashboard may already hold a result from earlier; providers can't
    // be invalidated mid-build, so refresh after this frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.invalidate(calculateRecoveryProvider(widget.userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the calculation alive; its saved result arrives through
    // recoveryScoreProvider, and a locked failure just leaves that null.
    ref.listen(calculateRecoveryProvider(widget.userId), (_, _) {});
    final scoreAsync = ref.watch(recoveryScoreProvider(widget.userId));

    return scoreAsync.when(
      data: (score) => score == null
          ? RecoveryLockedState(action: LogWorkoutButton(userId: widget.userId))
          : RecoveryScoreBody(score: score, userId: widget.userId),
      loading: () => const RecoveryShimmer(),
      error: (error, _) => YeetErrorState(
        message: 'Could not load your recovery score: $error',
        onRetry: () => ref
          ..invalidate(recoveryScoreProvider(widget.userId))
          ..invalidate(calculateRecoveryProvider(widget.userId)),
      ),
    );
  }
}
