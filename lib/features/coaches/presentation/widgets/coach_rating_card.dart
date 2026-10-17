import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import '../providers/coach_provider.dart';

class CoachRatingCard extends ConsumerStatefulWidget {
  final String coachUid;
  final String clientUid;

  const CoachRatingCard({
    super.key,
    required this.coachUid,
    required this.clientUid,
  });

  @override
  ConsumerState<CoachRatingCard> createState() => _CoachRatingCardState();
}

class _CoachRatingCardState extends ConsumerState<CoachRatingCard> {
  bool _saving = false;

  Future<void> _rate(int stars) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await submitCoachRating(
        coachUid: widget.coachUid,
        clientUid: widget.clientUid,
        stars: stars,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final ratingAsync = ref.watch(
      clientRatingProvider((
        coachUid: widget.coachUid,
        clientUid: widget.clientUid,
      )),
    );
    final currentRating = ratingAsync.asData?.value ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.sm,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate Your Coach',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              currentRating > 0
                  ? 'Your rating: $currentRating / 5  •  Tap to change'
                  : 'Your rating is anonymous to your coach',
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final filled = i < currentRating;
                return GestureDetector(
                  onTap: _saving ? null : () => _rate(i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 36,
                      color: filled ? colors.warning : colors.textMuted,
                    ),
                  ),
                );
              }),
            ),
            if (_saving) ...[
              const SizedBox(height: 8),
              Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
