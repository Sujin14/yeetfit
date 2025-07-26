import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../widgets/dashboard_body.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'],
      body: const DashboardBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.colors['primaryAccent'] ?? Colors.blue, // Fallback color
        foregroundColor: AppTheme.colors['onSurfaceDark'] ?? Colors.white, // Fallback color
        onPressed: () {
          print('FAB tapped'); // Debug log
          final hasPaid = ref.read(paymentStatusProvider).value ?? false;
          print('Payment status: $hasPaid'); // Debug log
          if (hasPaid) {
            context.go('/chat', extra: 'KzWEi9szv2dg9wvEKN6ZEGmZt7L2');
          } else {
            context.go('/chat', extra: 'KzWEi9szv2dg9wvEKN6ZEGmZt7L2');
          }
        },
        child: Icon(Icons.chat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}