import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () async {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // TODO: Fetch role from Firestore to confirm role
        bool isAdmin = user.email?.endsWith('@admin.com') ?? false;

        context.go(isAdmin ? '/admin-dashboard' : '/user-dashboard');
      } else {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash_screen.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
