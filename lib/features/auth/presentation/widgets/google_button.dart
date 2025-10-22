import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/auth_route_constants.dart';
import '../../../../core/routes/shell_route_constants.dart';
import '../../domain/entities/auth_result.dart';
import '../providers/auth_providers.dart';
import '../../../../shared/theme/theme.dart';

// Button for Google sign-in.
class GoogleButton extends ConsumerWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(googleAuthControllerProvider);
    final maxButtonWidth = kIsWeb ? 300.w : 250.w;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxButtonWidth),
      child: IconButton(
        icon: Image.asset(
          'assets/icons/google.png',
          height: (kIsWeb ? 100.h : 80.h).clamp(60.0, 100.0),
        ),
        onPressed: isLoading
            ? null
            : () async {
                final result = await ref
                    .read(googleAuthControllerProvider.notifier)
                    .login();
                _handleAuthResult(context, result);
              },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: kIsWeb ? 16.h : 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          side: BorderSide(color: AppTheme.colors['transparent']!),
        ),
      ),
    );
  }

  // Handles post-auth navigation and feedback.
  void _handleAuthResult(BuildContext context, AuthResult result) {
    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'Google Sign-In failed')),
      );
      return;
    }

    final exists = result.userExists;
    if (exists == true) {
      context.go(ShellRouteConstants.dashboard);
    } else {
      context.go(AuthRouteConstants.userInfoStep.replaceAll(':step', '0'));
    }
  }
}