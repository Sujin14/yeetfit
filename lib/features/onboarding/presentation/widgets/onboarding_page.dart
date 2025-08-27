import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../utils/fixed_sizes.dart';

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
            final maxHeight = constraints.maxHeight;
            final maxImageHeight = maxHeight * (kIsWeb ? 0.35 : 0.3);

            // Heading font size
            final fontSize = kIsWeb
                ? FixedSizes.font40(context)
                : FixedSizes.font35(context);

            return Column(
              children: [
                // App name
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

                // Image
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    height: maxImageHeight.clamp(
                      FixedSizes.box100(context) * 1.5,
                      kIsWeb
                          ? FixedSizes.box100(context) * 3.5
                          : FixedSizes.box100(context) * 3,
                    ),
                    width: constraints.maxWidth,
                  ),
                ),

                // Title + description
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: kIsWeb
                          ? FixedSizes.spacing(context) * 3
                          : FixedSizes.spacing(context) * 2.5,
                      vertical: kIsWeb
                          ? FixedSizes.spacing(context) * 1.5
                          : FixedSizes.spacing(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GradientText(
                          text: title,
                          style: AppTheme.textStyles['heading']!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: kIsWeb
                                ? FixedSizes.font22(context)
                                : FixedSizes.font18(context),
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
                        SizedBox(height: FixedSizes.spacing(context) / 1.5),
                        GradientText(
                          text: description,
                          style: AppTheme.textStyles['body']!.copyWith(
                            fontSize: kIsWeb
                                ? FixedSizes.font18(context)
                                : FixedSizes.font16(context),
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
