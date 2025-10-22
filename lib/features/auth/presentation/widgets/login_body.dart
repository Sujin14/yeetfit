import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/widget_styles.dart';
import 'login_form.dart';
import 'login_header.dart';
import 'login_options_divider.dart';
import 'login_social_buttons.dart';
import 'signup_redirect.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100.h),
        const LoginHeader(),
        SizedBox(height: 24.h),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: WidgetStyles.containerBorderRadius(),
            ),
            padding: WidgetStyles.formPadding(kIsWeb),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const LoginForm(),
                  SizedBox(height: 32.h),
                  const LoginOptionsDivider(),
                  SizedBox(height: 24.h),
                  const LoginSocialButtons(),
                  SizedBox(height: 32.h),
                  const Center(child: SignupRedirect()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}