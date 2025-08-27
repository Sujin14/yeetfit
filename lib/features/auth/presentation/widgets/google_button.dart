import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/google_auth_controller.dart';
import '../../../../shared/theme/theme.dart';

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
            : () => ref
                  .read(googleAuthControllerProvider.notifier)
                  .login(context),
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
}
