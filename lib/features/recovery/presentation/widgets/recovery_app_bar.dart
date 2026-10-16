import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Transparent app bar so the gradient background shows through.
class RecoveryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RecoveryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      title: Text(
        'Recovery Score',
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(color: colors.onBackground),
      ),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leadingWidth: YeetBackButton.leadingWidth,
      leading: const Padding(
        padding: EdgeInsets.only(left: AppSpacing.md),
        child: Center(child: YeetBackButton()),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
