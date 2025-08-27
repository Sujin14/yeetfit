import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/welcome_button.dart';
import '../../../../utils/fixed_sizes.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Image
          Expanded(
            flex: 3,
            child: Image.asset(
              'assets/images/welcome1.png',
              width: double.infinity,
              height: maxHeight * 0.45,
              fit: BoxFit.contain,
            ),
          ),

          // Bottom Content
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: FixedSizes.box24(context),
                vertical: FixedSizes.box16(context),
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
                        fontSize: FixedSizes.fontHeading(context),
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
                  SizedBox(height: FixedSizes.box12(context)),

                  Text(
                    'Start your fitness journey today',
                    style: AppTheme.textStyles['subtitle']!.copyWith(
                      fontSize: FixedSizes.fontSubtitle(context),
                      color: AppTheme.colors['primaryText'],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: FixedSizes.box20(context)),

                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: FixedSizes.welcomeButtonWidth(context),
                    ),
                    child: WelcomeButton(
                      label: 'Log In',
                      onPressed: () => context.push('/login'),
                      color: AppTheme.colors['white']!,
                    ),
                  ),
                  SizedBox(height: FixedSizes.box12(context)),

                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: FixedSizes.welcomeButtonWidth(context),
                    ),
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
      ),
    );
  }
}
