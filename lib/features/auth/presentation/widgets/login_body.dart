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
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppTheme.colors['transparent'],
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.colors['primaryAccent']!.withOpacity(0.8),
                AppTheme.colors['primaryAccent']!.withOpacity(0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const LoginHeader(),
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
      ),
    );
  }
}
