import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/gradient_text.dart';

class WelcomeText extends StatelessWidget {
  final String name;

  const WelcomeText({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return GradientText(
      text: 'Welcome, $name!',
      style: AppTheme.textStyles['heading']!.copyWith(
        fontSize: 28.sp,
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
