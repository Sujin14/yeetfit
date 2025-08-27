// sign_up_body.dart
import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import 'login_options_divider.dart';
import 'login_social_buttons.dart';
import 'sign_in_redirect.dart';
import 'sign_up_form.dart';
import 'sign_up_header.dart';

class SignUpBody extends StatelessWidget {
  const SignUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Registration',
          style: AppTheme.textStyles['titleMedium']!.copyWith(
            fontSize: FixedSizes.fontTitle(context),
            color: AppTheme.colors['primaryText'],
          ),
        ),
        backgroundColor: AppTheme.colors['transparent']!,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SignUpHeader(),
          SizedBox(height: FixedSizes.box30(context)),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(FixedSizes.borderRadius(context)),
                  topRight: Radius.circular(FixedSizes.borderRadius(context)),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: FixedSizes.box24(context),
                vertical: FixedSizes.box20(context),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: FixedSizes.formMaxWidth(context),
                      ),
                      child: const SignUpForm(),
                    ),
                    SizedBox(height: FixedSizes.box30(context)),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: FixedSizes.formMaxWidth(context),
                      ),
                      child: const LoginOptionsDivider(),
                    ),
                    SizedBox(height: FixedSizes.box30(context)),
                    const LoginSocialButtons(),
                    SizedBox(height: FixedSizes.box30(context)),
                    const Center(child: SignInRedirect()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
