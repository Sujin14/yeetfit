import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/theme/theme.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../widgets/dashboard_body.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Scaffold(
        backgroundColor: AppTheme.colors['lightBackground'],
        body: const Center(child: Text('Please log in to view dashboard')),
      );
    }
    return Scaffold(
      body: DashboardBody(userId: userId),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.colors['primaryAccent'] ?? Colors.blue,
        foregroundColor: AppTheme.colors['onSurfaceDark'] ?? Colors.white,
        onPressed: () {
          final hasPaid = ref.read(paymentStatusProvider).value ?? false;
          if(hasPaid){
            context.go('/chat', extra: 'KzWEi9szv2dg9wvEKN6ZEGmZt7L2');
          } else {
            context.go('/payment');
          }
          
        },
        child: Icon(Icons.chat, size: 24.sp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
