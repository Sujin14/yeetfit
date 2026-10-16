import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ChallengeLeaderboardRow extends StatelessWidget {
  final int rank;
  final String name;
  final String value;
  final bool isCurrentUser;

  const ChallengeLeaderboardRow({
    super.key,
    required this.rank,
    required this.name,
    required this.value,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final rankColor = rank <= 3 ? colors.warning : colors.textSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.smd,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(color: colors.primary.withValues(alpha: 0.6))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$rank',
              style: textTheme.titleMedium!.copyWith(color: rankColor),
            ),
          ),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge!.copyWith(
                color: isCurrentUser ? colors.primary : colors.onBackground,
                fontWeight: isCurrentUser ? FontWeight.w600 : null,
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.titleMedium!.copyWith(color: colors.onBackground),
          ),
        ],
      ),
    );
  }
}
