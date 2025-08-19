import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/welcome_button.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Dynamic sizing based on screen height
          final maxHeight = constraints.maxHeight;
          final maxImageHeight = maxHeight * (kIsWeb ? 0.5 : 0.45);
          // Max button width for responsiveness
          final maxButtonWidth = kIsWeb ? 300.w : 250.w;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/images/welcome1.png',
                  width: double.infinity,
                  height: maxImageHeight.clamp(200.h, kIsWeb ? 500.h : 400.h),
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: kIsWeb ? 40.w : 24.w,
                    vertical: kIsWeb ? 20.h : 16.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: GradientText(
                          text: 'Welcome to YeetFit!',
                          style: AppTheme.textStyles['heading']!.copyWith(
                            fontSize: (kIsWeb ? 36.sp : 32.sp).clamp(24.0, 36.0),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.colors['proteinProgress']!,
                              AppTheme.colors['carbsProgress']!,
                              AppTheme.colors['fatProgress']!,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 12.h : 8.h),
                      Text(
                        'Start your fitness journey today',
                        style: AppTheme.textStyles['subtitle']!.copyWith(
                          fontSize: (kIsWeb ? 20.sp : 18.sp).clamp(16.0, 20.0),
                          color: AppTheme.colors['primaryText'],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: kIsWeb ? 20.h : 16.h),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 80.w),
                        child: WelcomeButton(
                          label: 'Log In',
                          onPressed: () => context.push('/login'),
                          color: AppTheme.colors['white']!,
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 12.h : 8.h),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 80.w),
                        child: WelcomeButton(
                          label: 'Sign Up',
                          onPressed: () => context.push('/signup'),
                          color: AppTheme.colors['white']!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}