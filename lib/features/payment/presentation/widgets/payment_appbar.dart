import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/payment_provider.dart';

class PaymentAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PaymentAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(paymentControllerProvider.notifier);
    return AppBar(
      backgroundColor: AppTheme.colors['transparent'],
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppTheme.colors['primaryIcon'],
        ),
        onPressed: () => controller.navigateBack(context),
      ),
      title: Text(
        'Unlock Chat Feature',
        style: AppTheme.textStyles['title']!.copyWith(
          color: AppTheme.colors['onSurface'],
        ),
      ),
    );
  }
}