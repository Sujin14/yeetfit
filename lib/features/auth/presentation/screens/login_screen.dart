import 'package:flutter/material.dart';
import '../widgets/login_body.dart';

// Screen for user login.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginBody());
  }
}