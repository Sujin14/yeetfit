import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/auth_result.dart';
import '../providers/auth_providers.dart';
import '../../utils/auth_strings.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class ForgotPasswordButton extends ConsumerWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return TextButton(
      onPressed: () async {
        final email = await _askForEmailDialog(context);
        if (email != null && email.trim().isNotEmpty) {
          final result = await ref
              .read(resetPasswordControllerProvider.notifier)
              .resetPassword(email.trim());
          if (!context.mounted) return;
          _showSnackBar(context, result);
        }
      },
      child: Text(
        'Forgot password?',
        style: Theme.of(
          context,
        ).textTheme.labelLarge!.copyWith(color: colors.onBackground),
      ),
    );
  }

  Future<String?> _askForEmailDialog(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    String email = '';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          'Reset Password',
          style: textTheme.titleLarge!.copyWith(color: colors.onSurface),
        ),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Enter your email',
            labelStyle: textTheme.bodyMedium!.copyWith(
              color: colors.textSecondary,
            ),
          ),
          style: textTheme.bodyLarge!.copyWith(color: colors.onSurface),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => email = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: textTheme.bodyMedium!.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, email),
            style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
            child: Text(
              'Send',
              style: textTheme.bodyMedium!.copyWith(color: colors.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, AuthResult result) {
    final colors = Theme.of(context).extension<AppColors>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? AuthStrings.genericError),
        backgroundColor: result.success ? colors.success : colors.error,
      ),
    );
  }
}
