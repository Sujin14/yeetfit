import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/welcome_button.dart';

class WelcomeBody extends StatefulWidget {
  const WelcomeBody({super.key});

  @override
  State<WelcomeBody> createState() => _WelcomeBodyState();
}

class _WelcomeBodyState extends State<WelcomeBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _imageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6)),
    );
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.8)),
    );
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0)),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final maxImageHeight =
              maxHeight * (kIsWeb ? 0.4 : 0.35); // Reduced flex for balance
          final maxButtonWidth = kIsWeb
              ? 320.w
              : 280.w; // Slightly wider for icons

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2, // Reduced from 3 for better balance
                child: AnimatedBuilder(
                  animation: _imageAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50.h * (1 - _imageAnimation.value)),
                      child: Opacity(
                        opacity: _imageAnimation.value,
                        child: Image.asset(
                          'assets/images/welcome1.png',
                          width: double.infinity,
                          height: maxImageHeight.clamp(
                            180.h,
                            kIsWeb ? 450.h : 350.h,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: kIsWeb
                        ? 48.w
                        : 24.w, // More horizontal padding on web
                    vertical: kIsWeb ? 24.h : 20.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              30.h * (1 - _textAnimation.value),
                            ),
                            child: Opacity(
                              opacity: _textAnimation.value,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: GradientText(
                                  text: 'Welcome to YeetFit!',
                                  style: AppTheme.textStyles['heading']!
                                      .copyWith(
                                        fontSize: (kIsWeb ? 40.sp : 34.sp)
                                            .clamp(26.0, 40.0),
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
                            ),
                          );
                        },
                      ),
                      SizedBox(height: kIsWeb ? 16.h : 12.h),
                      AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _textAnimation.value,
                            child: Text(
                              'Start your fitness journey today',
                              style: AppTheme.textStyles['subtitle']!.copyWith(
                                fontSize: (kIsWeb ? 22.sp : 19.sp).clamp(
                                  17.0,
                                  22.0,
                                ),
                                color: AppTheme.colors['primaryText'],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: kIsWeb ? 32.h : 24.h),
                      AnimatedBuilder(
                        animation: _buttonAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _buttonAnimation.value,
                            child: Column(
                              children: [
                                // Primary Sign Up button
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: maxButtonWidth,
                                  ),
                                  child: WelcomeButton(
                                    label: 'Get Started',
                                    onPressed: () => context.push('/signup'),
                                    icon: Icons
                                        .fitness_center, // Fitness-themed icon
                                    isPrimary: true,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                // Divider
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: AppTheme.colors['primaryText']!
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                      ),
                                      child: Text(
                                        'or',
                                        style: AppTheme.textStyles['body']!
                                            .copyWith(
                                              color: AppTheme
                                                  .colors['primaryText']!
                                                  .withOpacity(0.6),
                                              fontSize: 14.sp,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: AppTheme.colors['primaryText']!
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                // Secondary Log In button
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: maxButtonWidth,
                                  ),
                                  child: WelcomeButton(
                                    label: 'Log In',
                                    onPressed: () => context.push('/login'),
                                    icon: Icons.login,
                                    foregroundColor:
                                        AppTheme.colors['primaryAccent'],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
