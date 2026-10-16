import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/auth_background.dart';
import '../widgets/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthBackground(
      child: Scaffold(backgroundColor: Colors.transparent, body: LoginBody()),
    );
  }
}
