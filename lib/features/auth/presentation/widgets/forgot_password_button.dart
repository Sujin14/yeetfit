import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/auth_result.dart';
import '../providers/auth_providers.dart';
import '../../utils/auth_strings.dart';
import '../../utils/widget_styles.dart';
import '../../../../shared/theme/theme.dart';

class ForgotPasswordButton extends ConsumerWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        final email = await _askForEmailDialog(context);
        if (email != null && email.trim().isNotEmpty) {
          final result = await ref
              .read(resetPasswordControllerProvider.notifier)
              .resetPassword(email.trim());
          _showSnackBar(context, result);
        }
      },
      child: Text(
        "Forgot Password?",
        style: WidgetStyles.linkTextStyle(kIsWeb),
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
            fontSize: (kIsWeb ? 20.sp : 18.sp).clamp(16.0, 20.0),
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

  void _showSnackBar(BuildContext context, AuthResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? AuthStrings.genericError),
        backgroundColor: result.success ? AppTheme.colors['success'] : AppTheme.colors['error'],
      ),
    );
  }
}