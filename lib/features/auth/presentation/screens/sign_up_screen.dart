import 'package:flutter/material.dart';
import '../widgets/sign_up_body.dart';

// Screen for user sign up.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SignUpBody());
  }
}