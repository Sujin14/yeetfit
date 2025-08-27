import 'package:flutter/material.dart';
import '../../utils/fixed_sizes.dart';
import '../theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSettings;
  final VoidCallback? onSettings;
  final bool showFavorite;
  final bool isFavorite;
  final VoidCallback? onFavorite;
  final bool showCalendar;
  final VoidCallback? onCalendar;
  final Color? favoriteColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showSettings = false,
    this.onSettings,
    this.showFavorite = false,
    this.isFavorite = false,
    this.favoriteColor,
    this.onFavorite,
    this.showCalendar = false,
    this.onCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.colors['navigationAccent'],
      elevation: 5,
      title: Text(
        title,
        style: AppTheme.textStyles['title']!.copyWith(
          fontSize: FixedSizes.font20(context),
          color: AppTheme.colors['primaryText'],
        ),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: AppTheme.colors['primaryText']),
      actions: [
        if (showFavorite)
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite
                  ? AppTheme.colors['error']
                  : AppTheme.colors['primaryText'],
            ),
            onPressed: onFavorite,
          ),
        if (showCalendar)
          IconButton(
            icon: Icon(
              Icons.calendar_month_rounded,
              color: AppTheme.colors['primaryText'],
            ),
            onPressed: onCalendar,
          ),
        if (showSettings)
          IconButton(
            icon: Icon(Icons.person, color: AppTheme.colors['primaryText']),
            onPressed: onSettings,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
