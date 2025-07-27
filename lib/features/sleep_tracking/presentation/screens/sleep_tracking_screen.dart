import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/sleep_app_bar.dart';
import '../widgets/sleep_chart_section.dart';
import '../widgets/sleep_entry_dialog.dart';
import '../widgets/sleep_progress_section.dart';
import '../widgets/sleep_time_card.dart';
import '../widgets/sleep_tips_card.dart';
import '../providers/sleep_provider.dart';

class SleepTrackingScreen extends ConsumerWidget {
  const SleepTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track sleep')),
      );
    }

    final today = DateTime.now().toIso8601String().split('T')[0];

    return Scaffold(
      appBar: const SleepAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 20.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final duration = ref.watch(sleepDurationProvider(userId).select((value) => value.value ?? 0.0));
                    final goalHours = ref.watch(sleepGoalProvider(userId).select((value) => value.value ?? 8.0));
                    final progressColor = ref.watch(dailySleepProgressColorProvider('$userId|$today'));
                    return SleepProgressSection(
                      duration: duration,
                      goalHours: goalHours,
                      progressColor: progressColor,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, _) {
                    final sleepTimesAsync = ref.watch(sleepTimesProvider(userId));
                    return sleepTimesAsync.when(
                      data: (sleepTimes) => SleepTimeCards(
                        bedtime: sleepTimes['bedtime'],
                        wakeUpTime: sleepTimes['wakeUpTime'],
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Center(child: Text('Error: $error')),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const SleepTipsCard(),
                const SizedBox(height: 20),
                SleepChartSection(userId: userId),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F51B5).withOpacity(0.3),
        onPressed: () => _showSleepEntryDialog(context, ref, userId),
        child: const Icon(
          Icons.bed,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showSleepEntryDialog(BuildContext context, WidgetRef ref, String userId) {
    showDialog(
      context: context,
      builder: (context) => SleepEntryDialog(userId: userId),
    );
  }
}