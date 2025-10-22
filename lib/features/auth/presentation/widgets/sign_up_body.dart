import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_options_divider.dart';
import 'login_social_buttons.dart';
import 'sign_in_redirect.dart';
import 'sign_up_form.dart';
import 'sign_up_header.dart';

// Body widget for sign up screen.
class SignUpBody extends StatelessWidget {
  const SignUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100.h),
        const SignUpHeader(),
        SizedBox(height: 24.h),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: kIsWeb ? 40.w : 24.w,
              vertical: 24.h,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: kIsWeb ? 400.w : 350.w,
                    ),
                    child: const SignUpForm(),
                  ),
                  SizedBox(height: 32.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: kIsWeb ? 400.w : 350.w,
                    ),
                    child: const LoginOptionsDivider(),
                  ),
                  SizedBox(height: 24.h),
                  const LoginSocialButtons(),
                  SizedBox(height: 32.h),
                  const Center(child: SignInRedirect()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
