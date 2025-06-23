import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/features/auth/presentation/controller/user_controllers/phone_auth_controller.dart';

class PhoneButton extends ConsumerWidget {
  const PhoneButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.phone_android),
        label: const Text("Sign in with Phone"),
        onPressed: () {
          _askPhoneNumber(context, ref);
        },
      ),
    );
  }

  void _askPhoneNumber(BuildContext context, WidgetRef ref) {
    String phone = "";
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Phone Number"),
        content: TextField(
          keyboardType: TextInputType.phone,
          onChanged: (value) => phone = value,
          decoration: const InputDecoration(hintText: "+91XXXXXXXXXX"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(phoneAuthControllerProvider.notifier)
                  .phoneLogin(phone.trim(), context);
            },
            child: const Text("Send OTP"),
          ),
        ],
      ),
    );
  }
}
