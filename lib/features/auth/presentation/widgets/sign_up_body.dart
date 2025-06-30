import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: 22.sp),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SignUpHeader(),
          SizedBox(height: 40.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SignUpForm(),
                    SizedBox(height: 30.h),
                    const LoginOptionsDivider(),
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
