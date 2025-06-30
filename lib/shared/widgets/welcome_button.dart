import 'package:flutter/material.dart';
import '../theme/theme.dart';

class WelcomeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const WelcomeButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.colors['primaryButton'],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: AppTheme.textStyles['body']!.copyWith(
          color: color,
          fontSize: 16,
        ),
      ),
    );
  }
}
