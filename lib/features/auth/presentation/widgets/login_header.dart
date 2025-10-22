import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/widget_styles.dart';
import '../../../../shared/theme/theme.dart';

class LoginHeader extends StatefulWidget {
  const LoginHeader({super.key});

  @override
  State<LoginHeader> createState() => _LoginHeaderState();
}

class _LoginHeaderState extends State<LoginHeader> {
  bool _showSubtitle = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: WidgetStyles.formPadding(kIsWeb),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Welcome Back',
                textStyle: AppTheme.textStyles['heading']!.copyWith(
                  fontSize: (kIsWeb ? 28.sp : 26.sp).clamp(22.0, 28.0),
                  color: AppTheme.colors['primaryText'],
                ),
                speed: const Duration(milliseconds: 300),
                cursor: '_',
              ),
            ],
            isRepeatingAnimation: false,
            totalRepeatCount: 1,
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
            onFinished: () {
              setState(() {
                _showSubtitle = true;
              });
            },
          ),
          SizedBox(height: 8.h),
          if (_showSubtitle)
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Login to your account',
                  textStyle: AppTheme.textStyles['subtitle']!.copyWith(
                    fontSize: 16.sp,
                    color: AppTheme.colors['secondaryText'],
                  ),
                  speed: const Duration(milliseconds: 200),
                  cursor: '_',
                ),
              ],
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
        ],
      ),
    );
  }
}