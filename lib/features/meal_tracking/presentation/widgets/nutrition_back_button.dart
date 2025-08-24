import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';

class NutritionBackButton extends StatelessWidget {
  final bool isLargeScreen;

  const NutritionBackButton({super.key, required this.isLargeScreen});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppTheme.colors['onSurface'],
      ),
      onPressed: () => context.go('/modal/food'),
    );
  }
}