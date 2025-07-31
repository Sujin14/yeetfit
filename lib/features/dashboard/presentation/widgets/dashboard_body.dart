import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/dashboard_provider.dart';
import 'progress_card_list.dart';
import 'welcome_text.dart';
import 'bmi_card.dart';

class DashboardBody extends ConsumerWidget {
  final String userId;

  const DashboardBody({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userDataFutureProvider(userId));
    final progressAsync = ref.watch(dailyProgressStreamProvider(userId));
    final bmiAsync = ref.watch(bmiFutureProvider(userId));

    print('DashboardBody: Building for userId=$userId');

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight - 16.h,
          ),
          child: userDataAsync.when(
            data: (userData) {
              if (userData == null) {
                print('DashboardBody: No user data for userId=$userId');
                return const Center(child: Text('No user data available'));
              }
              return progressAsync.when(
                data: (progress) {
                  print('DashboardBody: Progress data for userId=$userId: $progress');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WelcomeText(name: userData['name'] ?? 'User'),
                      SizedBox(height: 16.h),
                      bmiAsync.when(
                        data: (bmi) => BMICard(bmi: bmi),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Center(child: Text('Error loading BMI: $error')),
                      ),
                      SizedBox(height: 16.h),
                      ProgressCardsList(progress: progress, userId: userId),
                    ],
                  );
                },
                loading: () {
                  print('DashboardBody: Loading progress for userId=$userId');
                  return const Center(child: CircularProgressIndicator());
                },
                error: (error, _) {
                  print('DashboardBody: Error loading progress for userId=$userId: $error');
                  return Center(child: Text('Error: $error'));
                },
              );
            },
            loading: () {
              print('DashboardBody: Loading user data for userId=$userId');
              return const Center(child: CircularProgressIndicator());
            },
            error: (error, _) {
              print('DashboardBody: Error loading user data for userId=$userId: $error');
              return Center(child: Text('Error: $error'));
            },
          ),
        ),
      ),
    );
  }
}