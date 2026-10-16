import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/yeet_back_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// App bar shared by the settings screens. Pops by default; pass [onBack]
/// to navigate somewhere specific instead.
class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final bool centerTitle;

  const SettingsAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(color: colors.onBackground),
      ),
      centerTitle: centerTitle,
      backgroundColor: colors.background,
      elevation: 0,
      leadingWidth: YeetBackButton.leadingWidth,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.md),
        child: Center(child: YeetBackButton(onTap: onBack)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
