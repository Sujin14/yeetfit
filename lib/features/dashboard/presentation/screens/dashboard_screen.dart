import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/progress_card_list.dart';
import '../widgets/welcome_text.dart';
import '../widgets/bmi_card.dart';

class DashboardBody extends ConsumerWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    final progress = ref.watch(dailyProgressProvider);
    final bmi = ref.watch(bmiProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeText(name: userData['name']),
          SizedBox(height: 16.h),
          BMICard(bmi: bmi),
          SizedBox(height: 16.h),
          ProgressCardsList(progress: progress),
        ],
      ),
    );
  }
}
