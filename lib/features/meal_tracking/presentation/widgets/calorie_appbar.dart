import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/food_provider.dart';

class CalorieAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CalorieAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(calorieTrackingProvider.notifier);
    return AppBar(
      backgroundColor: AppTheme.colors['transparent'],
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppTheme.colors['onSurface']),
        onPressed: () => controller.navigateBack(context),
      ),
      title: Text(
        "Meal Tracking",
        style: GoogleFonts.roboto(
          color: AppTheme.colors['onSurface'],
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}