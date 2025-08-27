import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/entry_dialog.dart';
import '../../../../utils/fixed_sizes.dart';
import '../widgets/sleep_animation.dart';
import '../widgets/sleep_app_bar.dart';
import '../widgets/sleep_chart_section.dart';
import '../widgets/sleep_progress_section.dart';
import '../widgets/sleep_time_card.dart';
import '../widgets/sleep_tips_card.dart';
import '../providers/sleep_provider.dart';
import '../widgets/sleep_entry_dialog.dart';

class SleepTrackingScreen extends ConsumerWidget {
  const SleepTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track sleep')),
      );
    }

    return Scaffold(
      appBar: const SleepAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: FixedSizes.box620(context)),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: FixedSizes.spacing(context),
              vertical: FixedSizes.spacing(context) * 1.5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SleepAnimation(),
                SizedBox(height: FixedSizes.box25(context)),
                const SleepProgressSection(),
                SizedBox(height: FixedSizes.box30(context)),
                const SleepTimeCards(),
                SizedBox(height: FixedSizes.box20(context)),
                const SleepTipsCard(),
                SizedBox(height: FixedSizes.box20(context)),
                SleepChartSection(userId: userId),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.colors['indigo']!.withOpacity(0.7),
        onPressed: () {
          entryDialog(
            context: context,
            ref: ref,
            dialog: SleepEntryDialog(userId: userId),
          );
        },
        child: Icon(Icons.bed_rounded, color: AppTheme.colors['white']!),
      ),
    );
  }
}
