import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Transparent floating app bar for scrollable pushed screens.
class GlassSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  /// Overrides the default back behaviour (pop, else dashboard).
  final VoidCallback? onBack;

  const GlassSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SliverAppBar(
      floating: true,
      snap: true,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: colors.onBackground),
      actionsIconTheme: IconThemeData(color: colors.onBackground),
      leadingWidth: YeetBackButton.leadingWidth,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.md),
        child: Center(child: YeetBackButton(onTap: onBack)),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(color: colors.onBackground),
      ),
      actions: actions,
    );
  }
}
