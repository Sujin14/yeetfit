// forgot_password_button.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/email_auth_controller.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

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
      child: Text(
        "Forgot Password?",
        style: AppTheme.textStyles['body']!.copyWith(
          fontSize: FixedSizes.fontBody(context),
          color: AppTheme.colors['primaryAccent'],
        ),
      ),
    );
  }

  Future<String?> _askForEmailDialog(BuildContext context) async {
    String email = '';
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Reset Password",
          style: AppTheme.textStyles['title']!.copyWith(
            fontSize: FixedSizes.fontTitle(context),
            color: AppTheme.colors['primaryText'],
          ),
        ),
        content: TextField(
          decoration: InputDecoration(
            labelText: "Enter your email",
            labelStyle: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['secondaryText'],
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => email = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['error'],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, email),
            child: Text(
              "Send",
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['primaryText'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
