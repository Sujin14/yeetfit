import 'package:flutter/material.dart';
import 'admin_login_form.dart';

class AdminLoginBody extends StatelessWidget {
  const AdminLoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Admin Login",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            AdminLoginForm(),
          ],
        ),
      ),
    );
  }
}
