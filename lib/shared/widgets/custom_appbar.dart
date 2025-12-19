import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showFavorite;
  final bool isFavorite;
  final VoidCallback? onFavorite;
  final bool showCalendar;
  final VoidCallback? onCalendar;
  final Color? favoriteColor;
  final GlobalKey<ScaffoldState>? scaffoldKey; // for opening drawer

  const CustomAppBar({
    super.key,
    required this.title,
    this.showFavorite = false,
    this.isFavorite = false,
    this.favoriteColor,
    this.onFavorite,
    this.showCalendar = false,
    this.onCalendar,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.colors['navigationAccent'],
      elevation: 5,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu, color: AppTheme.colors['primaryText']),
        onPressed: () => scaffoldKey?.currentState?.openDrawer(),
      ),
      title: Text(
        title,
        style: AppTheme.textStyles['title']!.copyWith(
          fontSize: 20.sp,
          color: AppTheme.colors['primaryText'],
        ),
      ),
      iconTheme: IconThemeData(color: AppTheme.colors['primaryText']),
      actions: [
        if (showFavorite)
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite
                  ? (favoriteColor ?? AppTheme.colors['error'])
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
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
