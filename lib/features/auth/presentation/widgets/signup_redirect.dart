import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';

class SignupRedirect extends StatelessWidget {
  const SignupRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/signup'),
      child: Text(
        "Don't have an account? Sign up",
        style: AppTheme.textStyles['body']!.copyWith(
          fontSize: (kIsWeb ? 14.sp : 12.sp).clamp(10.0, 14.0),
          fontWeight: FontWeight.bold,
          color: AppTheme.colors['primaryAccent'],
        ),
      ),
    );
  }
}