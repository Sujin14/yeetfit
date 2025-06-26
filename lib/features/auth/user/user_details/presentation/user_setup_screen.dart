import 'package:flutter/material.dart';

class UserSetupScreen extends StatelessWidget {
  const UserSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome! Setup your profile here.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
