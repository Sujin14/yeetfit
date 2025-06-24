import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/controllers/google-auth_controller.dart';

class GoogleButton extends ConsumerWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(googleAuthControllerProvider);

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Image.asset('assets/icons/google.png', height: 24),
        label: const Text("Sign in with Google"),
        onPressed: isLoading
            ? null
            : () => ref
                  .read(googleAuthControllerProvider.notifier)
                  .login(context),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
