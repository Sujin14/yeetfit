import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'welcome_button.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset('assets/images/welcome.png', height: 220),
          const SizedBox(height: 32),
          const Text(
            "Welcome to YeetFit",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            "Track your health. Follow your goals.",
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          WelcomeButton(
            label: "Login",
            onPressed: () => context.push('/login'),
          ),
          const SizedBox(height: 12),
          WelcomeButton(
            label: "Login as Admin",
            onPressed: () => context.push('/admin-login'),
            color: Colors.grey.shade800,
          ),
        ],
      ),
    );
  }
}
