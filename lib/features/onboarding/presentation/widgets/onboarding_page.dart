import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/gradient_text.dart';

// Individual page for onboarding content.
class OnboardingPage extends StatelessWidget {
  final String imagePath, title, description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  // Helper to get responsive values based on platform (web vs mobile).
  double _responsiveValue(double webValue, double mobileValue) {
    return kIsWeb ? webValue : mobileValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxHeight = constraints.maxHeight;
            final maxImageHeight = maxHeight * (_responsiveValue(0.35, 0.3));
            final fontSize = _responsiveValue(80.sp, 70.sp).clamp(30.0, 60.0);

            return Column(
              children: [
                // App name header.
                Expanded(
                  flex: 2,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Yeet',
                              style: GoogleFonts.fredoka(
                                color: AppTheme.colors['fullProgress'],
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Fit',
                              style: GoogleFonts.fredoka(
                                color: AppTheme.colors['black'],
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        softWrap: false,
                      ),
                    ),
                  ),
                ),
                // Image.
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    height: maxImageHeight.clamp(150.h, _responsiveValue(350.h, 300.h)),
                    width: constraints.maxWidth,
                  ),
                ),
                // Title and description.
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _responsiveValue(40.w, 32.w),
                      vertical: _responsiveValue(20.h, 16.h),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GradientText(
                          text: title,
                          style: AppTheme.textStyles['heading']!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: _responsiveValue(28.sp, 24.sp).clamp(20.0, 28.0),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.colors['fullProgress']!,
                              AppTheme.colors['halfProgress']!,
                              AppTheme.colors['error']!,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        SizedBox(height: _responsiveValue(12.h, 8.h)),
                        GradientText(
                          text: description,
                          style: AppTheme.textStyles['body']!.copyWith(
                            fontSize: _responsiveValue(18.sp, 16.sp).clamp(14.0, 18.0),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.colors['indigo']!,
                              AppTheme.colors['caloriesProgress']!,
                              AppTheme.colors['carbsProgress']!,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
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
      ),
    );
  }
}