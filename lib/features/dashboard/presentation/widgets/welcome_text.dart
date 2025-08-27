// features/dashboard/presentation/widgets/welcome_text.dart
import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../../../shared/widgets/gradient_text.dart';

class WelcomeText extends StatelessWidget {
  final String name;

  const WelcomeText({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return GradientText(
      text: 'Welcome, $name!',
      style: AppTheme.textStyles['heading']!.copyWith(
        fontSize: FixedSizes.font22(context),
        color: AppTheme.colors['primaryText'],
      ),
      gradient: LinearGradient(
        colors: [
          AppTheme.colors['gradientTextStart']!,
          AppTheme.colors['gradientTextMiddle']!,
          AppTheme.colors['gradientTextEnd']!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}
