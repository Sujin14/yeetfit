import 'package:flutter/material.dart';
import 'login_form.dart';
import 'google_button.dart';
import 'phone_button.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Login to your account', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 32),
            const LoginForm(),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("or continue with"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),
            const GoogleButton(),
            const SizedBox(height: 12),
            const PhoneButton(),
          ],
        ),
      ),
    );
  }
}
