// google_button.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/google_auth_controller.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class GoogleButton extends ConsumerWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(googleAuthControllerProvider);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: FixedSizes.authButtonWidth(context)),
      child: IconButton(
        icon: Image.asset(
          'assets/icons/google.png',
          height: FixedSizes.googleIcon(context),
        ),
        onPressed: isLoading
            ? null
            : () => ref
                  .read(googleAuthControllerProvider.notifier)
                  .login(context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: FixedSizes.box16(context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FixedSizes.borderRadius(context)),
          ),
          side: BorderSide(color: AppTheme.colors['transparent']!),
        ),
      ),
    );
  }
}
