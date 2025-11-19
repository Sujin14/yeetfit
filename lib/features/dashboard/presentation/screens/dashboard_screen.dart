import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../providers/bmi_provider.dart';
import '../providers/user_data_provider.dart';
import '../widgets/bmi_suggestions.dart';
import '../widgets/dashboard_body.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final colors = Theme.of(context).extension<AppColors>()!;

    if (userId == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: const Center(child: Text('Please log in to view dashboard')),
      );
    }

    final bmiAsync = ref.watch(bmiStreamProvider(userId));
    final userDataAsync = ref.watch(userDataFutureProvider(userId));
    final paymentStatusAsync = ref.watch(paymentStatusProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          bmiAsync.when(
            data: (bmi) => BMISuggestions(userData: userDataAsync, userId: userId),
            loading: () => Container(
              color: colors.onSurface.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Container(
              color: colors.error.withOpacity(0.2),
              child: Center(child: Text('Error loading BMI: $error')),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 1.0,
            builder: (context, scrollController) => Container(
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: DashboardBody(userId: userId),
              ),
            ),
          ),
          Positioned(
            bottom: 90,
            right: 16,
            child: GestureDetector(
              onTap: () => context.go('/chatbot'),
              child: Image.asset(
                'assets/images/chatbot.png',
                width: 56,
                height: 56,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: colors.primary,
              foregroundColor: colors.onSurface,
              onPressed: () {
                paymentStatusAsync.when(
                  data: (hasPaid) => context.go(hasPaid ? '/admin-list' : '/payment'),
                  loading: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checking payment status...')),
                  ),
                  error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  ),
                );
              },
              heroTag: 'chat_fab',
              child: const Icon(Icons.chat, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}