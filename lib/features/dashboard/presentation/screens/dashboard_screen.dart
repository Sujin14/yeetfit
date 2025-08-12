import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_body.dart';
import '../widgets/bmi_suggestions.dart';
import '../widgets/welcome_text.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return const Color(0xFFFF6B6B); // Underweight: Red
    if (bmi < 25) return const Color(0xFF4CAF50); // Normal: Green
    if (bmi < 30) return const Color(0xFFFFD700); // Overweight: Yellow
    return const Color(0xFFFFB347); // Obesity: Orange
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obesity';
  }

  String _getBMISuggestion(double bmi) {
    if (bmi < 18.5) {
      return 'Consider a balanced diet with more calories and consult a nutritionist.';
    }
    if (bmi < 25) {
      return 'Great job! Maintain a healthy lifestyle with regular exercise and balanced nutrition.';
    }
    if (bmi < 30) {
      return 'Incorporate regular physical activity and a balanced diet to achieve a healthy weight.';
    }
    return 'Consult a healthcare professional for a personalized weight management plan.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Scaffold(
        backgroundColor: AppTheme.colors['lightBackground'],
        body: const Center(child: Text('Please log in to view dashboard')),
      );
    }

    final bmiAsync = ref.watch(bmiFutureProvider(userId));
    final userDataAsync = ref.watch(userDataFutureProvider(userId));

    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'],
      body: Stack(
        children: [
          bmiAsync.when(
            data: (bmi) {
              final bmiColor = _getBMIColor(bmi);
              final bmiCategory = _getBMICategory(bmi);
              final bmiSuggestion = _getBMISuggestion(bmi);
              return Container(
                height: 285.h,
                width: double.infinity,
                color: bmiColor.withOpacity(0.3),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userDataAsync.when(
                        data: (userData) => WelcomeText(name: userData?['name'] ?? 'User'),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Text('Error: $error', style: AppTheme.textStyles['body']),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Your BMI: ${bmi.toStringAsFixed(1)}',
                        style: AppTheme.textStyles['heading']!.copyWith(
                          fontSize: 24.sp,
                          color: AppTheme.colors['primaryText'],
                        ),
                      ),
                      SizedBox(height: 6.h),
                      BMISuggestions(category: bmiCategory, suggestion: bmiSuggestion),
                    ],
                  ),
                ),
              );
            },
            loading: () => Container(
              height: 280.h,
              color: AppTheme.colors['secondaryText']!.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Container(
              height: 280.h,
              color: AppTheme.colors['error']!.withOpacity(0.2),
              child: Center(child: Text('Error loading BMI: $error')),
            ),
          ),
          // Scrollable container
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.colors['lightBackground'],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: DashboardBody(userId: userId),
                ),
              );
            },
          ),
          // Chatbot FAB
          Positioned(
            bottom: 90.h,
            right: 16.w,
            child: GestureDetector(
              onTap: () {
                context.go('/chatbot');
              },
              child: Image.asset(
                'assets/images/chatbot.png',
                width: 56.w,
                height: 56.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Chat FAB
          Positioned(
            bottom: 16.h,
            right: 16.w,
            child: FloatingActionButton(
              backgroundColor: AppTheme.colors['primaryAccent'],
              foregroundColor: AppTheme.colors['onSurfaceDark'],
              onPressed: () {
                final hasPaid = ref.read(paymentStatusProvider).value ?? false;
                if (hasPaid) {
                  context.go('/chat', extra: 'KzWEi9szv2dg9wvEKN6ZEGmZt7L2');
                } else {
                  context.go('/payment');
                }
              },
              heroTag: 'chat_fab',
              child: Icon(Icons.chat, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }
}