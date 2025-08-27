// login_body.dart
import 'package:flutter/material.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import 'login_form.dart';
import 'login_header.dart';
import 'login_options_divider.dart';
import 'login_social_buttons.dart';
import 'signup_redirect.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign in',
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
          const LoginHeader(),
          SizedBox(height: FixedSizes.box40(context)),
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
                    const LoginForm(),
                    SizedBox(height: FixedSizes.box30(context)),
                    const LoginOptionsDivider(),
                    SizedBox(height: FixedSizes.box30(context)),
                    const LoginSocialButtons(),
                    SizedBox(height: FixedSizes.box30(context)),
                    const Center(child: SignupRedirect()),
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
