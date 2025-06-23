import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/auth/presentation/controller/email_auth_controller.dart';

class ForgotPasswordButton extends ConsumerWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        final email = await _askForEmailDialog(context);
        if (email != null && email.trim().isNotEmpty) {
          await ref
              .read(emailAuthControllerProvider.notifier)
              .resetPassword(email.trim(), context);
        }
      },
      child: const Text("Forgot Password?"),
    );
  }

  Future<String?> _askForEmailDialog(BuildContext context) async {
    String email = '';
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reset Password"),
        content: TextField(
          decoration: const InputDecoration(labelText: "Enter your email"),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => email = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, email),
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }
}
