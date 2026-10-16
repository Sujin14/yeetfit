import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore Plans',
                  style: textTheme.headlineLarge!.copyWith(
                    color: colors.onBackground,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Find your next workout',
                  style: textTheme.bodyMedium!.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GlassIconButton(
            icon: Icons.search_rounded,
            color: colors.onBackground,
            tooltip: 'Search',
          ),
        ],
      ),
    );
  }
}
