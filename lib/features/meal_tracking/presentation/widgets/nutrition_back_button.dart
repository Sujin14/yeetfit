import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class NutritionBackButton extends StatelessWidget {
  final bool isLargeScreen;

  const NutritionBackButton({super.key, required this.isLargeScreen});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: isLargeScreen ? 300 : double.infinity,
        child: GlassmorphicContainer(
          color: AppTheme.colors['indigo']!,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors['transparent'],
              elevation: 0,
            ),
            onPressed: () => context.go('/modal/food'),
            child: Text(
              'Back',
              style: GoogleFonts.roboto(
                fontSize: isLargeScreen ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.colors['onSurface'],
              ),
            ),
          ),
        ),
      ),
    );
  }
}