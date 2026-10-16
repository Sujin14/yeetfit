import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Transparent Liquid Glass app bar.
///
/// Shows a drawer menu button when [scaffoldKey] is provided; otherwise falls
/// back to the default back button for pushed routes.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCalendar;
  final VoidCallback? onCalendar;
  final bool showCoachChat;
  final VoidCallback? onCoachChat;

  /// Wraps the coach chat button, e.g. to spotlight it in a tour.
  final Widget Function(Widget button)? coachChatWrapper;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showCalendar = false,
    this.onCalendar,
    this.showCoachChat = false,
    this.onCoachChat,
    this.coachChatWrapper,
    this.scaffoldKey,
  });

  static const double _height = 56;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final coachChatButton = GlassIconButton(
      icon: Icons.forum_outlined,
      color: colors.onBackground,
      tooltip: 'Coach chat',
      onPressed: onCoachChat,
    );
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: _height,
      centerTitle: true,
      foregroundColor: colors.onBackground,
      leading: scaffoldKey == null
          ? null
          : Center(
              child: GlassIconButton(
                icon: Icons.menu,
                color: colors.onBackground,
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                onPressed: () => scaffoldKey!.currentState?.openDrawer(),
              ),
            ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(color: colors.onBackground),
      ),
      actions: [
        if (showCoachChat)
          coachChatWrapper?.call(coachChatButton) ?? coachChatButton,
        if (showCoachChat && showCalendar) const SizedBox(width: AppSpacing.sm),
        if (showCalendar)
          GlassIconButton(
            icon: Icons.calendar_month_rounded,
            color: colors.onBackground,
            onPressed: onCalendar,
          ),
        const SizedBox(width: AppSpacing.smd),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_height);
}
