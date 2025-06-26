import 'package:flutter/material.dart';
import 'admin_login_form.dart';

class AdminLoginBody extends StatelessWidget {
  const AdminLoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [SizedBox(height: 20), AdminLoginForm()],
        ),
      ),
    );
  }
}
