import 'package:flutter/material.dart';
import 'welcome_button.dart';
import '../phone_auth_screen.dart';
import '../../admin/presentation/admin_login_screen.dart'; // you will create this later

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
            label: "Login / Sign up",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          WelcomeButton(
            label: "Login as Admin",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
              );
            },
            color: Colors.grey.shade800,
          ),
        ],
      ),
    );
  }
}
