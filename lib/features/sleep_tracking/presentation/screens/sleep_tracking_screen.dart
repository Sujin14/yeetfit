import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/sleep_provider.dart';
import '../widgets/sleep_animation.dart';
import '../widgets/sleep_app_bar.dart';
import '../widgets/sleep_chart_section.dart';
import '../widgets/sleep_entry_dialog.dart';
import '../widgets/sleep_progress_section.dart';
import '../widgets/sleep_time_card.dart';
import '../widgets/sleep_tips_card.dart';
import '../../../../shared/widgets/entry_dialog.dart';
import '../../../../shared/theme/theme.dart';

// Main screen for sleep tracking.
class SleepTrackingScreen extends ConsumerWidget {
  const SleepTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track sleep')),
      );
    }

    return Scaffold(
      appBar: const SleepAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SleepAnimation(),
                SizedBox(height: 25.h),
                const SleepProgressSection(),
                SizedBox(height: 30.h),
                SleepTimeCards(userId: userId),
                SizedBox(height: 20.h),
                const SleepTipsCard(),
                SizedBox(height: 20.h),
                SleepChartSection(userId: userId),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.colors['indigo']!.withOpacity(0.7),
        onPressed: () => entryDialog(
          context: context,
          ref: ref,
          dialog: SleepEntryDialog(userId: userId),
        ),
        child: Icon(Icons.bed_rounded, color: AppTheme.colors['white']),
      ),
    );
  }
}