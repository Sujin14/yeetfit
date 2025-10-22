import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/auth_route_constants.dart';
import '../../../../shared/theme/theme.dart';

// Redirect text to login screen.
class SignInRedirect extends StatelessWidget {
  const SignInRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AuthRouteConstants.root), 
      child: Text(
        "Already have an account? Sign in",
        style: AppTheme.textStyles['body']!.copyWith(
          fontSize: (kIsWeb ? 14.sp : 12.sp).clamp(10.0, 14.0),
          fontWeight: FontWeight.bold,
          color: AppTheme.colors['primaryAccent'],
        ),
      ),
    );
  }
}