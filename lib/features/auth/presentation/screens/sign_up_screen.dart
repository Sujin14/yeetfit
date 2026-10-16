import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/auth_background.dart';
import '../widgets/sign_up_body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthBackground(
      child: Scaffold(backgroundColor: Colors.transparent, body: SignUpBody()),
    );
  }
}
