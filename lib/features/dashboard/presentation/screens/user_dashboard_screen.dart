import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/gradient_text.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'YeetFit Dashboard',
          style: AppTheme.textStyles['title']!.copyWith(fontSize: 20.sp),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.go('/welcome');
            },
          ),
        ],
      ),
      body: const DashboardBody(),
    );
  }
}

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientText(
              text: 'Your Fitness Hub',
              style: AppTheme.textStyles['heading']!.copyWith(fontSize: 28.sp),
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.yellow, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Welcome to your personalized dashboard! Track your progress and achieve your goals.',
              style: AppTheme.textStyles['subtitle']!.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 24.h),
            // Placeholder for dashboard content
            Expanded(
              child: Center(
                child: Text(
                  'Dashboard Content Coming Soon!',
                  style: AppTheme.textStyles['body']!.copyWith(fontSize: 18.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
