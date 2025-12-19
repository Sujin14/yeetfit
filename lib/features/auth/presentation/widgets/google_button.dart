import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/auth_providers.dart';
import '../../utils/navigation_utils.dart';
import '../../utils/auth_strings.dart';
import '../../utils/widget_styles.dart';
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
            : () async {
                final result = await ref
                    .read(googleAuthControllerProvider.notifier)
                    .login();
                handleAuthResult(context, result, AuthStrings.googleSignInFailed);
              },
        style: OutlinedButton.styleFrom(
          padding: WidgetStyles.buttonPadding(kIsWeb),
          shape: RoundedRectangleBorder(
            borderRadius: WidgetStyles.buttonBorderRadius(),
          ),
          side: WidgetStyles.transparentBorder(),
          backgroundColor: AppTheme.colors['transparent'],
        ),
      ),
    );
  }
}