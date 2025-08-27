// calorie_appbar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class CalorieAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CalorieAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.colors['transparent'],
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go('/user-dashboard'),
      ),
      title: Text(
        "Meal Tracking",
        style: GoogleFonts.roboto(
          color: AppTheme.colors['onSurface'],
          fontSize: FixedSizes.font20(context),
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}
