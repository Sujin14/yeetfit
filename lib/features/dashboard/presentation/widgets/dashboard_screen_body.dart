import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/bmi_suggestions.dart';
import '../widgets/dashboard_body.dart';

class DashboardScreenBody extends ConsumerWidget {
  const DashboardScreenBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Center(
        child: Text(
          'Please log in to view dashboard',
          style: AppTheme.textStyles['bodyMedium']!.copyWith(
            color: AppTheme.colors['primaryText'],
          ),
        ),
      );
    }

    final bmiAsync = ref.watch(bmiStreamProvider(userId));
    final userDataAsync = ref.watch(userDataFutureProvider(userId));
    final controller = ref.read(dashboardProvider(userId).notifier);

    return Stack(
      children: [
        bmiAsync.when(
          data: (bmi) => BMISuggestions(
            userData: userDataAsync,
            userId: userId,
          ),
          loading: () => Container(
            color: AppTheme.colors['secondaryText']!.withOpacity(0.2),
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Container(
            color: AppTheme.colors['error']!.withOpacity(0.2),
            child: Center(
              child: Text(
                'Error loading BMI: $error',
                style: AppTheme.textStyles['bodyMedium']!.copyWith(
                  color: AppTheme.colors['error'],
                ),
              ),
            ),
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.7,
          maxChildSize: 1.0,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: AppTheme.colors['lightBackground'],
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: DashboardBody(userId: userId),
            ),
          ),
        ),
        Positioned(
          bottom: 90.h,
          right: 16.w,
          child: GestureDetector(
            onTap: () => controller.navigateToChatbot(context),
            child: Image.asset(
              'assets/images/chatbot.png',
              width: 56.w,
              height: 56.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          bottom: 16.h,
          right: 16.w,
          child: FloatingActionButton(
            backgroundColor: AppTheme.colors['primaryAccent'],
            foregroundColor: AppTheme.colors['onSurfaceDark'],
            onPressed: () => controller.navigateToChat(context),
            heroTag: 'chat_fab',
            child: Icon(Icons.chat, size: 24.sp),
          ),
        ),
      ],
    );
  }
}