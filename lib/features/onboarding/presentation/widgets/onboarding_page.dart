import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/gradient_text.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath, title, description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Dynamic sizing based on screen height
            final maxHeight = constraints.maxHeight;
            final maxImageHeight = maxHeight * (kIsWeb ? 0.35 : 0.3);
            final fontSize = (kIsWeb ? 80.sp : 70.sp).clamp(
              30.0,
              60.0,
            ); // Cap font size

            return Column(
              children: [
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
                        softWrap: false, // Prevent text wrapping
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    height: maxImageHeight.clamp(150.h, kIsWeb ? 350.h : 300.h),
                    width: constraints.maxWidth,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: kIsWeb ? 40.w : 32.w,
                      vertical: kIsWeb ? 20.h : 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GradientText(
                          text: title,
                          style: AppTheme.textStyles['heading']!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: (kIsWeb ? 28.sp : 24.sp).clamp(
                              20.0,
                              28.0,
                            ),
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
                        SizedBox(height: kIsWeb ? 12.h : 8.h),
                        GradientText(
                          text: description,
                          style: AppTheme.textStyles['body']!.copyWith(
                            fontSize: (kIsWeb ? 18.sp : 16.sp).clamp(
                              14.0,
                              18.0,
                            ),
                          ),
                          gradient: const LinearGradient(
                            colors: [
                              Colors.deepPurple,
                              Colors.blue,
                              Colors.yellow,
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
