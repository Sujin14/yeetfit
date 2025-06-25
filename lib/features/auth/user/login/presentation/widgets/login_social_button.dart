import 'package:flutter/material.dart';
import 'google_button.dart';

class LoginSocialButtons extends StatelessWidget {
  const LoginSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GoogleButton(),
        //SizedBox(height: 30.h),
        //const PhoneButton(),
      ],
    );
  }
}
