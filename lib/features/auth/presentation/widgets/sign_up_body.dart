import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yeetfit/shared/theme/theme.dart';
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
            fontSize: (kIsWeb ? 22.sp : 20.sp).clamp(18.0, 22.0),
            color: AppTheme.colors['primaryText'],
          ),
        ),
        backgroundColor: AppTheme.colors['transparent']!,
        elevation: 0,
      ),
      body: Column(
        children: [
          SignUpHeader(),
          SizedBox(height: kIsWeb ? 30.h : 20.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: kIsWeb ? 40.w : 24.w,
                vertical: kIsWeb ? 24.h : 16.h,
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
                    SizedBox(height: 30.h),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: kIsWeb ? 400.w : 350.w,
                      ),
                      child: const LoginOptionsDivider(),
                    ),
                    SizedBox(height: 30.h),
                    const LoginSocialButtons(),
                    SizedBox(height: 30.h),
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