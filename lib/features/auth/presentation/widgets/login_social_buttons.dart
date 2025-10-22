import 'package:flutter/material.dart';
import 'google_button.dart';

// Container for social login buttons.
class LoginSocialButtons extends StatelessWidget {
  const LoginSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [GoogleButton()]);
  }
}
