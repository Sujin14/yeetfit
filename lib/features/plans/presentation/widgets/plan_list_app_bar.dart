import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class PlanListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const PlanListAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leadingWidth: YeetBackButton.leadingWidth,
      leading: const Padding(
        padding: EdgeInsets.only(left: AppSpacing.md),
        child: Center(child: YeetBackButton()),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
          fontSize: 28,
          color: colors.onBackground,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
