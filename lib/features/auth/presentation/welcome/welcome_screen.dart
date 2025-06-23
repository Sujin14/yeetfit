import 'package:flutter/material.dart';
import 'welcome_body.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: WelcomeBody());
  }
}
