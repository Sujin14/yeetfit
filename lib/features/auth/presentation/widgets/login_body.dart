import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yeetfit/shared/theme/theme.dart';
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
            fontSize: (kIsWeb ? 22.sp : 20.sp).clamp(18.0, 22.0),
            color: AppTheme.colors['primaryText'],
          ),
        ),
        backgroundColor: AppTheme.colors['transparent']!,
        elevation: 0,
      ),
      body: Column(
        children: [
          LoginHeader(),
          SizedBox(height: kIsWeb ? 40.h : 30.h),
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
                    const LoginForm(),
                    SizedBox(height: 30.h),
                    const LoginOptionsDivider(),
                    SizedBox(height: 30.h),
                    const LoginSocialButtons(),
                    SizedBox(height: 30.h),
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