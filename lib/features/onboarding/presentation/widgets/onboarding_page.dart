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
        child: Column(
          children: [
            const Spacer(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Yeet',
                    style: GoogleFonts.fredoka(
                      color: Colors.green,
                      fontSize: 70.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Fit',
                    style: GoogleFonts.fredoka(
                      color: Colors.black,
                      fontSize: 70.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 300.h,
              width: double.infinity,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GradientText(
                    text: title,
                    style: AppTheme.textStyles['heading']!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.yellow, Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GradientText(
                    text: description,
                    style: AppTheme.textStyles['body']!,
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.blue, Colors.yellow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
