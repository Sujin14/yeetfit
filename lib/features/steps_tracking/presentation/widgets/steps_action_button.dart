import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class StepsActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StepsActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppTheme.colors['indigo']!.withOpacity(0.3),
      onPressed: onPressed,
      child: Icon(
        Icons.add,
        size: FixedSizes.icon24(context),
        color: AppTheme.colors['onSurface'],
      ),
    );
  }
}
