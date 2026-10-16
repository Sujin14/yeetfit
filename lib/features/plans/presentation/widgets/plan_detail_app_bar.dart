import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/core/routes/shell_route_constants.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';
import 'plan_detail_hero_background.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class PlanDetailAppBar extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const PlanDetailAppBar({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: colors.gradientStart,
      surfaceTintColor: Colors.transparent,
      leadingWidth: YeetBackButton.leadingWidth,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.md),
        child: Center(
          child: YeetBackButton(
            onTap: () => context.canPop()
                ? context.pop()
                : context.go(ShellRouteConstants.explore),
          ),
        ),
      ),
      actions: [
        GlassIconButton(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? colors.error : Colors.white,
          tooltip: isFavorite ? 'Remove from favourites' : 'Add to favourites',
          onPressed: onToggleFavorite,
        ),
        const SizedBox(width: AppSpacing.smd),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(
          start: YeetBackButton.leadingWidth + 8,
          end: 56,
          bottom: 16,
        ),
        expandedTitleScale: 1.3,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
        background: PlanDetailHeroBackground(imageUrl: imageUrl),
      ),
    );
  }
}
