// features/dashboard/presentation/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_body.dart';
import '../widgets/bmi_suggestions.dart';

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

    // Single source of truth for the BMI stream — pass down the value.
    final bmiAsync = ref.watch(bmiStreamProvider(userId));
    final userDataAsync = ref.watch(userDataFutureProvider(userId));
    final paymentStatusAsync = ref.watch(paymentStatusProvider);

    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'],
      body: Stack(
        children: [
          // BMI header / suggestions (uses bmiAsync directly)
          bmiAsync.when(
            data: (bmi) => BMISuggestions(
              bmi: bmi,
              userData: userDataAsync,
              userId: userId,
            ),
            loading: () => Container(
              color: AppTheme.colors['secondaryText']!.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Container(
              color: AppTheme.colors['error']!.withOpacity(0.2),
              child: Center(child: Text('Error loading BMI: $error')),
            ),
          ),

          // Draggable sheet containing the rest of dashboard body (progress cards, meal card, etc.)
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 1.0,
            builder: (context, scrollController) => Container(
              decoration: BoxDecoration(
                color: AppTheme.colors['lightBackground'],
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(FixedSizes.borderRadius(context) / 2),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: DashboardBody(userId: userId),
              ),
            ),
          ),

          // Chatbot shortcut
          Positioned(
            bottom: FixedSizes.box100(context) * 0.9, // similar to bottom: 90.h
            right: FixedSizes.box16(context),
            child: GestureDetector(
              onTap: () => context.go('/chatbot'),
              child: Image.asset(
                'assets/images/chatbot.png',
                width: FixedSizes.box50(context) * 1.12, // ~56
                height: FixedSizes.box50(context) * 1.12,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Floating action button that checks payment status before navigating
          Positioned(
            bottom: FixedSizes.box16(context),
            right: FixedSizes.box16(context),
            child: FloatingActionButton(
              backgroundColor: AppTheme.colors['primaryAccent'],
              foregroundColor: AppTheme.colors['onSurfaceDark'],
              onPressed: () {
                paymentStatusAsync.when(
                  data: (hasPaid) {
                    if (hasPaid) {
                      context.go('/admin-list');
                    } else {
                      context.go('/payment');
                    }
                  },
                  loading: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Checking payment status...'),
                      ),
                    );
                  },
                  error: (e, _) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  },
                );
              },
              heroTag: 'chat_fab',
              child: Icon(Icons.chat, size: FixedSizes.font16(context) * 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
